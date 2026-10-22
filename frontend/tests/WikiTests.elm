module WikiTests exposing (suite)

import Data exposing (EdgeType(..), Graph, Node)
import Dict
import Expect
import Filter
import Html.Attributes
import I18n exposing (Lang(..))
import MapView
import Search
import Set
import Svg
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Types exposing (Msg(..))
import WikiText


mkNode : String -> String -> String -> List String -> List String -> Node
mkNode id title project fedBy feeds =
    { id = id
    , kind = "program"
    , project = project
    , status = "active"
    , since = "2026-10-01"
    , until = Nothing
    , fedBy = fedBy
    , feeds = feeds
    , functions = []
    , process = False
    , text =
        Dict.fromList
            [ ( "en", { title = title, aliases = [ title ++ " alias" ], what = title ++ " is a thing.", does = "Does " ++ title ++ "." } )
            , ( "de", { title = title ++ " (de)", aliases = [], what = "Ist ein Ding.", does = "Tut etwas." } )
            ]
    }


graph : Graph
graph =
    { nodes =
        [ mkNode "mem" "mem" "workflow-memory" [ "giovanni" ] [ "events" ]
        , mkNode "events" "events/" "workflow-memory" [ "mem" ] []
        , mkNode "giovanni" "Giovanni" "none" [] [ "mem" ]
        , mkNode "memory-brief" "Session brief" "workflow-memory" [] []
        , mkNode "quizapp" "QuizApp" "quizapp" [] []
        , { id = "old", kind = "program", project = "quizapp", status = "retired", since = "2025-01-01", until = Just "2025-06-01", fedBy = [], feeds = [], functions = [], process = False, text = Dict.fromList [ ( "en", { title = "Old", aliases = [], what = "", does = "" } ) ] }
        ]
    , edges =
        [ { from = "giovanni", to = "mem", edgeType = Feeds }
        , { from = "mem", to = "events", edgeType = Feeds }
        , { from = "mem", to = "quizapp", edgeType = Mentions }
        ]
    , kinds = []
    }


ids : List Node -> List String
ids =
    List.map .id


