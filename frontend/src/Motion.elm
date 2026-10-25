module Motion exposing (Adjacency, Body, Forces, State, adjacency, apply, from, step)

{-| The map's elastic layer (DY-1..DY-4). The layout puts every dot at a resting place; on top of it each dot has a
small displacement that behaves like a mass on springs: one spring pulls it back to its resting place, one pulls it
towards the average displacement of its neighbours (so a dot dragged away stretches its neighbours along, and they
contract when it is let go), and friction lets it settle with a little wobble. At rest every displacement is zero, so
the layout (and requirement MP-6) is unchanged. -}

import Data exposing (Edge)
import Dict exposing (Dict)
import Layout exposing (Positions)
import Set


type alias Body =
    { dx : Float
    , dy : Float
    , vx : Float
    , vy : Float
    }


type alias State =
    Dict String Body


type alias Adjacency =
    Dict String (List String)


{-| What pushes the dots right now: [pulls] are displacements some dots are drawn towards (the neighbours of the
hovered dot), [pin] is a dot held at a displacement (the dragged one). -}
type alias Forces =
    { pulls : Dict String ( Float, Float )
    , pin : Maybe ( String, ( Float, Float ) )
    }


stiffness : Float
stiffness =
    55


coupling : Float
coupling =
    45


damping : Float
damping =
    7.5


adjacency : List Edge -> Adjacency
adjacency edges =
    let
        add a b =
            Dict.update a (\m -> Just (b :: Maybe.withDefault [] m))
    in
    edges
        |> List.filter (\e -> e.from /= e.to)
        |> List.foldl (\e acc -> acc |> add e.from e.to |> add e.to e.from) Dict.empty
        |> Dict.map (\_ ids -> Set.toList (Set.fromList ids))


{-| A state where every dot is displaced as given and at rest. -}
from : Dict String ( Float, Float ) -> State
from offsets =
    Dict.map (\_ ( dx, dy ) -> { dx = dx, dy = dy, vx = 0, vy = 0 }) offsets


displacement : State -> String -> ( Float, Float )
displacement state id =
    Dict.get id state |> Maybe.map (\b -> ( b.dx, b.dy )) |> Maybe.withDefault ( 0, 0 )


{-| Advance by [dt] seconds. The second value is True when everything has come to rest, so the page can stop asking
for animation frames. -}
step : Float -> Adjacency -> Forces -> State -> ( State, Bool )
step dt adj forces state =
    let
        one id b =
            case forces.pin of
                Just ( pid, ( px, py ) ) ->
                    if pid == id then
                        ( { dx = px, dy = py, vx = 0, vy = 0 }, False )

                    else
                        free id b

                Nothing ->
                    free id b

        free id b =
            let
                nbrs =
                    Dict.get id adj |> Maybe.withDefault []

                ( mx, my ) =
                    if List.isEmpty nbrs then
                        ( b.dx, b.dy )

                    else
                        let
                            ds =
                                List.map (displacement state) nbrs

                            n =
                                toFloat (List.length ds)
                        in
                        ( List.sum (List.map Tuple.first ds) / n, List.sum (List.map Tuple.second ds) / n )

                ( tx, ty ) =
                    Dict.get id forces.pulls |> Maybe.withDefault ( 0, 0 )

                ax =
                    -stiffness * (b.dx - tx) + coupling * (mx - b.dx) - damping * b.vx

                ay =
                    -stiffness * (b.dy - ty) + coupling * (my - b.dy) - damping * b.vy

                vx =
                    b.vx + ax * dt

                vy =
                    b.vy + ay * dt
            in
            ( { dx = b.dx + vx * dt, dy = b.dy + vy * dt, vx = vx, vy = vy }
            , abs ax < 0.4 && abs ay < 0.4 && abs vx < 0.04 && abs vy < 0.04
            )

        -- a dot with no entry yet starts at rest at zero
        fresh =
            { dx = 0, dy = 0, vx = 0, vy = 0 }

        withEntry id acc =
            if Dict.member id acc then
                acc

            else
                Dict.insert id fresh acc

        withPin =
            Dict.foldl (\id _ acc -> withEntry id acc) state adj
                |> (\acc -> Dict.foldl (\id _ a -> withEntry id a) acc forces.pulls)
                |> (\acc -> forces.pin |> Maybe.map (\( pid, _ ) -> withEntry pid acc) |> Maybe.withDefault acc)

        stepped =
            Dict.map one withPin

        settled =
            forces.pin == Nothing && Dict.foldl (\_ ( _, rest ) ok -> ok && rest) True stepped
    in
    ( Dict.map (\_ ( b, _ ) -> b) stepped, settled )


{-| Resting places plus displacements. -}
apply : State -> Positions -> Positions
apply state positions =
    Dict.map
        (\id ( x, y ) ->
            case Dict.get id state of
                Just b ->
                    ( x + b.dx, y + b.dy )

                Nothing ->
                    ( x, y )
        )
        positions
