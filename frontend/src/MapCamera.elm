module MapCamera exposing (Pointer(..), camOf, centreOn, clickOpens, fit, hitAt, hoverPulls, mrad, pinOf, pointerMoved, reflow, refreshGeometry, resized, screenOf)

{-| Where the map's dots go on the screen: sizing the map for the window, putting the layout on the sphere, the camera, centring
on a dot, the springs' starting displacements and the pulls and pin that move the dots. They are plain functions of the model,
kept out of `Main` so that it stays small.

The elastic layer (`Motion`) keeps two numbers per dot, its displacement east and north on the sphere, in milliradians
(`mrad`), so that its thresholds mean about what they meant in pixels. -}

import Dict
import Globe
import GlobeGrab
import Layout
import MapGeometry
import MapSize
import Motion
import Types exposing (Load(..), Model)


{-| Milliradians per radian. -}
mrad : Float
mrad =
    1000


{-| Bring the map's caches up to date (see `MapGeometry`): the statics only when the layout, graph or filter has
changed, the geometry only when the camera has, which a spring, a hover or a drag of a dot does not do. Called after every
message, so that the view always finds it current. -}
refreshGeometry : Model -> Model
refreshGeometry model =
    case model.graph of
        Loaded g ->
            let
                skey =
                    { graph = g, sphere = model.sphere, project = model.project, month = model.month }

                newStatics =
                    model.statics.key /= Just skey

                statics =
                    if newStatics then
                        MapGeometry.buildStatics skey

                    else
                        model.statics

                s =
                    screenOf model

                gkey =
                    { lam = model.view.lam, beta = model.view.beta, z = model.view.z, cx = s.cx, cy = s.cy, rho = s.rho }
            in
            if not newStatics && model.geometry.key == Just gkey then
                model

            else
                { model | statics = statics, geometry = MapGeometry.build gkey (Globe.camera s model.view) statics }

        _ ->
            model


{-| The window is [w] by [h]: size the map and the info boxes for it (MP-5). -}
resized : Float -> Float -> Model -> Model
resized w h model =
    let
        sz =
            MapSize.sizes w h
    in
    { model | width = w, height = sz.map, boxHeight = sz.box }


{-| Put the layout on the sphere (cylindrical equal-area, see `Globe.embed`): the layout is stretched towards the shape of the
cylinder (2 pi by 2 sin 71.8 degrees), then every dot becomes a unit vector, once. -}
fit : Model -> Model
fit model =
    let
        shaped =
            Layout.matchAspect (pi / 0.95) model.layout

        box =
            Globe.embedFit (Dict.values shaped)
    in
    { model | sphere = Dict.map (\_ p -> Globe.embed p box) shaped }


{-| The ball of the map area: a circle centred in what the floating controls leave free, which fits the free area exactly at
zoom 1. On a phone, while a dot is selected the balloon covers the lower part of the screen, so the circle shrinks into the part
that stays visible. -}
screenOf : Model -> Globe.Screen
screenOf model =
    let
        ( top, bottom ) =
            MapSize.insets model.width

        phone =
            MapSize.isPhone model.width

        lower =
            if phone && model.selected /= Nothing then
                model.height * 0.48

            else
                model.height - bottom

        areaHeight =
            max 100 (lower - top)
    in
    { cx = model.width / 2, cy = top + areaHeight / 2, rho = min model.width areaHeight / 2 }


camOf : Model -> Globe.Cam
camOf model =
    Globe.camera (screenOf model) model.view


{-| The dot under the pointer at window position [x], [y], or none: the nearest (by fraction of its own reach) of the dots that are
seen. A dot answers within its drawn radius plus 8 pixels, as its invisible disc used to; there are no discs in the page any more,
so moving the globe no longer rewrites them. The dots are taken at their resting places, as the discs were. -}
hitAt : Model -> Float -> Float -> Maybe String
hitAt model x y =
    MapGeometry.hitAt model.geometry x y


{-| What a pointer that has moved does to the lit dot. -}
type Pointer
    = Keep
    | Light String
    | Unlight


