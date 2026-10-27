module Flow exposing (Arrow, Box, Chart, Layout, Placed, Role(..), Route, layout, parse)

{-| The `## Flow` section of a page: a flowchart written as one line per box and one line per arrow (the same text
`Wiki.Content.Flow` checks on the server, requirement FL-1):

    trigger t: Giovanni asks | [[giovanni]]
    step s: Reads the brief | [[session-brief]]
    decide d: Did it change a system?
    product p: Page updated

    t -> s
    s -> d
    d -yes-> p

`parse` reads that text; `layout` puts the boxes in rows, top to bottom, in four steps: each box goes to the row after its
last predecessor (longest path), an arrow that skips rows gets an invisible stopover in each row it crosses, the order inside
every row is improved by averaging the neighbours' places (the barycenter method), and the columns are then set so that
connected boxes line up as far as the spacing allows (an isotonic regression, see `squeeze`).
The arrows are drawn with elm-visualization's `Shape.bumpYCurve` (see FlowView).
-}

import Dict exposing (Dict)
import Regex exposing (Regex)
import Set


type Role
    = Trigger
    | Step
    | Decide
    | Product


type alias Box =
    { id : String
    , role : Role
    , label : String
    , links : List String
    }


type alias Arrow =
    { from : String
    , to : String
    , label : String
    }


type alias Chart =
    { boxes : List Box
    , arrows : List Arrow
    }


{-| A box with its place: the centre, the size and the label cut into lines. -}
type alias Placed =
    { box : Box
    , x : Float
    , y : Float
    , w : Float
    , h : Float
    , lines : List String
    }


{-| An arrow as the points it passes (bottom of the source, a stopover in each row it crosses, top of the target) and where its label sits. -}
type alias Route =
    { arrow : Arrow
    , points : List ( Float, Float )
    , labelAt : ( Float, Float )
    }


type alias Layout =
    { width : Float
    , height : Float
    , boxes : List Placed
    , routes : List Route
    }



-- PARSING


nodeLine : Regex
nodeLine =
    Regex.fromString "^(trigger|step|decide|product)\\s+([a-z][a-z0-9_]*)\\s*:\\s*(.+)$" |> Maybe.withDefault Regex.never


arrowLine : Regex
arrowLine =
    Regex.fromString "^([a-z][a-z0-9_]*)\\s+-(?:([^>]*?)-)?>\\s+([a-z][a-z0-9_]*)$" |> Maybe.withDefault Regex.never


linkIn : Regex
linkIn =
    Regex.fromString "\\[\\[([^\\]|]+)(?:\\|[^\\]]*)?\\]\\]" |> Maybe.withDefault Regex.never


{-| Reads the section text; a line that is neither a box nor an arrow is skipped (the server refuses such a page). -}
parse : String -> Chart
parse text =
    let
        lines =
            text |> String.lines |> List.map String.trim |> List.filter (not << String.isEmpty)

        boxes =
            List.filterMap parseBox lines

        arrows =
            List.filterMap parseArrow lines
    in
    { boxes = boxes, arrows = arrows }


parseBox : String -> Maybe Box
parseBox line =
    case Regex.find nodeLine line |> List.head |> Maybe.map .submatches of
        Just [ Just kind, Just id, Just rest ] ->
            let
                ( label, tail ) =
                    case String.split "|" rest of
                        first :: more ->
                            ( String.trim first, String.join "|" more )

                        [] ->
                            ( "", "" )
            in
            Just
                { id = id
                , role = roleOf kind
                , label = label
                , links = Regex.find linkIn tail |> List.filterMap (.submatches >> List.head >> Maybe.andThen identity) |> List.map String.trim
                }

        _ ->
            Nothing


parseArrow : String -> Maybe Arrow
parseArrow line =
    case Regex.find arrowLine line |> List.head |> Maybe.map .submatches of
        Just [ Just from, label, Just to ] ->
            Just { from = from, to = to, label = label |> Maybe.withDefault "" |> String.trim }

        _ ->
            Nothing


roleOf : String -> Role
roleOf kind =
    case kind of
        "trigger" ->
            Trigger

        "decide" ->
            Decide

        "product" ->
            Product

        _ ->
            Step



-- SIZES


rectWidth : Float
rectWidth =
    208


diamondWidth : Float
diamondWidth =
    236


charWidth : Float
charWidth =
    6.5


gapX : Float
gapX =
    30


gapY : Float
gapY =
    58


pad : Float
pad =
    12


