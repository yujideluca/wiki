module WikiTests exposing (suite)

import Data exposing (EdgeType(..), Graph, Node)
import Dict
import Expect
import Filter
import Html
import Html.Attributes
import I18n exposing (Lang(..))
import Layout
import MapSize
import MapView
import Search
import Set
import Svg
import Svg.Attributes
import Zoom
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
            , test "the map declares a viewBox matching its size, so zoom and drag use real pointer positions" <|
                \_ ->
                    MapView.map En graph Dict.empty (Zoom.init { width = 800, height = 500 }) 800 500 Set.empty Nothing
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Svg.Attributes.viewBox "0 0 800 500") ]
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

        -- REQ MP-5
        , describe "map size"
            [ test "on a wide, tall enough window the map, the line under it and the boxes fill the window exactly" <|
                \_ ->
                    [ ( 1500, 900 ), ( 1600, 1000 ), ( 1920, 943 ), ( 1920, 1200 ), ( 2560, 1300 ) ]
                        |> List.map
                            (\( w, h ) ->
                                let
                                    sz =
                                        MapSize.sizes w h
                                in
                                ( sz.box /= Nothing, sz.map + MapSize.boxesAbove + Maybe.withDefault 0 sz.box - h )
                            )
                        |> Expect.equal (List.repeat 5 ( True, 0 ))
            , test "the map is taller than the old 58 % share on a big window, and grows with the window" <|
                \_ ->
                    Expect.all
                        [ \_ -> (MapSize.sizes 1920 943).map |> Expect.greaterThan (0.58 * 943 + 50)
                        , \_ -> (MapSize.sizes 1920 1200).map |> Expect.greaterThan (MapSize.sizes 1920 900).map
                        ]
                        ()
            , test "the map is never smaller than before (58 % of the height, at least 320 px), on any window" <|
                \_ ->
                    [ 390, 900, 1101, 1280, 1366, 1920, 2560 ]
                        |> List.concatMap (\w -> List.map (\h -> ( w, h )) [ 500, 720, 800, 943, 1300 ])
                        |> List.all (\( w, h ) -> (MapSize.sizes w h).map >= max 320 (0.58 * h) - 0.001)
                        |> Expect.equal True
            , test "a window too short for the wanted boxes, or narrow, keeps the old layout: the share, and boxes that size themselves" <|
                \_ ->
                    Expect.all
                        [ \_ -> (MapSize.sizes 1101 800).map |> Expect.within (Expect.Absolute 0.001) 464
                        , \_ -> (MapSize.sizes 1101 800).box |> Expect.equal Nothing
                        , \_ -> (MapSize.sizes 1366 768).box |> Expect.equal Nothing
                        , \_ -> (MapSize.sizes 1000 1000).map |> Expect.within (Expect.Absolute 0.001) 580
                        , \_ -> (MapSize.sizes 1000 1000).box |> Expect.equal Nothing
                        , \_ -> (MapSize.sizes 400 500).map |> Expect.equal 320
                        , \_ -> (MapSize.sizes 1920 500).map |> Expect.equal 320
                        ]
                        ()
            , test "wide windows give every info box a fixed height that scrolls inside" <|
                \_ ->
                    MapView.infoBoxes En (Just 200) (Just { title = "t", kind = "k", what = "w", does = "d", fedBy = [], receives = [] })
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.class "box" ]
                        |> Query.each
                            (Query.has [ Selector.style "height" "200px", Selector.style "overflow-y" "auto" ])
            , test "without a height (narrow windows) the boxes size themselves" <|
                \_ ->
                    MapView.infoBoxes En Nothing (Just { title = "t", kind = "k", what = "w", does = "d", fedBy = [], receives = [] })
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.class "box" ]
                        |> Query.each (Query.hasNot [ Selector.style "height" "200px" ])
            ]

        -- REQ MP-6
        , describe "layout shape"
            [ test "a wide area stretches the layout sideways to its shape, a tall one stretches it upwards" <|
                \_ ->
                    Expect.all
                        [ \_ -> aspectOf (Layout.matchAspect 2.5 square) |> Expect.within (Expect.Absolute 0.001) 2.5
                        , \_ -> aspectOf (Layout.matchAspect 0.5 square) |> Expect.within (Expect.Absolute 0.001) 0.5
                        , \_ -> Layout.matchAspect 1 square |> Expect.equal square
                        ]
                        ()
            , test "distances only grow: no pair of nodes gets closer in either direction" <|
                \_ ->
                    let
                        pairs d =
                            [ ( "a", "b" ), ( "a", "c" ), ( "b", "d" ), ( "c", "d" ), ( "a", "e" ), ( "e", "d" ) ]
                                |> List.filterMap
                                    (\( p, q ) ->
                                        Maybe.map2 (\( x1, y1 ) ( x2, y2 ) -> ( abs (x1 - x2), abs (y1 - y2) )) (Dict.get p d) (Dict.get q d)
                                    )

                        grown wide =
                            List.map2 (\( dx0, dy0 ) ( dx1, dy1 ) -> dx1 >= dx0 - 0.0001 && dy1 >= dy0 - 0.0001) (pairs square) (pairs wide)
                    in
                    Expect.all
                        [ \_ -> grown (Layout.matchAspect 2.5 square) |> List.all identity |> Expect.equal True
                        , \_ -> grown (Layout.matchAspect 0.4 square) |> List.all identity |> Expect.equal True
                        ]
                        ()
            , test "the stretch is capped at 3 and a flat or single layout never produces NaN or infinity" <|
                \_ ->
                    let
                        sane d =
                            Dict.values d |> List.all (\( x, y ) -> not (isNaN x || isInfinite x || isNaN y || isInfinite y))

                        flat =
                            Dict.fromList [ ( "a", ( 0, 0 ) ), ( "b", ( 100, 0 ) ) ]
                    in
                    Expect.all
                        [ \_ -> aspectOf (Layout.matchAspect 100 square) |> Expect.within (Expect.Absolute 0.001) 3
                        , \_ -> sane (Layout.matchAspect 3 flat) |> Expect.equal True
                        , \_ -> sane (Layout.matchAspect 3 (Dict.fromList [ ( "a", ( 5, 5 ) ) ])) |> Expect.equal True
                        , \_ -> Layout.matchAspect 3 Dict.empty |> Expect.equal Dict.empty
                        ]
                        ()
            , test "the force layout keeps every page and keeps pages apart" <|
                \_ ->
                    let
                        placed =
                            Layout.compute graph |> Dict.toList

                        gaps =
                            placed
                                |> List.concatMap
                                    (\( i, ( x1, y1 ) ) ->
                                        List.filterMap
                                            (\( j, ( x2, y2 ) ) ->
                                                if i < j then
                                                    Just (sqrt ((x1 - x2) ^ 2 + (y1 - y2) ^ 2))

                                                else
                                                    Nothing
                                            )
                                            placed
                                    )
                    in
                    Expect.all
                        [ \_ -> List.length placed |> Expect.equal (List.length graph.nodes)
                        , \_ -> List.minimum gaps |> Maybe.withDefault 0 |> Expect.greaterThan 40
                        ]
                        ()
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
            -- REQ MP-8
            , test "external links open in a new tab, wiki links stay in the tab" <|
                \_ ->
                    let
                        html =
                            WikiText.toHtml identity "[Wikipedia](https://en.wikipedia.org/wiki/Hook) and [[mem]]"
                                |> Html.div []
                                |> Query.fromHtml
                    in
                    Expect.all
                        [ \_ -> html |> Query.find [ Selector.attribute (Html.Attributes.href "https://en.wikipedia.org/wiki/Hook") ] |> Query.has [ Selector.attribute (Html.Attributes.target "_blank"), Selector.attribute (Html.Attributes.rel "noopener noreferrer") ]
                        , \_ -> html |> Query.find [ Selector.attribute (Html.Attributes.href "/p/mem") ] |> Query.hasNot [ Selector.attribute (Html.Attributes.target "_blank") ]
                        ]
                        ()
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
            -- REQ MP-9
            , test "the glossary link is named in each language" <|
                \_ ->
                    List.map (\l -> (I18n.strings l).glossary) I18n.all
                        |> Expect.equal [ "Glossary", "Glossar", "Glossário" ]
            , test "section headings are translated" <|
                \_ ->
                    List.map (\l -> I18n.sectionHeading l "receives") I18n.all
                        |> Expect.equal [ "Who receives its output", "Wer seine Ausgabe erhält", "Quem recebe o que produz" ]
            ]
        ]


{-| Five pages in a square, 100 apart (corners and centre). -}
square : Layout.Positions
square =
    Dict.fromList [ ( "a", ( 0, 0 ) ), ( "b", ( 100, 0 ) ), ( "c", ( 0, 100 ) ), ( "d", ( 100, 100 ) ), ( "e", ( 50, 50 ) ) ]


aspectOf : Layout.Positions -> Float
aspectOf d =
    let
        xs =
            Dict.values d |> List.map Tuple.first

        ys =
            Dict.values d |> List.map Tuple.second

        extent vs =
            Maybe.map2 (-) (List.maximum vs) (List.minimum vs) |> Maybe.withDefault 1
    in
    extent xs / extent ys