{-| A pointer that is only moving (no globe turned by it, no dot dragged, no fingers down) lights the dot under it and puts out
the light when it leaves. While [busy] nothing is looked for: the dots passing under a drag would be lit and let go again, start
their springs and create and remove their labels on every move (DY-9). [lookup] is only run when the pointer is free to light. -}
pointerMoved : Bool -> (() -> Maybe String) -> Maybe String -> Pointer
pointerMoved busy lookup hovered =
    if busy then
        Keep

    else
        case ( lookup (), hovered ) of
            ( Just id, Just h ) ->
                if id == h then
                    Keep

                else
                    Light id

            ( Just id, Nothing ) ->
                Light id

            ( Nothing, Just _ ) ->
                Unlight

            ( Nothing, Nothing ) ->
                Keep


{-| A click opens the page of the dot it is on only if the mouse was pressed on that same dot: the click that ends a drag, or
one that lands on another dot, opens nothing (DY-2). -}
clickOpens : Maybe String -> Maybe String -> Maybe String
clickOpens found pressed =
    case ( found, pressed ) of
        ( Just id, Just p ) ->
            if id == p then
                Just id

            else
                Nothing

        _ ->
            Nothing


{-| Turn the globe so that [id] is in the middle, zoomed in a little. -}
centreOn : String -> Model -> Model
centreOn id model =
    case Dict.get id model.sphere of
        Just n ->
            { model | view = { lam = n.l, beta = n.b, z = max 1.15 model.view.z } }

        Nothing ->
            model


{-| After the layout is first laid out the dots start gathered towards the middle of the view and spring open. -}
reflow : Model -> Model -> Model
reflow old new =
    if Dict.isEmpty old.sphere then
        { new
            | motion = Motion.from new.adj (Dict.map (\_ n -> ( -0.55 * n.l * n.ty * mrad, -0.55 * n.b * mrad )) new.sphere)
            , moving = True
        }

    else
        { new | moving = True }


{-| Displacements the hovered dot's neighbours are drawn towards: a fifth of the way to it, by at most 14 pixels (DY-3). Only the
hovered dot and its neighbours are looked at. -}
hoverPulls : Model -> Dict.Dict String ( Float, Float )
hoverPulls model =
    let
        phone =
            MapSize.isPhone model.width

        -- a phone has no hover: the selected dot does it, more gently (DY-6)
        source =
            if phone then
                model.selected

            else
                model.hovered

        fraction =
            if phone then
                0.12

            else
                0.2

        capPx =
            if phone then
                10

            else
                14
    in
    case source |> Maybe.andThen (\h -> Dict.get h model.sphere |> Maybe.map (Tuple.pair h)) of
        Just ( h, hv ) ->
            let
                cam =
                    camOf model

                hVec =
                    vecOf hv
            in
            Just (Motion.neighbours model.adj h)
                |> Maybe.withDefault []
                |> List.filterMap
                    (\n ->
                        Dict.get n model.sphere
                            |> Maybe.map
                                (\nv ->
                                    let
                                        ( de, dn ) =
                                            GlobeGrab.components nv (GlobeGrab.hoverPull cam (vecOf nv) hVec fraction capPx)
                                    in
                                    ( n, ( de * mrad, dn * mrad ) )
                                )
                    )
                |> Dict.fromList

        Nothing ->
            Dict.empty


{-| The dragged dot is held at the pointer once the pointer has moved: its displacement is the log map from where it rests to the
point of the sphere under the pointer (the rim's nearest point when the pointer is outside the ball). -}
pinOf : Model -> Maybe ( String, ( Float, Float ) )
pinOf model =
    case model.drag of
        Just d ->
            if d.moved then
                Dict.get d.id model.sphere
                    |> Maybe.map
                        (\n ->
                            let
                                cam =
                                    camOf model

                                target =
                                    Globe.unrotate cam (Globe.targetPoint cam d.target)

                                ( de, dn ) =
                                    GlobeGrab.components n (GlobeGrab.logMap (vecOf n) target)
                            in
                            ( d.id, ( de * mrad, dn * mrad ) )
                        )

            else
                Nothing

        Nothing ->
            Nothing


vecOf : Globe.Node -> Globe.Vec
vecOf n =
    { x = n.x, y = n.y, z = n.z }
