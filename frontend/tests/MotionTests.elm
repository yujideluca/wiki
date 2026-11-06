module MotionTests exposing (suite)

{-| The spring layer rewritten on number-indexed arrays (`Motion`) against the dictionary version it replaced (`MotionOld`): the same
graph, the same pulls and pin, 400 steps, every dot's displacement equal to 1e-9 at every step, and the same "settled" answer. -}

import Data exposing (Edge, EdgeType(..))
import Dict exposing (Dict)
import Expect
import Motion
import MotionOld
import Test exposing (Test, describe, test)


names : List String
names =
    [ "a", "b", "c", "d", "e", "f", "g", "h", "lonely" ]


edges : List Edge
edges =
    [ ( "a", "b" ), ( "a", "c" ), ( "a", "d" ), ( "b", "c" ), ( "c", "e" ), ( "e", "f" ), ( "f", "g" ), ( "g", "e" ), ( "h", "h" ) ]
        |> List.map (\( x, y ) -> { from = x, to = y, edgeType = Mentions })


offsets : Dict String ( Float, Float )
offsets =
    Dict.fromList (List.indexedMap (\i n -> ( n, ( toFloat i * 3 - 10, 7 - toFloat i * 2 ) )) names)


feel : Motion.Feel
feel =
    Motion.desktop


oldFeel : MotionOld.Feel
oldFeel =
    MotionOld.desktop


forcesAt : Int -> { pulls : Dict String ( Float, Float ), pin : Maybe ( String, ( Float, Float ) ) }
forcesAt k =
    if k < 80 then
        { pulls = Dict.fromList [ ( "b", ( 4, -3 ) ), ( "c", ( 2, 5 ) ), ( "d", ( -6, 1 ) ) ], pin = Nothing }

    else if k < 160 then
        { pulls = Dict.empty, pin = Just ( "e", ( 12, -9 ) ) }

    else if k < 200 then
        { pulls = Dict.fromList [ ( "lonely", ( 3, 3 ) ) ], pin = Nothing }

    else
        { pulls = Dict.empty, pin = Nothing }


run : Int -> ( Motion.State, MotionOld.State ) -> List ( Float, Bool )
run k ( new, old ) =
    if k >= 400 then
        []

    else
        let
            adjN =
                Motion.adjacency names edges

            adjO =
                MotionOld.adjacency edges

            f =
                forcesAt k

            ( n2, sn ) =
                Motion.step 0.016 feel adjN f new

            ( o2, so ) =
                MotionOld.step 0.016 oldFeel adjO f old

            dispN =
                Motion.displaced adjN n2 |> List.map (\( id, x, y ) -> ( id, ( x, y ) )) |> Dict.fromList

            gap =
                names
                    |> List.map
                        (\id ->
                            let
                                ( nx, ny ) =
                                    Dict.get id dispN |> Maybe.withDefault ( 0, 0 )

                                ( ox, oy ) =
                                    Dict.get id o2 |> Maybe.map (\b -> ( b.dx, b.dy )) |> Maybe.withDefault ( 0, 0 )
                            in
                            max (abs (nx - ox)) (abs (ny - oy))
                        )
                    |> List.maximum
                    |> Maybe.withDefault 0
        in
        ( gap, sn == so ) :: run (k + 1) ( n2, o2 )


suite : Test
suite =
    describe "Motion on arrays equals Motion on dictionaries"
        [ test "400 steps with pulls, a pin and a lonely dot" <|
            \_ ->
                let
                    adjN =
                        Motion.adjacency names edges

                    start =
                        ( Motion.from adjN offsets, MotionOld.from offsets )

                    rows =
                        run 0 start
                in
                Expect.all
                    [ \r -> Expect.atMost 1.0e-9 (r |> List.map Tuple.first |> List.maximum |> Maybe.withDefault 0)
                    , \r -> Expect.equal True (List.all Tuple.second r)
                    , \r -> Expect.equal 400 (List.length r)
                    ]
                    rows
        , test "it comes to rest and says so" <|
            \_ ->
                let
                    adjN =
                        Motion.adjacency names edges

                    go k st =
                        if k > 3000 then
                            ( st, False )

                        else
                            let
                                ( s2, done ) =
                                    Motion.step 0.016 feel adjN { pulls = Dict.empty, pin = Nothing } st
                            in
                            if done then
                                ( s2, True )

                            else
                                go (k + 1) s2
                in
                go 0 (Motion.from adjN offsets)
                    |> (\( st, done ) -> Expect.equal ( True, True ) ( done, Motion.isRest st ))
        ]