suite : Test
suite =
    describe "wiki front end"
        -- REQ MP-1
        [ describe "search"
            [ test "best match first: exact, then prefix, then contains" <|
                \_ ->
                    Search.suggestions En 5 "mem" graph.nodes
                        |> ids
                        |> List.take 2
                        |> Expect.equal [ "mem", "memory-brief" ]
            , test "matches aliases and is accent and case insensitive" <|
                \_ ->
                    Search.suggestions En 5 "QUÍZAPP ALIAS" graph.nodes |> ids |> Expect.equal [ "quizapp" ]
            , test "letters in order still match, empty query gives nothing" <|
                \_ ->
                    Expect.all
                        [ \_ -> Search.suggestions En 5 "gvn" graph.nodes |> ids |> Expect.equal [ "giovanni" ]
                        , \_ -> Search.suggestions En 5 "  " graph.nodes |> Expect.equal []
                        , \_ -> Search.suggestions En 5 "zzzz" graph.nodes |> Expect.equal []
                        ]
                        ()
            , test "loose letter matches are dropped when a real match exists" <|
                \_ ->
                    Search.suggestions En 5 "mem" graph.nodes |> ids |> List.member "giovanni" |> Expect.equal False
            , test "finds the German title in German and the English one too" <|
                \_ ->
                    Expect.all
                        [ \_ -> Search.suggestions De 5 "events/ (de" graph.nodes |> ids |> Expect.equal [ "events" ]
                        , \_ -> Search.suggestions De 5 "events/" graph.nodes |> ids |> Expect.equal [ "events" ]
                        ]
                        ()
            ]

        -- REQ MP-2
        , describe "map interaction"
            [ test "hovering a node asks to preview it" <|
                \_ ->
                    MapView.node En graph ( 0, 0 ) False False True 12 (mkNode "mem" "mem" "p" [] [])
                        |> (\n -> Svg.svg [] [ n ])
                        |> Query.fromHtml
                        |> Query.find [ Selector.attribute (Html.Attributes.attribute "data-id" "mem") ]
                        |> Event.simulate Event.mouseOver
                        |> Event.expect (Hover "mem")
            , test "clicking a node opens its page" <|
                \_ ->
                    MapView.node En graph ( 0, 0 ) False False True 12 (mkNode "mem" "mem" "p" [] [])
                        |> (\n -> Svg.svg [] [ n ])
                        |> Query.fromHtml
                        |> Query.find [ Selector.attribute (Html.Attributes.attribute "data-id" "mem") ]
                        |> Event.simulate Event.click
                        |> Event.expect (OpenNode "mem")
            , test "the four boxes get what it is, what it does, fed by and who receives" <|
                \_ ->
                    case Data.nodeById graph "mem" of
                        Just n ->
                            MapView.info En graph n
                                |> Expect.equal
                                    { title = "mem", kind = "program", what = "mem is a thing.", does = "Does mem.", fedBy = [ "Giovanni" ], receives = [ "events/" ] }

                        Nothing ->
                            Expect.fail "no node"
            , test "boxes show page names instead of link syntax" <|
                \_ ->
                    WikiText.plain (\id -> "T-" ++ id) "Uses [[mem]], [[events|the log]] and `code`."
                        |> Expect.equal "Uses T-mem, the log and code."
            , test "boxes are filled in the chosen language" <|
                \_ ->
                    Data.nodeById graph "mem"
                        |> Maybe.map (MapView.info De graph >> .receives)
                        |> Expect.equal (Just [ "events/ (de)" ])
            ]

        -- REQ MP-3
        , describe "wiki links"
            [ test "[[id]] and [[id|label]] become links to /p/id" <|
                \_ ->
                    WikiText.rewriteLinks (\id -> "T-" ++ id) "See [[mem]] and [[events|the log]]."
                        |> Expect.equal "See [T-mem](/p/mem) and [the log](/p/events)."
            , test "links inside code quotes stay examples" <|
                \_ ->
                    WikiText.rewriteLinks identity "Write `[[id]]` to link [[mem]]."
                        |> Expect.equal "Write `[[id]]` to link [mem](/p/mem)."
            , test "link ids are collected for a step" <|
                \_ ->
                    WikiText.linkIds "Run [[mem]] then [[ events |x]]" |> Expect.equal [ "mem", "events" ]
            , test "steps are the numbered lines" <|
                \_ ->
                    WikiText.steps "Intro\n1. First [[mem]]\n2) Second\n- not a step" |> Expect.equal [ "First [[mem]]", "Second" ]
            ]

        -- REQ MP-4
        , describe "filters"
            [ test "a project shows its nodes and their direct neighbours" <|
                \_ ->
                    Filter.visible (Just "workflow-memory") Nothing graph
                        |> Set.toList
                        |> Expect.equal [ "events", "giovanni", "mem", "memory-brief", "quizapp" ]
            , test "the timeline hides what did not exist yet and what was retired" <|
                \_ ->
                    Expect.all
                        [ \_ -> Filter.visible Nothing (Just "2025-03-01") graph |> Set.toList |> Expect.equal [ "old" ]
                        , \_ -> Filter.visible Nothing (Just "2026-10-22") graph |> Set.member "old" |> Expect.equal False
                        , \_ -> Filter.days graph.nodes |> Expect.equal [ "2025-01-01", "2025-06-01", "2026-10-01" ]
                        ]
                        ()
            ]

        -- REQ LG-2
        , describe "languages"
            [ test "English is the default and codes round-trip" <|
                \_ ->
                    Expect.all
                        [ \_ -> I18n.fromCode "xx" |> Expect.equal En
                        , \_ -> List.map (I18n.code >> I18n.fromCode) I18n.all |> Expect.equal I18n.all
                        , \_ -> List.map I18n.code I18n.all |> Expect.equal [ "en", "de", "pt-BR" ]
                        ]
                        ()
            , test "interface text exists and differs in each language" <|
                \_ ->
                    List.map (\l -> (I18n.strings l).whatItDoes) I18n.all
                        |> Expect.equal [ "What it does", "Was es tut", "O que faz" ]
            , test "section headings are translated" <|
                \_ ->
                    List.map (\l -> I18n.sectionHeading l "receives") I18n.all
                        |> Expect.equal [ "Who receives its output", "Wer seine Ausgabe erhält", "Quem recebe o que produz" ]
            ]
        ]
