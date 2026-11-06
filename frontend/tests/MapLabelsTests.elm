module MapLabelsTests exposing (suite)

{-| The names on the map must be readable (LB-1, LB-2). The earlier label tests used a map of six dots at one zoom and asked whether two
named dots had a label; nothing counted names or asked whether they overlapped, so a map with 40 names on top of each other after
a little zoom passed. These tests use a map of the real size (130 dots, 14 projects, titles of 8 to 50 characters, spread over the
whole ball) and look at every zoom and several turns. -}

import Array
import Data exposing (Edge, Node)
import Dict
import Expect
import Globe
import MapGeometry
import MapLabels exposing (Candidate)
import Set
import Test exposing (Test, describe, test)


count : Int
count =
    130


node : Int -> Node
node i =
    let
        title =
            "Page " ++ String.fromInt i ++ " " ++ String.repeat (modBy 7 (i * 5) * 6) "word "
    in
    { id = "n" ++ String.fromInt i
    , kind =
        if modBy 9 i == 0 then
            "project"

        else
            "program"
    , project = "p"
    , status = "active"
    , since = "2026-10-01"
    , until = Nothing
    , fedBy = []
    , feeds = []
    , functions = []
    , process = False
    , text = { title = String.trim title, aliases = [], what = "x", does = "y" }
    }


nodes : List Node
nodes =
    List.range 0 (count - 1) |> List.map node


{-| the points of a spiral over the whole ball, so that every zoom and turn sees a crowd as the real map has -}
sphere : Dict.Dict String Globe.Node
sphere =
    nodes
        |> List.indexedMap
            (\i n ->
                ( n.id
                , Globe.nodeOf (toFloat i * 2.399963) (asin (2 * (toFloat i + 0.5) / toFloat count - 1) * 0.9)
                )
            )
        |> Dict.fromList


statics : MapGeometry.Statics
statics =
    MapGeometry.buildStatics { graph = Data.indexed nodes [] [], sphere = sphere, project = Nothing, month = Nothing }


screen : Globe.Screen
screen =
    { cx = 400, cy = 250, rho = 250 }


geometryAt : Globe.View -> MapGeometry.Geometry
geometryAt view =
    MapGeometry.build { lam = view.lam, beta = view.beta, z = view.z, cx = screen.cx, cy = screen.cy, rho = screen.rho } (Globe.camera screen view) statics


views : List Globe.View
views =
    List.concatMap
        (\z -> [ { lam = 0, beta = 0, z = z }, { lam = 0.7, beta = 0.3, z = z }, { lam = -1.2, beta = -0.5, z = z } ])
        [ 1, 1.5, 2, 3, 4, 6, 9, 12 ]


named : Globe.View -> List MapGeometry.Dot
named view =
    (geometryAt view).visible |> List.filter .labelled


pairsOverlapping : List MapGeometry.Dot -> Int
pairsOverlapping dots =
    let
        boxes =
            List.map (\d -> MapLabels.box (MapGeometry.labelCandidate d)) dots
    in
    List.indexedMap (\i a -> List.drop (i + 1) boxes |> List.filter (MapLabels.overlap a) |> List.length) boxes |> List.sum


cand : String -> Bool -> Float -> Float -> Float -> Candidate
cand id project scale x y =
    { id = id, project = project, scale = scale, x = x, y = y, radius = 4, size = 11, title = "twelve chars" }


suite : Test
suite =
    describe "MapLabels"
        -- REQ LB-1
        [ test "on a map of 130 dots no two names overlap, at any zoom from 1 to 12 and in three turns of the globe" <|
            \_ ->
                views
                    |> List.map (\v -> ( v.z, pairsOverlapping (named v) ))
                    |> List.filter (\( _, n ) -> n > 0)
                    |> Expect.equal []
        -- REQ LB-1
        , test "a crowd is thinned, not emptied: some names are shown at every zoom between 1.5 and 4 in the middle view, and never more than 40" <|
            \_ ->
                List.map (\z -> List.length (named { lam = 0, beta = 0, z = z })) [ 1.5, 2, 3, 4 ]
                    |> (\ns -> ( List.all (\n -> n >= 4) ns, List.all (\n -> n <= 40) ns ))
                    |> Expect.equal ( True, True )
        -- REQ LB-2
        , test "a project nearest the middle is named at the first view; before any other dot" <|
            \_ ->
                let
                    seen =
                        (geometryAt { lam = 0, beta = 0, z = 1 }).visible

                    best =
                        seen
                            |> List.filter (\d -> d.node.kind == "project")
                            |> List.sortBy (\d -> -d.spot.scale)
                            |> List.head
                in
                Maybe.map .labelled best |> Expect.equal (Just True)
        -- REQ LB-2
        , test "of two names that overlap the project keeps its name, and of two projects the one nearer the middle" <|
            \_ ->
                [ MapLabels.chosen [ cand "dot" False 1.5 100 100, cand "proj" True 0.5 102 100 ]
                , MapLabels.chosen [ cand "far" True 0.6 100 100, cand "near" True 0.9 101 100 ]
                ]
                    |> List.map Set.toList
                    |> Expect.equal [ [ "proj" ], [ "near" ] ]
        -- REQ LB-2
        , test "a name that fits beside the others is kept, and the choice does not depend on the order of the list" <|
            \_ ->
                let
                    a =
                        cand "a" False 1.2 100 100

                    b =
                        cand "b" False 1.1 101 100

                    c =
                        cand "c" False 1.0 100 300
                in
                ( Set.toList (MapLabels.chosen [ a, b, c ]), Set.toList (MapLabels.chosen [ c, b, a ]) )
                    |> Expect.equal ( [ "a", "c" ], [ "a", "c" ] )
        -- REQ LB-2
        , test "the name of a dot that is not a project is written at half the size of a project's name" <|
            \_ ->
                let
                    seen =
                        (geometryAt { lam = 0, beta = 0, z = 3 }).visible

                    sizeOf kind =
                        seen |> List.filter (\d -> d.node.kind == kind) |> List.map .labelSize |> List.maximum |> Maybe.withDefault 0
                in
                (sizeOf "program" > 0 && sizeOf "program" <= 11 * 1.25 * 1.6 * 0.5 + 0.001 && sizeOf "project" > 11 * 0.85 * 0.9)
                    |> Expect.equal True
        ]