{-| Greedy word wrap. -}
wrap : Int -> String -> List String
wrap perLine text =
    let
        add word ( done, current ) =
            if current == "" then
                ( done, word )

            else if String.length current + 1 + String.length word <= perLine then
                ( done, current ++ " " ++ word )

            else
                ( current :: done, word )

        ( finished, last ) =
            text |> String.words |> List.foldl add ( [], "" )
    in
    List.reverse (last :: finished) |> List.filter (not << String.isEmpty)


{-| Size and label lines of one box. A question is a diamond and its text only fits in the middle of it. -}
sizeOf : Box -> ( Float, Float, List String )
sizeOf box =
    case box.role of
        Decide ->
            let
                lines =
                    wrap 17 box.label
            in
            ( diamondWidth, max 104 (52 + 16 * toFloat (List.length lines)), lines )

        _ ->
            let
                lines =
                    wrap (floor ((rectWidth - 2 * pad) / charWidth)) box.label

                linkRow =
                    if List.isEmpty box.links then
                        0

                    else
                        20
            in
            ( rectWidth, max 52 (22 + 16 * toFloat (List.length lines) + linkRow), lines )



-- LAYOUT


type alias Item =
    { key : String
    , w : Float
    , h : Float
    }


{-| Rows top to bottom. Pure: the same text always gives the same picture. -}
layout : Chart -> Layout
layout chart =
    let
        ids =
            List.map .id chart.boxes

        known =
            Set.fromList ids

        arrows =
            List.filter (\a -> Set.member a.from known && Set.member a.to known && a.from /= a.to) chart.arrows

        ranks =
            rankAll ids arrows

        rankOf key =
            Dict.get key ranks |> Maybe.withDefault 0

        sizes =
            chart.boxes |> List.map (\b -> ( b.id, sizeOf b )) |> Dict.fromList

        -- each arrow as the chain of keys it passes: source, stopovers, target
        chains =
            arrows
                |> List.indexedMap
                    (\i a ->
                        let
                            gap =
                                rankOf a.to - rankOf a.from
                        in
                        ( a
                        , a.from
                            :: (List.range 1 (gap - 1) |> List.map (\k -> stopover i k))
                            ++ [ a.to ]
                        )
                    )

        stopoverItems =
            chains
                |> List.concatMap
                    (\( a, chain ) ->
                        chain
                            |> List.drop 1
                            |> List.take (List.length chain - 2)
                            |> List.indexedMap (\k key -> ( rankOf a.from + k + 1, { key = key, w = 16, h = 0 } ))
                    )

        boxItems =
            chart.boxes
                |> List.map
                    (\b ->
                        let
                            ( w, h, _ ) =
                                Dict.get b.id sizes |> Maybe.withDefault ( rectWidth, 52, [] )
                        in
                        ( rankOf b.id, { key = b.id, w = w, h = h } )
                    )

        rowCount =
            (Dict.values ranks |> List.maximum |> Maybe.withDefault 0) + 1

        rows0 : List (List Item)
        rows0 =
            List.range 0 (rowCount - 1)
                |> List.map (\r -> (boxItems ++ stopoverItems) |> List.filter (\( rr, _ ) -> rr == r) |> List.map Tuple.second)

        links : List ( String, String )
        links =
            chains |> List.concatMap (\( _, chain ) -> List.map2 Tuple.pair chain (List.drop 1 chain))

        arrowIndex : Dict String Int
        arrowIndex =
            -- the first arrow that points to a key, so the branches of a question keep the order they are written in
            links |> List.indexedMap (\i ( _, to ) -> ( to, i )) |> List.foldr (\( k, i ) d -> Dict.insert k i d) Dict.empty

        rows1 =
            orderRows arrowIndex links rows0

        xs =
            place links rows1

        rowHeights =
            rows1 |> List.map (\row -> row |> List.map .h |> List.maximum |> Maybe.withDefault 0)

        rowTops =
            rowHeights |> List.foldl (\h ( acc, top ) -> ( acc ++ [ top ], top + h + gapY )) ( [], pad ) |> Tuple.first

        rowCentre =
            List.map2 (\top h -> top + h / 2) rowTops rowHeights

        keyRank =
            rows1 |> List.indexedMap (\r row -> List.map (\i -> ( i.key, r )) row) |> List.concat |> Dict.fromList

        centreY key =
            Dict.get key keyRank |> Maybe.andThen (\r -> List.drop r rowCentre |> List.head) |> Maybe.withDefault 0

        halfH key =
            Dict.get key sizes |> Maybe.map (\( _, h, _ ) -> h / 2) |> Maybe.withDefault 0

        xOf key =
            Dict.get key xs |> Maybe.withDefault 0

        left =
            rows1 |> List.concat |> List.map (\i -> xOf i.key - i.w / 2) |> List.minimum |> Maybe.withDefault 0

        right =
            rows1 |> List.concat |> List.map (\i -> xOf i.key + i.w / 2) |> List.maximum |> Maybe.withDefault 0

        shift =
            pad - left

        placed =
            chart.boxes
                |> List.map
                    (\b ->
                        let
                            ( w, h, lines ) =
                                Dict.get b.id sizes |> Maybe.withDefault ( rectWidth, 52, [] )
                        in
                        { box = b, x = xOf b.id + shift, y = centreY b.id, w = w, h = h, lines = lines }
                    )

        routes =
            chains
                |> List.map
                    (\( a, chain ) ->
                        let
                            inner =
                                chain |> List.drop 1 |> List.take (List.length chain - 2)

                            pts =
                                ( xOf a.from + shift, centreY a.from + halfH a.from )
                                    :: List.map (\k -> ( xOf k + shift, centreY k )) inner
                                    ++ [ ( xOf a.to + shift, centreY a.to - halfH a.to ) ]

                            ( x0, y0 ) =
                                pts |> List.head |> Maybe.withDefault ( 0, 0 )

                            ( x1, _ ) =
                                pts |> List.drop 1 |> List.head |> Maybe.withDefault ( x0, y0 )
                        in
                        { arrow = a
                        , points = pts
                        , labelAt = ( x0 + clamp -70 70 ((x1 - x0) * 0.5) + signOf (x1 - x0) * 16, y0 + 18 )
                        }
                    )
    in
    { width = right - left + 2 * pad
    , height = (List.map2 (+) rowTops rowHeights |> List.maximum |> Maybe.withDefault 0) + pad
    , boxes = placed
    , routes = routes
    }


