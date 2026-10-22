module Filter exposing (days, neighbours, visible)

{-| Which nodes the map shows: by project (D: map filter) and by date (timeline slider). -}

import Data exposing (Edge, Graph, Node)
import Set exposing (Set)


{-| `project`: Nothing = all. `asOf`: "YYYY-MM-DD"; Nothing = today. A node of another project stays visible
when it is directly connected to a node of the chosen project, so pipelines across projects stay readable. -}
visible : Maybe String -> Maybe String -> Graph -> Set String
visible project asOf graph =
    let
        existed n =
            case asOf of
                Nothing ->
                    True

                Just day ->
                    String.left 10 n.since <= day
                        && (case n.until of
                                Just u ->
                                    String.left 10 u >= day

                                Nothing ->
                                    True
                           )

        inTime =
            List.filter existed graph.nodes
    in
    case project of
        Nothing ->
            Set.fromList (List.map .id inTime)

        Just p ->
            let
                core =
                    inTime |> List.filter (\n -> n.project == p || n.id == p) |> List.map .id |> Set.fromList

                timeIds =
                    Set.fromList (List.map .id inTime)

                touching =
                    graph.edges
                        |> List.concatMap
                            (\e ->
                                if Set.member e.from core then
                                    [ e.to ]

                                else if Set.member e.to core then
                                    [ e.from ]

                                else
                                    []
                            )
                        |> List.filter (\id -> Set.member id timeIds)
            in
            Set.union core (Set.fromList touching)


neighbours : List Edge -> String -> Set String
neighbours edges id =
    edges
        |> List.concatMap
            (\e ->
                if e.from == id then
                    [ e.to ]

                else if e.to == id then
                    [ e.from ]

                else
                    []
            )
        |> Set.fromList


{-| Distinct days (YYYY-MM-DD) on which nodes appeared or retired, oldest first: the timeline's stops. -}
days : List Node -> List String
days nodes =
    nodes
        |> List.concatMap (\n -> n.since :: Maybe.withDefault [] (Maybe.map List.singleton n.until))
        |> List.map (String.left 10)
        |> List.filter (\d -> String.length d == 10)
        |> Set.fromList
        |> Set.toList
