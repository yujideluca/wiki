module Flow exposing (Arrow, Box, Chart, Role(..), parse)

{-| The `## Flow` section of a page: a flowchart written as one line per box and one line per arrow (the same text
`Wiki.Content.Flow` checks on the server, requirement FL-1):

    trigger t: Giovanni asks | [[giovanni]]
    step s: Reads the brief | [[session-brief]]
    decide d: Did it change a system?
    product p: Page updated

    t -> s
    s -> d
    d -yes-> p

`parse` reads that text into boxes and arrows; `FlowLayout` puts them on the page and `FlowView` draws them.
-}

import Regex exposing (Regex)


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