signOf : Float -> Float
signOf v =
    if v < 0 then
        -1

    else if v > 0 then
        1

    else
        0


stopover : Int -> Int -> String
stopover arrowNo step =
    "~" ++ String.fromInt arrowNo ++ "." ++ String.fromInt step


{-| The row of every box: one more than its last predecessor. A box nothing points to (a trigger) moves down next to its
first successor, so its arrow is short. An arrow that would close a loop is ignored (the server refuses loops). -}
rankAll : List String -> List Arrow -> Dict String Int
rankAll ids arrows =
    let
        parents id =
            arrows |> List.filter (\a -> a.to == id) |> List.map .from

        go path id memo =
            if Dict.member id memo then
                memo

            else
                let
                    ps =
                        parents id |> List.filter (\p -> not (List.member p path))

                    memo2 =
                        List.foldl (go (id :: path)) memo ps

                    r =
                        ps |> List.filterMap (\p -> Dict.get p memo2) |> List.maximum |> Maybe.map ((+) 1) |> Maybe.withDefault 0
                in
                Dict.insert id r memo2

        base =
            List.foldl (go []) Dict.empty ids

        sunk =
            ids
                |> List.foldl
                    (\id acc ->
                        if List.isEmpty (parents id) then
                            let
                                below =
                                    arrows |> List.filter (\a -> a.from == id) |> List.filterMap (\a -> Dict.get a.to base)
                            in
                            case List.minimum below of
                                Just r ->
                                    Dict.insert id (max 0 (r - 1)) acc

                                Nothing ->
                                    acc

                        else
                            acc
                    )
                    base
    in
    sunk


{-| Barycenter sweeps: every row is sorted by the average place of its neighbours in the row above, then in the row below. -}
orderRows : Dict String Int -> List ( String, String ) -> List (List Item) -> List (List Item)
orderRows arrowIndex links rows =
    let
        initial =
            -- the first row keeps the order of the text; later rows start in the order their arrows are written
            rows
                |> List.indexedMap
                    (\r row ->
                        if r == 0 then
                            row

                        else
                            List.sortBy (\i -> Dict.get i.key arrowIndex |> Maybe.withDefault 0) row
                    )

        parentsOf key =
            links |> List.filter (\( _, to ) -> to == key) |> List.map Tuple.first

        childrenOf key =
            links |> List.filter (\( from, _ ) -> from == key) |> List.map Tuple.second

        again rs =
            rs |> sweep parentsOf |> List.reverse |> sweep childrenOf |> List.reverse
    in
    List.foldl (\_ rs -> again rs) initial (List.range 1 4)


