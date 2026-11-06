module WikiTests exposing (suite)

import ArticleView
import Data exposing (EdgeType(..), Graph, Node)
import Array
import Dict
import Globe
import GlobeGrab
import Json.Encode as E
import Expect
import Filter
import Html
import Html.Attributes
import I18n exposing (Lang(..))
import Layout
import Motion
import MapCamera
import MapSize
import MapGeometry
import MapView
import Search
import Set
import Svg
import Svg.Attributes
import Touch
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
    Data.indexed
        [ mkNode "mem" "mem" "workflow-memory" [ "giovanni" ] [ "events" ]
        , mkNode "events" "events/" "workflow-memory" [ "mem" ] []
        , mkNode "giovanni" "Giovanni" "none" [] [ "mem" ]
        , mkNode "memory-brief" "Session brief" "workflow-memory" [] []
        , mkNode "quizapp" "QuizApp" "quizapp" [] []
        , { id = "old", kind = "program", project = "quizapp", status = "retired", since = "2025-01-01", until = Just "2025-06-01", fedBy = [], feeds = [], functions = [], process = False, text = Dict.fromList [ ( "en", { title = "Old", aliases = [], what = "", does = "" } ) ] }
        ]
        [ { from = "giovanni", to = "mem", edgeType = Feeds }
        , { from = "mem", to = "events", edgeType = Feeds }
        , { from = "mem", to = "quizapp", edgeType = Mentions }
        ]
        []


phoneArticle : Data.Article
phoneArticle =
    { id = "mem"
    , lang = "en"
    , title = "mem"
    , kind = "program"
    , project = "none"
    , status = "active"
    , location = Nothing
    , since = "2026-10-01"
    , until = Nothing
    , reviewed = Nothing
    , mayBeStale = False
    , fedBy = []
    , feeds = []
    , memory = []
    , sources = []
    , sections = [ { key = "what", markdown = "Lead text." }, { key = "does", markdown = "Body text." } ]
    , history = []
    }


{-| The ball of the map: 800 by 500 window, centred, as `MapCamera.screenOf` makes it on a wide window without floating controls. -}
screen : Globe.Screen
screen =
    { cx = 400, cy = 250, rho = 250 }


home : Globe.View
home =
    { lam = 0, beta = 0, z = 1 }


{-| Where the six pages sit on the sphere (longitude, latitude in radians): `mem` in the middle of the view, its neighbours
around it, and two pages near the rim. -}
sphere : Dict.Dict String Globe.Node
sphere =
    Dict.fromList
        [ ( "mem", Globe.nodeOf 0 0 )
        , ( "events", Globe.nodeOf 0.35 0.1 )
        , ( "giovanni", Globe.nodeOf -0.35 0.1 )
        , ( "memory-brief", Globe.nodeOf 0.1 -0.4 )
        , ( "quizapp", Globe.nodeOf 1.3 0 )
        , ( "old", Globe.nodeOf -1.3 0 )
        ]


adj : Motion.Adjacency
adj =
    Motion.adjacency (List.map .id graph.nodes) graph.edges


statics : MapGeometry.Statics
statics =
    MapGeometry.buildStatics { lang = En, graph = graph, sphere = sphere, project = Nothing, month = Nothing }


geometryAt : Globe.View -> MapGeometry.Geometry
geometryAt view =
    MapGeometry.build { lam = view.lam, beta = view.beta, z = view.z, cx = screen.cx, cy = screen.cy, rho = screen.rho } (Globe.camera screen view) statics


{-| The map drawn with the dots displaced as given, one dot lit (or none). -}
drawn : Motion.State -> Maybe String -> Html.Html Msg
drawn motion lit =
    MapView.map (geometryAt home) statics motion adj 800 500 lit


missing : MapGeometry.Dot
missing =
    { node = mkNode "missing" "missing" "p" [] [], title = "", colour = "", spot = Globe.hiddenSpot, radiusScale = 1, labelSize = 12, labelled = False }


dotOf : String -> MapGeometry.Dot
dotOf id =
    (geometryAt home).visible
        |> List.filter (\d -> d.node.id == id)
        |> List.head
        |> Maybe.withDefault (Dict.get id statics.byId |> Maybe.andThen (\i -> Array.get i statics.items) |> Maybe.map .hidden |> Maybe.withDefault missing)


