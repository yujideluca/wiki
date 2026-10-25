module WikiText exposing (linkIds, plain, rewriteLinks, steps, toHtml)

{-| Article text: Obsidian-style `[[id]]` / `[[id|label]]` links become ordinary Markdown links to `/p/<id>`,
then Markdown becomes HTML. -}

import Html exposing (Html)
import Html.Attributes as A
import Markdown.Parser
import Markdown.Renderer
import Regex exposing (Regex)


wikiLink : Regex
wikiLink =
    Regex.fromString "\\[\\[([^\\]|]+)(?:\\|([^\\]]*))?\\]\\]" |> Maybe.withDefault Regex.never


{-| `titleOf id` gives the page title to show when a link has no label. Text inside `code` quotes is left alone,
so an example such as `[[id]]` stays an example. -}
rewriteLinks : (String -> String) -> String -> String
rewriteLinks titleOf text =
    outsideCode (rewriteProse titleOf) text


{-| Preserve whole fenced sources before handling ordinary inline code. -}
outsideCode : (String -> String) -> String -> String
outsideCode f text =
    let
        appendBlock block ( offset, chunks ) =
            ( block.index + String.length block.match
            , chunks
                ++ [ outsideInlineCode f (String.slice offset block.index text), block.match ]
            )

        ( end, parts ) =
            Regex.find fencedCode text |> List.foldl appendBlock ( 0, [] )
    in
    String.concat (parts ++ [ outsideInlineCode f (String.dropLeft end text) ])


fencedCode : Regex
fencedCode =
    Regex.fromString "(^|\\n)(`{3,}|~{3,})[^\\n]*\\n[\\s\\S]*?\\n\\2[ \\t]*(?=\\n|$)"
        |> Maybe.withDefault Regex.never


outsideInlineCode : (String -> String) -> String -> String
outsideInlineCode f text =
    String.split "`" text
        |> List.indexedMap
            (\i part ->
                if modBy 2 i == 0 then
                    f part

                else
                    part
            )
        |> String.join "`"


rewriteProse : (String -> String) -> String -> String
rewriteProse titleOf text =
    Regex.replace wikiLink
        (\m ->
            case m.submatches of
                (Just id) :: rest ->
                    let
                        cleanId =
                            String.trim id

                        label =
                            case rest of
                                (Just l) :: _ ->
                                    l

                                _ ->
                                    titleOf cleanId
                    in
                    "[" ++ label ++ "](/p/" ++ cleanId ++ ")"

                _ ->
                    m.match
        )
        text


{-| Text for places that show no Markdown (the map's boxes): links become their label or page title,
code quotes are dropped. -}
plain : (String -> String) -> String -> String
plain titleOf text =
    Regex.replace wikiLink
        (\m ->
            case m.submatches of
                (Just id) :: (Just l) :: _ ->
                    l

                (Just id) :: _ ->
                    titleOf (String.trim id)

                _ ->
                    m.match
        )
        text
        |> String.replace "`" ""
        |> String.replace "**" ""


linkIds : String -> List String
linkIds text =
    String.split "`" text
        |> List.indexedMap Tuple.pair
        |> List.filter (\( i, _ ) -> modBy 2 i == 0)
        |> List.map Tuple.second
        |> String.join " "
        |> Regex.find wikiLink
        |> List.filterMap (\m -> List.head m.submatches |> Maybe.andThen identity |> Maybe.map String.trim)


toHtml : (String -> String) -> String -> List (Html msg)
toHtml titleOf markdown =
    case
        rewriteLinks titleOf markdown
            |> Markdown.Parser.parse
            |> Result.mapError (always "parse")
            |> Result.andThen (Markdown.Renderer.render renderer)
    of
        Ok html ->
            html

        Err _ ->
            [ Html.pre [ A.class "raw" ] [ Html.text markdown ] ]


{-| The default renderer, except that a link to another site opens in a new tab, so reading a definition never
loses the page being read. -}
renderer : Markdown.Renderer.Renderer (Html msg)
renderer =
    let
        base =
            Markdown.Renderer.defaultHtmlRenderer
    in
    { base
        | link =
            \link content ->
                let
                    external =
                        if String.startsWith "http://" link.destination || String.startsWith "https://" link.destination then
                            [ A.target "_blank", A.rel "noopener noreferrer" ]

                        else
                            []

                    title =
                        case link.title of
                            Just t ->
                                [ A.title t ]

                            Nothing ->
                                []
                in
                Html.a (A.href link.destination :: title ++ external) content
    }


{-| A process page's `Steps` section: one numbered line per step. -}
steps : String -> List String
steps markdown =
    markdown
        |> String.lines
        |> List.map String.trim
        |> List.filterMap
            (\line ->
                case Regex.find numbered line |> List.head of
                    Just m ->
                        Just (String.dropLeft (String.length m.match) line |> String.trim)

                    Nothing ->
                        Nothing
            )


numbered : Regex
numbered =
    Regex.fromString "^\\d+[.)]\\s+" |> Maybe.withDefault Regex.never
