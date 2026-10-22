module Layout exposing (Positions, compute)

{-| Places the nodes once with a force simulation: connected pages pull together, all pages push apart.
Nodes of the same project start near each other so projects form visible clusters. -}

import Data exposing (Graph)
import Dict exposing (Dict)
import Force


type alias Positions =
    Dict String ( Float, Float )


compute : Graph -> Positions
compute graph =
    let
        projects =
            graph.nodes |> List.map .project |> List.foldl (\p acc -> if List.member p acc then acc else acc ++ [ p ]) []

        projectIndex p =
            projects |> List.indexedMap Tuple.pair |> List.filter (\( _, q ) -> q == p) |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault 0

        count =
            toFloat (max 1 (List.length projects))

        start i node =
            let
                a =
                    2 * pi * toFloat (projectIndex node.project) / count

                jitter =
                    toFloat (modBy 17 (i * 7)) * 3 + 10
            in
            { id = node.id
            , x = cos a * 260 + cos (toFloat i) * jitter
            , y = sin a * 260 + sin (toFloat i) * jitter
            , vx = 0
            , vy = 0
            }

        entities =
            List.indexedMap start graph.nodes

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
                , Force.manyBodyStrength -160 ids
                , Force.collision 20 ids
                , Force.center 0 0
                ]
                |> Force.iterations 320
    in
    Force.computeSimulation sim entities
        |> List.map (\e -> ( e.id, ( e.x, e.y ) ))
        |> Dict.fromList