look : MapView.Look
look =
    { active = False, offset = ( 0, 0 ), near = False, label = True }


pointer : Float -> Float -> E.Value
pointer x y =
    E.object [ ( "clientX", E.float x ), ( "clientY", E.float y ) ]


{-| The finger-held point: where the point of the globe that is under [under] on the screen with the camera [before] is drawn
with the camera [after]. -}
drawnAt : ( Float, Float ) -> Globe.View -> Globe.View -> Maybe ( Float, Float )
drawnAt under before after =
    Globe.hitRay (Globe.camera screen before) under
        |> Maybe.map (\p -> Globe.project (Globe.camera screen after) p |> (\s -> ( s.x, s.y )))


near : ( Float, Float ) -> Maybe ( Float, Float ) -> Bool
near ( x, y ) found =
    case found of
        Just ( fx, fy ) ->
            abs (fx - x) < 0.5 && abs (fy - y) < 0.5

        Nothing ->
            False


{-| Every dot's displacement east of it, after the springs have run [n] steps with the given forces. -}
run : Motion.Feel -> Int -> Motion.Forces -> Motion.State -> Motion.State
run feel n forces st =
    List.foldl (\_ s -> Motion.step 0.016 feel adj forces s |> Tuple.first) st (List.range 1 n)


eastOf : String -> Motion.State -> Float
eastOf id st =
    Motion.displaced adj st
        |> List.filter (\( i, _, _ ) -> i == id)
        |> List.head
        |> Maybe.map (\( _, dx, _ ) -> dx)
        |> Maybe.withDefault 0


{-| How round a dot is drawn: the short axis of its ellipse over the long one (1 for a dot that faces us). -}
roundness : MapGeometry.Dot -> Float
roundness d =
    let
        mean =
            (d.spot.la + d.spot.ld) / 2

        spread =
            sqrt (((d.spot.la - d.spot.ld) / 2) ^ 2 + d.spot.lb ^ 2)
    in
    (mean - spread) / (mean + spread)


tenthOf : Float -> String
tenthOf n =
    String.fromFloat (toFloat (round (n * 10)) / 10)


{-| The text of a dot's ellipse matrix, as `MapView` writes it (to a thousandth). -}
flattenOf : MapGeometry.Dot -> String
flattenOf d =
    let
        thou v =
            String.fromFloat (toFloat (round (v * 1000)) / 1000)
    in
    "matrix(" ++ thou d.spot.la ++ " " ++ thou d.spot.lb ++ " " ++ thou d.spot.lb ++ " " ++ thou d.spot.ld ++ " 0 0)"


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
            [ test "moving the pointer over the map asks which dot is under it" <|
                \_ ->
                    drawn Motion.rest Nothing
                        |> Query.fromHtml
                        |> Event.simulate (Event.custom "mousemove" (pointer 123 45))
                        |> Event.expect (PointerAt 123 45)
            , test "the dot under the pointer is found by the camera maths: the nearest within its reach, none away from every dot" <|
                \_ ->
                    let
                        geometry =
                            geometryAt home

                        mem =
                            dotOf "mem"
                    in
                    Expect.all
                        [ \_ -> MapGeometry.hitAt geometry mem.spot.x mem.spot.y |> Expect.equal (Just "mem")
                        , \_ -> MapGeometry.hitAt geometry (mem.spot.x + 4) mem.spot.y |> Expect.equal (Just "mem")
                        , \_ -> MapGeometry.hitAt geometry 5 5 |> Expect.equal Nothing
                        ]
                        ()
            , test "a dot on the far side of the globe is not found" <|
                \_ ->
                    let
                        behind =
                            geometryAt { lam = pi, beta = 0, z = 1 }

                        mem =
                            dotOf "mem"
                    in
                    MapGeometry.hitAt behind mem.spot.x mem.spot.y |> Expect.notEqual (Just "mem")
            , test "the map declares a viewBox matching its size, so zoom and drag use real pointer positions" <|
                \_ ->
                    drawn Motion.rest Nothing
                        |> Query.fromHtml
                        |> Query.has [ Selector.attribute (Svg.Attributes.viewBox "0 0 800 500") ]
            , test "a click on the map says where, so the page can open the dot that was pressed and released on (the page is opened by Main)" <|
                \_ ->
                    drawn Motion.rest Nothing
                        |> Query.fromHtml
                        |> Event.simulate (Event.custom "click" (pointer 200 100))
                        |> Event.expect (ClickAt 200 100)
            , test "there are no invisible hit discs in the page: the dots are found by the maths" <|
                \_ ->
                    drawn Motion.rest Nothing
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.class "node-hit" ]
                        |> Query.count (Expect.equal 0)
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


        -- REQ LY-1
        , describe "layout in slices"
            [ test "running the simulation a few steps at a time gives the layout of a single run" <|
                \_ ->
                    let
                        finish sim =
                            if Layout.isDone sim then
                                sim

                            else
                                finish (Layout.advance 7 sim)
                    in
                    Layout.start graph |> finish |> Layout.positionsOf |> Expect.equal (Layout.compute graph)
            , test "one slice does not finish the run" <|
                \_ ->
                    Layout.start graph |> Layout.advance 7 |> Layout.isDone |> Expect.equal False
            ]


        -- REQ TC-1
        -- REQ TC-2
        -- REQ TC-3
        , describe "touch"
            [ test "one finger pans: the point of the globe under it stays under it" <|
                \_ ->
                    let
                        ( g1, v1 ) =
                            Touch.step screen Touch.Start [ ( 420, 240 ) ] Touch.Idle home

                        ( _, v2 ) =
                            Touch.step screen Touch.Move [ ( 450, 230 ) ] g1 v1
                    in
                    ( v2 /= home, near ( 450, 230 ) (drawnAt ( 420, 240 ) home v2) ) |> Expect.equal ( True, True )
            , test "two fingers pinch around their midpoint" <|
                \_ ->
                    let
                        ( g1, v1 ) =
                            Touch.step screen Touch.Start [ ( 350, 250 ), ( 450, 250 ) ] Touch.Idle home

                        ( _, v2 ) =
                            Touch.step screen Touch.Move [ ( 300, 250 ), ( 500, 250 ) ] g1 v1
                    in
                    -- twice as far apart: zoomed in, and the point of the globe at the midpoint (400, 250) is still there
                    ( v2.z > home.z, near ( 400, 250 ) (drawnAt ( 400, 250 ) home v2) ) |> Expect.equal ( True, True )
            , test "a double tap, quick taps and circles of one finger do not change the zoom" <|
                \_ ->
                    let
                        tap ( g, v ) =
                            Touch.step screen Touch.Start [ ( 50, 50 ) ] g v |> (\( g2, v2 ) -> Touch.step screen Touch.End [] g2 v2)

                        circleStep a ( g, v ) =
                            Touch.step screen Touch.Move [ ( 400 + 60 * cos a, 250 + 60 * sin a ) ] g v

                        taps =
                            List.foldl (\_ s -> tap s) ( Touch.Idle, home ) (List.range 1 6)

                        circled =
                            Touch.step screen Touch.Start [ ( 460, 250 ) ] Touch.Idle (Tuple.second taps)
                                |> (\s -> List.foldl circleStep s (List.map (\i -> toFloat i * 0.3) (List.range 1 60)))
                    in
                    ( (Tuple.second taps).z, (Tuple.second circled).z ) |> Expect.equal ( 1, 1 )
            , test "a lift that was never reported does not turn the next touch into a pinch" <|
                \_ ->
                    let
                        -- a finger goes down, its lift is missed; the next touch arrives alone with the event restating one finger
                        ( g1, v1 ) =
                            Touch.step screen Touch.Start [ ( 300, 200 ) ] Touch.Idle home

                        ( g2, v2 ) =
                            Touch.step screen Touch.Start [ ( 400, 250 ) ] g1 v1

                        ( _, v3 ) =
                            Touch.step screen Touch.Move [ ( 430, 250 ) ] g2 v2
                    in
                    ( v3.z, near ( 430, 250 ) (drawnAt ( 400, 250 ) home v3) ) |> Expect.equal ( 1, True )
            , test "a finger count that changes between events moves nothing" <|
                \_ ->
                    let
                        ( g1, v1 ) =
                            Touch.step screen Touch.Start [ ( 300, 200 ) ] Touch.Idle home

                        ( _, v2 ) =
                            Touch.step screen Touch.Move [ ( 300, 200 ), ( 500, 300 ) ] g1 v1
                    in
                    v2 |> Expect.equal home
            ]

        -- REQ LN-1
        -- REQ LN-2
        -- REQ LN-3
        , describe "globe"
            [ test "the dots these tests look at are really in view (so none of them is the stand-in for a missing dot)" <|
                \_ ->
                    let
                        seen =
                            List.map (.node >> .id) (geometryAt home).visible
                    in
                    List.map (\id -> List.member id seen) [ "mem", "events", "giovanni", "memory-brief", "quizapp" ] |> Expect.equal [ True, True, True, True, True ]
            , test "the middle is magnified and the border is squeezed: a dot near the rim is smaller and flattened" <|
                \_ ->
                    let
                        mid =
                            dotOf "mem"

                        rim =
                            dotOf "quizapp"
                    in
                    ( mid.spot.scale > rim.spot.scale * 1.15, mid.radiusScale > rim.radiusScale, roundness mid > roundness rim )
                        |> Expect.equal ( True, True, True )
            -- REQ DY-11
            , test "zooming in grows a dot at most 3.6 times (the old lens cap of 1.6 x 2.2) however far you zoom, so the dots stay small against the distances between them (DY-11)" <|
                \_ ->
                    let
                        radiusAt z =
                            (geometryAt { home | z = z }).visible
                                |> List.filter (\d -> d.node.id == "mem")
                                |> List.head
                                |> Maybe.map (\d -> 6 * d.radiusScale * max d.spot.la d.spot.ld)
                                |> Maybe.withDefault 0

                        grown =
                            List.map (\z -> radiusAt z / radiusAt 1) [ 1, 2, 4, 8, 12 ]
                    in
                    ( List.all (\g -> g <= 3.6) grown, List.all (\g -> g >= 0.99) grown )
                        |> Expect.equal ( True, True )
            -- REQ DY-11
            , test "at every zoom a dot is smaller than a quarter of the distance to its neighbour on the screen (DY-11)" <|
                \_ ->
                    let
                        ratioAt z =
                            let
                                seen =
                                    (geometryAt { home | z = z }).visible

                                find id =
                                    List.filter (\d -> d.node.id == id) seen |> List.head
                            in
                            Maybe.map2
                                (\a b -> 6 * a.radiusScale * max a.spot.la a.spot.ld / sqrt ((a.spot.x - b.spot.x) ^ 2 + (a.spot.y - b.spot.y) ^ 2))
                                (find "mem")
                                (find "events")
                    in
                    List.map ratioAt [ 1, 1.5, 2, 3 ]
                        |> List.all (\r -> Maybe.withDefault 0 r < 0.25)
                        |> Expect.equal True
            -- REQ DY-11
            , test "a dot answers where it is drawn: at the zoom its edge is inside its hit area (DY-11)" <|
                \_ ->
                    let
                        geo =
                            geometryAt { home | z = 4 }

                        mem =
                            (geo.visible |> List.filter (\d -> d.node.id == "mem") |> List.head |> Maybe.withDefault missing)

                        edge =
                            6 * mem.radiusScale * max mem.spot.la mem.spot.ld * 0.95
                    in
                    MapGeometry.hitAt geo (mem.spot.x + edge) mem.spot.y |> Expect.equal (Just "mem")
            , test "no dot is drawn outside the ball" <|
                \_ ->
                    (geometryAt home).visible
                        |> List.all (\d -> sqrt ((d.spot.x - screen.cx) ^ 2 + (d.spot.y - screen.cy) ^ 2) <= screen.rho + 0.001)
                        |> Expect.equal True
            , test "at the first view only the projects have a label; zoomed in, the dots near the middle get theirs and the dots near the border have none" <|
                \_ ->
                    let
                        zoomed =
                            (geometryAt { lam = 0, beta = 0, z = 2 }).visible

                        labelOf id dots =
                            dots |> List.filter (\d -> d.node.id == id) |> List.head |> Maybe.map .labelled
                    in
                    ( List.any .labelled (geometryAt home).visible
                    , labelOf "mem" zoomed
                    , labelOf "quizapp" zoomed
                    )
                        |> Expect.equal ( False, Just True, Just False )
            , test "the dashed mentions line to a dot near the border is left out unless lit" <|
                \_ ->
                    let
                        mentionLines lit =
                            drawn Motion.rest lit |> Query.fromHtml |> Query.findAll [ Selector.class "mentions" ]
                    in
                    Expect.all
                        [ \_ -> mentionLines Nothing |> Query.count (Expect.equal 0)
                        , \_ -> mentionLines (Just "quizapp") |> Query.count (Expect.equal 1)
                        ]
                        ()
            , test "the pointer finds each dot where it is drawn" <|
                \_ ->
                    let
                        geometry =
                            geometryAt { lam = 0.2, beta = 0.1, z = 1.4 }
                    in
                    geometry.visible
                        |> List.all (\d -> MapGeometry.hitAt geometry d.spot.x d.spot.y == Just d.node.id)
                        |> Expect.equal True
            ]

        -- REQ LN-5
        , describe "round globe"
            [ test "a dot beyond the rim is on the far side and is not drawn, and zooming in leaves fewer dots in view" <|
                \_ ->
                    let
                        count z =
                            List.length (geometryAt { lam = 0, beta = 0, z = z }).visible
                    in
                    Expect.all
                        [ \_ -> Expect.equal True (List.member "mem" (List.map (.node >> .id) (geometryAt home).visible))
                        , \_ -> Expect.equal False (List.member "mem" (List.map (.node >> .id) (geometryAt { lam = pi, beta = 0, z = 1 }).visible))
                        , \_ -> Expect.atMost (count 1) (count 4)
                        ]
                        ()
            ]

        -- REQ DY-9
        , describe "pointer and click rules"
            [ test "a free pointer lights the dot under it and puts the light out when it leaves; staying on the same dot changes nothing" <|
                \_ ->
                    [ MapCamera.pointerMoved False (\_ -> Just "a") Nothing
                    , MapCamera.pointerMoved False (\_ -> Just "b") (Just "a")
                    , MapCamera.pointerMoved False (\_ -> Just "a") (Just "a")
                    , MapCamera.pointerMoved False (\_ -> Nothing) (Just "a")
                    , MapCamera.pointerMoved False (\_ -> Nothing) Nothing
                    ]
                        |> Expect.equal [ MapCamera.Light "a", MapCamera.Light "b", MapCamera.Keep, MapCamera.Unlight, MapCamera.Keep ]
            , test "while the globe is turned, a dot dragged or fingers are down, the dots passing under the pointer are neither lit nor put out" <|
                \_ ->
                    [ MapCamera.pointerMoved True (\_ -> Just "a") Nothing
                    , MapCamera.pointerMoved True (\_ -> Just "b") (Just "a")
                    , MapCamera.pointerMoved True (\_ -> Nothing) (Just "a")
                    ]
                        |> Expect.equal [ MapCamera.Keep, MapCamera.Keep, MapCamera.Keep ]
            ]

        -- REQ DY-2
        , describe "click opens the page"
            [ test "a click opens the dot it was pressed on and released on; a click that ends a drag or lands on another dot opens nothing" <|
                \_ ->
                    [ MapCamera.clickOpens (Just "a") (Just "a")
                    , MapCamera.clickOpens (Just "a") (Just "b")
                    , MapCamera.clickOpens Nothing (Just "a")
                    , MapCamera.clickOpens (Just "a") Nothing
                    ]
                        |> Expect.equal [ Just "a", Nothing, Nothing, Nothing ]
            ]

        -- REQ DY-6
        , describe "phone feel"
            [ test "a dragged dot pulls its neighbour along less on the phone than on the desktop, and it still settles" <|
                \_ ->
                    let
                        held =
                            { pulls = Dict.empty, pin = Just ( "mem", ( 100, 0 ) ) }

                        free =
                            { pulls = Dict.empty, pin = Nothing }

                        follow feel =
                            run feel 400 held Motion.rest |> eastOf "events"

                        settled =
                            run Motion.phone 400 held Motion.rest
                                |> run Motion.phone 600 free
                                |> eastOf "events"
                                |> abs
                    in
                    ( follow Motion.phone < follow Motion.desktop, follow Motion.phone > 15, settled < 0.5 )
                        |> Expect.equal ( True, True, True )
            ]

        -- REQ DY-1
        -- REQ DY-2
        -- REQ DY-3
        , describe "elastic motion"
            [ test "a map at rest stays at rest and keeps its layout" <|
                \_ ->
                    let
                        ( st, settled ) =
                            Motion.step 0.016 Motion.desktop adj { pulls = Dict.empty, pin = Nothing } Motion.rest
                    in
                    ( settled, Motion.isRest st, Motion.displaced adj st ) |> Expect.equal ( True, True, [] )
            , test "a dragged dot stretches its neighbour along, and the neighbour contracts back when it is let go" <|
                \_ ->
                    let
                        held =
                            run Motion.desktop 120 { pulls = Dict.empty, pin = Just ( "mem", ( 100, 0 ) ) } Motion.rest

                        freed =
                            run Motion.desktop 600 { pulls = Dict.empty, pin = Nothing } held
                    in
                    ( eastOf "events" held > 10 && eastOf "events" held < 100, abs (eastOf "events" freed) < 0.5, eastOf "mem" held )
                        |> Expect.equal ( True, True, 100 )
            , test "the neighbours of a hovered dot are drawn towards it and settle there" <|
                \_ ->
                    let
                        pulls =
                            Dict.fromList [ ( "events", ( -20, 0 ) ) ]

                        end =
                            run Motion.desktop 900 { pulls = pulls, pin = Nothing } Motion.rest
                    in
                    ( eastOf "events" end |> (\x -> x < -8 && x > -20.5)
                    , Motion.step 0.016 Motion.desktop adj { pulls = pulls, pin = Nothing } end |> Tuple.second
                    )
                        |> Expect.equal ( True, True )
            ]

        -- REQ DY-5
        , describe "hover stays put"
            [ test "the dot answers the pointer where it rests, and its displaced drawing does not" <|
                \_ ->
                    let
                        mem =
                            dotOf "mem"

                        moved =
                            drawn (Motion.from adj (Dict.fromList [ ( "mem", ( 60, 0 ) ) ])) Nothing |> Query.fromHtml

                        restPlace =
                            "translate(" ++ String.fromFloat (toFloat (round (mem.spot.x * 10)) / 10) ++ "," ++ String.fromFloat (toFloat (round (mem.spot.y * 10)) / 10) ++ ")"
                    in
                    Expect.all
                        [ \_ -> MapGeometry.hitAt (geometryAt home) mem.spot.x mem.spot.y |> Expect.equal (Just "mem")
                        , \_ -> moved |> Query.findAll [ Selector.all [ Selector.class "node", Selector.attribute (Svg.Attributes.transform restPlace) ] ] |> Query.count (Expect.equal 0)
                        , \_ -> moved |> Query.findAll [ Selector.class "node" ] |> Query.count (Expect.atLeast 2)
                        ]
                        ()
            ]

        -- REQ DY-8
        , describe "only displaced dots are placed again"
            [ test "a displaced dot is drawn where its displaced place on the globe is, one that rests at its cached place" <|
                \_ ->
                    let
                        it =
                            Dict.get "mem" statics.byId |> Maybe.andThen (\i -> Array.get i statics.items) |> Maybe.map .vec |> Maybe.withDefault (Globe.nodeOf 0 0)

                        v =
                            GlobeGrab.displace it (60 / MapCamera.mrad) 0

                        placed =
                            Globe.place (Globe.camera screen home) v.x v.y v.z

                        tenth n =
                            String.fromFloat (toFloat (round (n * 10)) / 10)

                        at x y =
                            "translate(" ++ tenth x ++ "," ++ tenth y ++ ")"

                        events =
                            dotOf "events"

                        page =
                            drawn (Motion.from adj (Dict.fromList [ ( "mem", ( 60, 0 ) ) ])) Nothing |> Query.fromHtml

                        nodeAt p =
                            page |> Query.findAll [ Selector.all [ Selector.class "node", Selector.attribute (Svg.Attributes.transform p) ] ]
                    in
                    Expect.all
                        [ \_ -> nodeAt (at placed.x placed.y) |> Query.count (Expect.equal 1)
                        , \_ -> nodeAt (at events.spot.x events.spot.y) |> Query.count (Expect.equal 1)
                        ]
                        ()
            , test "the geometry does not depend on the displacement, and changes with the zoom" <|
                \_ ->
                    let
                        spotAt z =
                            (geometryAt { lam = 0, beta = 0, z = z }).dots |> Array.get 0 |> Maybe.map .spot
                    in
                    Expect.all
                        [ \_ -> Expect.equal (geometryAt home) (geometryAt home)
                        , \_ -> Expect.notEqual (spotAt 1) (spotAt 1.5)
                        ]
                        ()
            , test "lighting a dot lights exactly the lines that end at it, though the other lines come from the cache" <|
                \_ ->
                    let
                        litLines lit =
                            drawn Motion.rest lit
                                |> Query.fromHtml
                                |> Query.findAll [ Selector.all [ Selector.class "edge", Selector.class "lit" ] ]
                                |> Query.count
                                    (Expect.equal
                                        (if lit == Just "mem" then
                                            3

                                         else if lit == Just "events" then
                                            1

                                         else
                                            0
                                        )
                                    )
                    in
                    Expect.all [ \_ -> litLines Nothing, \_ -> litLines (Just "mem"), \_ -> litLines (Just "events") ] ()
            , test "a line to a displaced dot follows it, and a line between dots at rest stays where they rest" <|
                \_ ->
                    let
                        mem =
                            dotOf "mem"

                        events =
                            dotOf "events"

                        feedsLine motion =
                            drawn motion Nothing
                                |> Query.fromHtml
                                |> Query.find [ Selector.all [ Selector.class "edge", Selector.class "feeds", Selector.attribute (Svg.Attributes.x2 (tenthOf events.spot.x)) ] ]
                    in
                    Expect.all
                        [ \_ -> feedsLine Motion.rest |> Query.has [ Selector.attribute (Svg.Attributes.x1 (tenthOf mem.spot.x)) ]
                        , \_ -> feedsLine (Motion.from adj (Dict.fromList [ ( "mem", ( 60, 0 ) ) ])) |> Query.hasNot [ Selector.attribute (Svg.Attributes.x1 (tenthOf mem.spot.x)) ]
                        ]
                        ()
            , test "when everything has settled with nothing pulling or holding, no dot is displaced any more" <|
                \_ ->
                    run Motion.desktop 1500 { pulls = Dict.empty, pin = Nothing } (run Motion.desktop 60 { pulls = Dict.empty, pin = Just ( "mem", ( 40, 0 ) ) } Motion.rest)
                        |> (\st -> ( Motion.displaced adj st, Motion.isRest st ))
                        |> Expect.equal ( [], True )
            ]

        -- REQ DY-7
        , describe "hover stays put: labels"
            [ test "a displaced label does not answer the pointer, a label at rest does" <|
                \_ ->
                    let
                        labelEvents off =
                            MapView.node (dotOf "mem") { look | offset = off }
                                |> (\n -> Svg.svg [] [ n ])
                                |> Query.fromHtml
                                |> Query.find [ Selector.all [ Selector.tag "text", Selector.class "label" ] ]
                                |> Query.has [ Selector.attribute (Svg.Attributes.pointerEvents (if off == ( 0, 0 ) then "all" else "none")) ]
                    in
                    Expect.all [ \_ -> labelEvents ( 0, 0 ), \_ -> labelEvents ( 9, -4 ) ] ()
            , test "while a dot is lit the map is marked, and only the lit dot and its neighbours are, so the stylesheet dims the rest" <|
                \_ ->
                    let
                        page lit =
                            drawn Motion.rest lit |> Query.fromHtml
                    in
                    Expect.all
                        [ \_ -> page Nothing |> Query.hasNot [ Selector.class "focus" ]
                        , \_ -> page (Just "events") |> Query.has [ Selector.class "focus" ]
                        , \_ -> page (Just "events") |> Query.findAll [ Selector.class "near" ] |> Query.count (Expect.equal 2)
                        , \_ -> page (Just "events") |> Query.findAll [ Selector.class "active" ] |> Query.count (Expect.equal 1)
                        , \_ -> page Nothing |> Query.findAll [ Selector.class "near" ] |> Query.count (Expect.equal 0)
                        ]
                        ()
            , test "a dot's label is decided at its resting place, even if the pull has drawn it towards the border" <|
                \_ ->
                    let
                        -- zoomed in, so that the dot in the middle has a label of its own
                        labelled motion =
                            MapView.map (geometryAt { lam = 0, beta = 0, z = 2 }) statics motion adj 800 500 Nothing
                                |> Query.fromHtml
                                |> Query.findAll [ Selector.all [ Selector.tag "text", Selector.class "label" ] ]
                                |> Query.count (Expect.atLeast 1)
                    in
                    Expect.all
                        [ \_ -> labelled Motion.rest
                        , \_ -> labelled (Motion.from adj (Dict.fromList [ ( "mem", ( 900, 0 ) ) ]))
                        ]
                        ()
            , test "the dot is drawn as an ellipse where the globe turns away, and a lit dot has no hit disc to grow" <|
                \_ ->
                    let
                        rim =
                            MapView.node (dotOf "quizapp") { look | active = True }
                                |> (\n -> Svg.svg [] [ n ])
                                |> Query.fromHtml
                    in
                    Expect.all
                        [ \_ -> rim |> Query.find [ Selector.class "dot" ] |> Query.has [ Selector.attribute (Html.Attributes.attribute "transform" (flattenOf (dotOf "quizapp"))) ]
                        , \_ -> rim |> Query.findAll [ Selector.class "hit" ] |> Query.count (Expect.equal 0)
                        ]
                        ()
            ]

        -- REQ DY-4
        , describe "motion start"
            [ test "dots can start displaced and at rest, to spring to their place" <|
                \_ ->
                    Motion.from adj (Dict.fromList [ ( "mem", ( 5, -5 ) ) ])
                        |> Motion.displaced adj
                        |> Expect.equal [ ( "mem", 5, -5 ) ]
            ]


        -- REQ MB-1
        -- REQ MB-8
        , describe "phone map"
            [ test "on a phone the map is as tall as the window and no boxes are left under it" <|
                \_ ->
                    [ ( 360, 640 ), ( 412, 915 ), ( 760, 1000 ) ]
                        |> List.map (\( w, h ) -> ( (MapSize.sizes w h).map, (MapSize.sizes w h).box ))
                        |> Expect.equal [ ( 640, Nothing ), ( 915, Nothing ), ( 1000, Nothing ) ]
            , test "761 px is not a phone" <|
                \_ -> ( MapSize.isPhone 760, MapSize.isPhone 761 ) |> Expect.equal ( True, False )
            , test "the graph is centred below the search bar and its chips" <|
                \_ -> MapSize.insets 390 |> Tuple.first |> Expect.greaterThan 100
            ]

        -- REQ MB-2
        -- REQ MB-3
        , describe "phone balloon"
            [ test "it shows the node's title, the link to its page and both texts" <|
                \_ ->
                    case Data.nodeById graph "mem" of
                        Just n ->
                            MapView.sheet En graph n
                                |> Query.fromHtml
                                |> Expect.all
                                    [ Query.has [ Selector.text "mem is a thing." ]
                                    , Query.has [ Selector.text "Does mem." ]
                                    , Query.find [ Selector.class "sheet-open" ] >> Query.has [ Selector.attribute (Html.Attributes.href "/p/mem") ]
                                    ]

                        Nothing ->
                            Expect.fail "no node"
            , test "a neighbour is a button that selects it" <|
                \_ ->
                    case Data.nodeById graph "mem" of
                        Just n ->
                            MapView.sheet En graph n
                                |> Query.fromHtml
                                |> Query.find [ Selector.class "pill", Selector.containing [ Selector.text "Giovanni" ] ]
                                |> Event.simulate Event.click
                                |> Event.expect (SelectNode "giovanni")

                        Nothing ->
                            Expect.fail "no node"
            , test "the close button closes it" <|
                \_ ->
                    case Data.nodeById graph "mem" of
                        Just n ->
                            MapView.sheet En graph n
                                |> Query.fromHtml
                                |> Query.find [ Selector.class "sheet-close" ]
                                |> Event.simulate Event.click
                                |> Event.expect CloseSheet

                        Nothing ->
                            Expect.fail "no node"
            ]

        -- REQ MB-4
        , describe "phone article"
            [ test "on a phone a section's text is hidden until its heading is tapped" <|
                \_ ->
                    ArticleView.view En graph 0 True Set.empty phoneArticle
                        |> Query.fromHtml
                        |> Expect.all
                            [ Query.has [ Selector.text "Lead text." ]
                            , Query.hasNot [ Selector.text "Body text." ]
                            , Query.find [ Selector.class "sec-toggle" ] >> Event.simulate Event.click >> Event.expect (ToggleSection "does")
                            ]
            , test "an opened section shows its text" <|
                \_ ->
                    ArticleView.view En graph 0 True (Set.fromList [ "does" ]) phoneArticle
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "Body text." ]
            , test "on a wide window the sections are always open" <|
                \_ ->
                    ArticleView.view En graph 0 False Set.empty phoneArticle
                        |> Query.fromHtml
                        |> Query.has [ Selector.text "Body text." ]
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
                        , \_ -> (MapSize.sizes 800 500).map |> Expect.equal 320
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
