module Search exposing (score, suggestions)

{-| Autocomplete: ranks pages by how well their title or aliases (in the chosen language and in English)
match what was typed. Exact > prefix > word prefix > contains > letters in order. -}

import Data exposing (Node)
import Dict
import I18n exposing (Lang)


suggestions : Lang -> Int -> String -> List Node -> List Node
suggestions lang limit query nodes =
    let
        q =
            normalize query
    in
    if String.isEmpty q then
        []

    else
        nodes
            |> List.filterMap
                (\n ->
                    let
                        s =
                            score q (names lang n)
                    in
                    if s > 0 then
                        Just ( s, Data.title lang n, n )

                    else
                        Nothing
                )
            |> dropLooseIfBetter
            |> List.sortWith
                (\( s1, t1, _ ) ( s2, t2, _ ) ->
                    case compare s2 s1 of
                        EQ ->
                            compare (String.length t1) (String.length t2)

                        other ->
                            other
                )
            |> List.take limit
            |> List.map (\( _, _, n ) -> n)


{-| Letters-in-order matches are only a fallback: when anything matches properly, they are noise. -}
dropLooseIfBetter : List ( Int, String, Node ) -> List ( Int, String, Node )
dropLooseIfBetter scored =
    if List.any (\( sc, _, _ ) -> sc >= 40) scored then
        List.filter (\( sc, _, _ ) -> sc >= 40) scored

    else
        scored


names : Lang -> Node -> List String
names lang node =
    let
        local =
            Data.nodeText lang node

        english =
            Dict.get "en" node.text |> Maybe.map (\t -> t.title :: t.aliases) |> Maybe.withDefault []
    in
    node.id :: local.title :: local.aliases ++ english


{-| Best score of the (already normalized) query against any name; 0 means no match. -}
score : String -> List String -> Int
score q candidates =
    candidates
        |> List.map (normalize >> scoreOne q)
        |> List.maximum
        |> Maybe.withDefault 0


scoreOne : String -> String -> Int
scoreOne q name =
    if name == q then
        100

    else if String.startsWith q name then
        80

    else if List.any (String.startsWith q) (String.words (String.map wordBreak name)) then
        60

    else if String.contains q name then
        40

    else if subsequence (String.toList q) (String.toList name) then
        10

    else
        0


wordBreak : Char -> Char
wordBreak c =
    if c == '-' || c == '_' || c == '/' || c == '.' || c == '(' || c == ')' then
        ' '

    else
        c


subsequence : List Char -> List Char -> Bool
subsequence q name =
    case ( q, name ) of
        ( [], _ ) ->
            True

        ( _, [] ) ->
            False

        ( a :: qs, b :: ns ) ->
            if a == b then
                subsequence qs ns

            else
                subsequence q ns


normalize : String -> String
normalize =
    String.toLower >> String.trim >> String.map stripAccent


stripAccent : Char -> Char
stripAccent c =
    case c of
        'á' ->
            'a'

        'à' ->
            'a'

        'â' ->
            'a'

        'ã' ->
            'a'

        'ä' ->
            'a'

        'é' ->
            'e'

        'ê' ->
            'e'

        'í' ->
            'i'

        'ó' ->
            'o'

        'ô' ->
            'o'

        'õ' ->
            'o'

        'ö' ->
            'o'

        'ú' ->
            'u'

        'ü' ->
            'u'

        'ç' ->
            'c'

        'ß' ->
            's'

        _ ->
            c
