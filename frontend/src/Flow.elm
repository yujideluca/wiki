module Flow exposing (Arrow, Box, Chart, Role(..), isC4, parse, parseLevels)

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

The `## Architecture` section of a project page uses the same lines with the box words `person`, `system`, `container`,
`store` and `external` (the C4 model), in two parts under `### ` headings; `parseLevels` reads those
(`Wiki.Content.Architecture` checks them on the server, requirement PJ-1).
-}

import Regex exposing (Regex)


type Role
    = Trigger
    | Step
    | Decide
    | Product
    | Person
    | System
    | Container
    | Store
    | External


{-| The box words of the architecture diagrams. -}
isC4 : Role -> Bool
isC4 role =
    List.member role [ Person, System, Container, Store, External ]


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
    Regex.fromString "^(trigger|step|decide|product|person|system|container|store|external)\\s+([a-z][a-z0-9_]*)\\s*:\\s*(.+)$" |> Maybe.withDefault Regex.never


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


{-| The `### ` parts of an architecture section, each with its heading, in file order. -}
parseLevels : String -> List ( String, Chart )
parseLevels text =
    let
        add line ( done, current ) =
            if String.startsWith "### " line then
                ( done ++ currentPart current, Just ( String.dropLeft 4 line |> String.trim, [] ) )

            else
                case current of
                    Just ( heading, body ) ->
                        ( done, Just ( heading, body ++ [ line ] ) )

                    Nothing ->
                        ( done, Nothing )

        currentPart current =
            case current of
                Just ( heading, body ) ->
                    [ ( heading, parse (String.join "\n" body) ) ]

                Nothing ->
                    []

        ( finished, last ) =
            String.lines text |> List.foldl add ( [], Nothing )
    in
    finished ++ currentPart last


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

        "person" ->
            Person

        "system" ->
            System

        "container" ->
            Container

        "store" ->
            Store

        "external" ->
            External

        _ ->
            Step



