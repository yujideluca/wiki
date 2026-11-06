module Motion exposing (Adjacency, Body, Feel, Forces, State, adjacency, desktop, displaced, from, isRest, neighbours, noAdjacency, phone, rest, step)

{-| The map's elastic layer (DY-1..DY-4). The layout puts every dot at a resting place; on top of it each dot has a
small displacement that behaves like a mass on springs: one spring pulls it back to its resting place, one pulls it
towards the average displacement of its neighbours (so a dot dragged away stretches its neighbours along, and they
contract when it is let go), and friction lets it settle with a little wobble. At rest every displacement is zero, so
the layout (and requirement MP-6) is unchanged.

The state is kept in one array indexed by a number per dot (the same dot always has the same number, see [Adjacency]),
not in dictionaries keyed by the dot's name: a step is then plain arithmetic on numbers plus array reads, and no text is
compared. The neighbour average is a product of the (row-normalised) neighbour matrix with the displacement vector. -}

import Array exposing (Array)
import Data exposing (Edge)
import Dict exposing (Dict)
import Set


{-| The dots by number: [ids] gives the name of dot n, [index] the number of a name, [nbrs] the numbers of the neighbours of dot n.
Built once when the graph arrives. -}
type alias Adjacency =
    { ids : Array String
    , index : Dict String Int
    , nbrs : Array (List Int)
    }