{-| Sorts each row after the first by the average place of its neighbours in the row before it (in the order given). -}
sweep : (String -> List String) -> List (List Item) -> List (List Item)
sweep neighbours rows =
    case rows of
        [] ->
            []

        first :: rest ->
            List.foldl
                (\row ( done, prev ) ->
                    let
                        pos =
                            prev |> List.indexedMap (\i it -> ( it.key, toFloat i )) |> Dict.fromList

                        keyed =
                            row
                                |> List.indexedMap
                                    (\i it ->
                                        let
                                            ps =
                                                neighbours it.key |> List.filterMap (\k -> Dict.get k pos)
                                        in
                                        ( if List.isEmpty ps then
                                            toFloat i

                                          else
                                            List.sum ps / toFloat (List.length ps)
                                        , i
                                        , it
                                        )
                                    )

                        sorted =
                            keyed |> List.sortBy (\( b, i, _ ) -> ( b, i )) |> List.map (\( _, _, it ) -> it)
                    in
                    ( done ++ [ sorted ], sorted )
                )
                ( [ first ], first )
                rest
                |> Tuple.first


{-| The centre of every item. The passes go down and up in turn: going down, an item moves under the average place of its
predecessors (so a plain chain stands in a straight line); going up, over the average place of its successors (so a
question sits between its answers). The last pass goes down. A row keeps its order and its minimum spacing (`squeeze`). -}
place : List ( String, String ) -> List (List Item) -> Dict String Float
place links rows =
    let
        spacing a b =
            (a.w + b.w) / 2 + gapX

        start =
            rows |> List.map (\row -> centred row) |> List.concat |> Dict.fromList

        parentsOf key =
            links |> List.filter (\( _, to ) -> to == key) |> List.map Tuple.first

        childrenOf key =
            links |> List.filter (\( from, _ ) -> from == key) |> List.map Tuple.second

        pass neighbours xs rowsInOrder =
            List.foldl
                (\row acc ->
                    let
                        wanted =
                            row
                                |> List.map
                                    (\it ->
                                        let
                                            near =
                                                neighbours it.key |> List.filterMap (\k -> Dict.get k acc)
                                        in
                                        if List.isEmpty near then
                                            Dict.get it.key acc |> Maybe.withDefault 0

                                        else
                                            List.sum near / toFloat (List.length near)
                                    )

                        offsets =
                            List.map2 spacing row (List.drop 1 row) |> List.foldl (\d ( o, last ) -> ( o ++ [ last + d ], last + d )) ( [ 0 ], 0 ) |> Tuple.first

                        solved =
                            squeeze (List.map2 (-) wanted offsets) |> List.map2 (+) offsets
                    in
                    List.map2 (\it x -> ( it.key, x )) row solved |> List.foldl (\( k, x ) d -> Dict.insert k x d) acc
                )
                xs
                rowsInOrder

        down xs =
            pass parentsOf xs rows

        up xs =
            pass childrenOf xs (List.reverse rows)
    in
    List.foldl (\_ xs -> xs |> down |> up) start (List.range 1 4) |> down


centred : List Item -> List ( String, Float )
centred row =
    let
        offsets =
            List.map2 (\a b -> (a.w + b.w) / 2 + gapX) row (List.drop 1 row)
                |> List.foldl (\d ( o, last ) -> ( o ++ [ last + d ], last + d )) ( [ 0 ], 0 )
                |> Tuple.first

        mid =
            (List.sum offsets / toFloat (max 1 (List.length offsets)))
    in
    List.map2 (\it o -> ( it.key, o - mid )) row offsets


{-| The non-decreasing list closest to the given one in the least-squares sense (pool adjacent violators): the best columns
for a row once the spacing is subtracted. -}
squeeze : List Float -> List Float
squeeze values =
    let
        -- a block is ( sum, count ); blocks are kept with the newest first
        push v blocks =
            merge ( v, 1 ) blocks

        merge ( s, n ) blocks =
            case blocks of
                ( s2, n2 ) :: rest ->
                    if s2 / toFloat n2 > s / toFloat n then
                        merge ( s + s2, n + n2 ) rest

                    else
                        ( s, n ) :: blocks

                [] ->
                    [ ( s, n ) ]
    in
    values
        |> List.foldl push []
        |> List.reverse
        |> List.concatMap (\( s, n ) -> List.repeat n (s / toFloat n))
