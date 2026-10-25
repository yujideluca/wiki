module Layout exposing (Positions, Sim, advance, compute, isDone, matchAspect, positionsOf, start)

{-| Places the nodes once with a force simulation: connected pages pull together, all pages push apart.
Nodes of the same project start near each other so projects form visible clusters.

The simulation itself has no window in mind; `matchAspect` then reshapes the result to the map area. -}

import Data exposing (Graph)
import Dict exposing (Dict)
import Force


type alias Positions =
    Dict String ( Float, Float )


{-| A force simulation that can be run a few steps at a time, so that a slow device (a phone needs about 3 seconds for the
whole run) keeps answering while the layout settles (LY-1). -}
type alias Sim =
    { state : Force.State String
    , entities : List (Force.Entity String {})
    }


compute : Graph -> Positions
compute graph =
    start graph |> advance 100000 |> positionsOf


start : Graph -> Sim
start graph =
    let
        projects =
            graph.nodes |> List.map .project |> List.foldl (\p acc -> if List.member p acc then acc else acc ++ [ p ]) []

        projectIndex p =
            projects |> List.indexedMap Tuple.pair |> List.filter (\( _, q ) -> q == p) |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault 0

        count =
            toFloat (max 1 (List.length projects))

        seed i node =
            let
                a =
                    2 * pi * toFloat (projectIndex node.project) / count

                jitter =
                    toFloat (modBy 17 (i * 7)) * 3 + 10
            in
            { id = node.id
            , x = cos a * 700 + cos (toFloat i) * jitter
            , y = sin a * 230 + sin (toFloat i) * jitter
            , vx = 0
            , vy = 0
            }

        entities =
            List.indexedMap seed graph.nodes

        ids =
            List.map .id graph.nodes

        known id =
            List.member id ids

        links =
            graph.edges
                |> List.filter (\e -> known e.from && known e.to && e.from /= e.to)
                |> List.map
                    (\e ->
                        { source = e.from
                        , target = e.to
                        , distance =
                            if e.edgeType == Data.Feeds then
                                70

                            else
                                110
                        , strength = Nothing
                        }
                    )

        sim =
            Force.simulation
                [ Force.customLinks 1 links
                , Force.manyBodyStrength -200 ids
                , Force.collision 32 ids
                , Force.center 0 0

                -- A pull towards the horizontal axis that is much stronger than the one towards the vertical axis
                -- makes the cloud settle wide and flat, like the map area, so nodes spread evenly in it.
                , Force.towardsY (List.map (\id -> { node = id, strength = 0.09, target = 0 }) ids)
                , Force.towardsX (List.map (\id -> { node = id, strength = 0.02, target = 0 }) ids)
                ]
                |> Force.iterations 400
    in
    { state = sim, entities = entities }


{-| Run up to [n] steps of the simulation. -}
advance : Int -> Sim -> Sim
advance n sim =
    if n <= 0 || Force.isCompleted sim.state then
        sim

    else
        let
            ( state, entities ) =
                Force.tick sim.state sim.entities
        in
        advance (n - 1) { state = state, entities = entities }


isDone : Sim -> Bool
isDone sim =
    Force.isCompleted sim.state


positionsOf : Sim -> Positions
positionsOf sim =
    sim.entities
        |> List.map (\e -> ( e.id, ( e.x, e.y ) ))
        |> Dict.fromList


{-| Reshapes a layout to the shape (width / height) of the area it is shown in: a wide area stretches the layout
sideways, a tall one upwards, so the nodes use all the free space instead of crowding into a round clump in the middle.
Only stretches (a factor of at most 3), so no two nodes ever get closer and the layout keeps its look. -}
matchAspect : Float -> Positions -> Positions
matchAspect aspect positions =
    let
        xs =
            Dict.values positions |> List.map Tuple.first

        ys =
            Dict.values positions |> List.map Tuple.second

        extent vs =
            Maybe.map2 (-) (List.maximum vs) (List.minimum vs) |> Maybe.withDefault 0 |> max 1

        factor =
            clamp (1 / 3) 3 (aspect / (extent xs / extent ys))

        ( sx, sy ) =
            if factor >= 1 then
                ( factor, 1 )

            else
                ( 1, 1 / factor )
    in
    Dict.map (\_ ( x, y ) -> ( x * sx, y * sy )) positions