{-| One dot's elastic state: displacement and velocity, east and north, and whether it is still (nothing to do for it any more). -}
type alias Body =
    { dx : Float
    , dy : Float
    , vx : Float
    , vy : Float
    , still : Bool
    }


{-| The elastic state of every dot, in one array by dot number (empty while everything is at rest). -}
type alias State =
    { bodies : Array Body
    , awake : Bool
    }


{-| What pushes the dots right now: [pulls] are displacements some dots are drawn towards (the neighbours of the hovered dot), [pin]
is a dot held at a displacement (the dragged one). -}
type alias Forces =
    { pulls : Dict String ( Float, Float )
    , pin : Maybe ( String, ( Float, Float ) )
    }


{-| How springy the dots are: [stiffness] pulls a dot back to its place, [coupling] makes it follow its neighbours,
[damping] is the friction. The phone is stiffer, follows less and settles faster, so less elastic (DY-6). -}
type alias Feel =
    { stiffness : Float
    , coupling : Float
    , damping : Float
    }


desktop : Feel
desktop =
    { stiffness = 55, coupling = 45, damping = 7.5 }


phone : Feel
phone =
    { stiffness = 75, coupling = 32, damping = 10 }


noAdjacency : Adjacency
noAdjacency =
    { ids = Array.empty, index = Dict.empty, nbrs = Array.empty }


{-| Number the dots (all of them, also those without a line) and list each one's neighbours. -}
adjacency : List String -> List Edge -> Adjacency
adjacency names edges =
    let
        ids =
            Array.fromList names

        index =
            Dict.fromList (List.indexedMap (\i n -> ( n, i )) names)

        add a b =
            Dict.update a (\m -> Just (b :: Maybe.withDefault [] m))

        byName =
            edges
                |> List.filter (\e -> e.from /= e.to)
                |> List.foldl (\e acc -> acc |> add e.from e.to |> add e.to e.from) Dict.empty

        nbrOf n =
            Dict.get n byName
                |> Maybe.withDefault []
                |> List.filterMap (\m -> Dict.get m index)
                |> Set.fromList
                |> Set.toList
    in
    { ids = ids, index = index, nbrs = Array.fromList (List.map nbrOf names) }


neighbours : Adjacency -> String -> List String
neighbours adj id =
    Dict.get id adj.index
        |> Maybe.andThen (\i -> Array.get i adj.nbrs)
        |> Maybe.withDefault []
        |> List.filterMap (\j -> Array.get j adj.ids)


rest : State
rest =
    { bodies = Array.empty, awake = False }


isRest : State -> Bool
isRest state =
    not state.awake


zero : Body
zero =
    { dx = 0, dy = 0, vx = 0, vy = 0, still = True }


{-| A state where every dot is displaced as given and at rest. -}
from : Adjacency -> Dict String ( Float, Float ) -> State
from adj offsets =
    let
        bodies =
            Array.map
                (\id ->
                    case Dict.get id offsets of
                        Just ( dx, dy ) ->
                            { zero | dx = dx, dy = dy }

                        Nothing ->
                            zero
                )
                adj.ids
    in
    { bodies = bodies, awake = Array.foldl (\b any -> any || b.dx /= 0 || b.dy /= 0) False bodies }


{-| The dots that are away from their resting place, with their displacement. -}
displaced : Adjacency -> State -> List ( String, Float, Float )
displaced adj state =
    state.bodies
        |> Array.toIndexedList
        |> List.filterMap
            (\( i, b ) ->
                if b.dx == 0 && b.dy == 0 then
                    Nothing

                else
                    Array.get i adj.ids |> Maybe.map (\id -> ( id, b.dx, b.dy ))
            )


{-| Advance by [dt] seconds. The second value is True when everything has come to rest, so the page can stop asking
for animation frames.

Every dot is stepped, in one pass over one array: the neighbours' average is the neighbour matrix (row-normalised) times the
displacement vector, read straight from the array. A dot that nothing reaches comes out exactly at zero. With every dot at rest
and nothing pulling or holding, nothing is done at all. When everything has settled with nothing pulling or holding, the small
leftovers are dropped, so that at rest every displacement is exactly zero (DY-1). -}
step : Float -> Feel -> Adjacency -> Forces -> State -> ( State, Bool )
step dt feel adj forces state =
    if isRest state && Dict.isEmpty forces.pulls && forces.pin == Nothing then
        ( state, True )

    else
        let
            n =
                Array.length adj.ids

            old =
                if Array.isEmpty state.bodies then
                    Array.repeat n zero

                else
                    state.bodies

            pullAt : Array ( Float, Float )
            pullAt =
                Dict.foldl
                    (\id t acc -> Dict.get id adj.index |> Maybe.map (\i -> Array.set i t acc) |> Maybe.withDefault acc)
                    (Array.repeat n ( 0, 0 ))
                    forces.pulls

            pin : Maybe ( Int, ( Float, Float ) )
            pin =
                forces.pin |> Maybe.andThen (\( id, t ) -> Dict.get id adj.index |> Maybe.map (\i -> ( i, t )))

            one i b =
                case pin of
                    Just ( pid, ( px, py ) ) ->
                        if pid == i then
                            { dx = px, dy = py, vx = 0, vy = 0, still = False }

                        else
                            free i b

                    Nothing ->
                        free i b

            free i b =
                let
                    nb =
                        Array.get i adj.nbrs |> Maybe.withDefault []

                    ( mx, my ) =
                        if List.isEmpty nb then
                            ( b.dx, b.dy )

                        else
                            let
                                sum =
                                    List.foldl
                                        (\j ( sx, sy ) ->
                                            case Array.get j old of
                                                Just o ->
                                                    ( sx + o.dx, sy + o.dy )

                                                Nothing ->
                                                    ( sx, sy )
                                        )
                                        ( 0, 0 )
                                        nb

                                k =
                                    toFloat (List.length nb)
                            in
                            ( Tuple.first sum / k, Tuple.second sum / k )

                    ( tx, ty ) =
                        Array.get i pullAt |> Maybe.withDefault ( 0, 0 )

                    ax =
                        -feel.stiffness * (b.dx - tx) + feel.coupling * (mx - b.dx) - feel.damping * b.vx

                    ay =
                        -feel.stiffness * (b.dy - ty) + feel.coupling * (my - b.dy) - feel.damping * b.vy

                    vx =
                        b.vx + ax * dt

                    vy =
                        b.vy + ay * dt
                in
                { dx = b.dx + vx * dt
                , dy = b.dy + vy * dt
                , vx = vx
                , vy = vy
                , still = abs ax < 0.4 && abs ay < 0.4 && abs vx < 0.04 && abs vy < 0.04
                }

            next =
                Array.indexedMap one old

            settled =
                forces.pin == Nothing && Array.foldl (\b ok -> ok && b.still) True next
        in
        if settled && Dict.isEmpty forces.pulls then
            ( rest, True )

        else
            ( { bodies = next, awake = True }, settled )
