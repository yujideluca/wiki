module MapCamera exposing (centreOn, growth, maxGrowth, fit, globeFit, hoverPulls, lensFor, pinOf, reflow, resized)

{-| Where the map's dots go on the screen: sizing the map for the window, fitting the layout into it, centring on a dot,
the lens, the springs' starting displacements and the pulls and pin that move the dots. They are plain functions of the
model, kept out of `Main` so that it stays small. -}

import Dict
import Layout
import Lens exposing (Lens)
import MapSize
import Motion
import Types exposing (Model)
import Zoom


{-| The window is [w] by [h]: size the map and the info boxes for it (MP-5). -}
resized : Float -> Float -> Model -> Model
resized w h model =
    let
        sz =
            MapSize.sizes w h
    in
    { model | width = w, height = sz.map, boxHeight = sz.box }


{-| Fit the whole map into the globe: the layout is reshaped to be about as tall as it is wide, so that the cloud of dots is
round like the ball it is wrapped on (LN-5), then zoomed and centred so that the farthest dot sits just inside the rim of a
ball that fits the free area exactly. The zoom scale that does this is remembered (`fitScale`): the ball grows with the zoom
from there (see `growth`). -}
fit : Model -> Model
fit model =
    let
        lens =
            lensAt 1 model

        ( shaped, k, ( tx, ty ) ) =
            globeFit lens model.layout
    in
    { model
        | positions = shaped
        , fitScale = k
        , zoom =
            Zoom.init { width = model.width, height = model.height }
                |> Zoom.scaleExtent 0.1 6
                |> Zoom.setTransform Zoom.instantly { scale = k, translate = { x = tx, y = ty } }
    }


{-| The layout made round, the zoom scale and the translation that put its farthest dot just inside the rim of [lens]. -}
globeFit : Lens -> Layout.Positions -> ( Layout.Positions, Float, ( Float, Float ) )
globeFit lens layout =
    let
        squared =
            Layout.matchAspect 1 layout

        xs =
            Dict.values squared |> List.map Tuple.first

        ys =
            Dict.values squared |> List.map Tuple.second

        ( minX, maxX ) =
            ( List.minimum xs |> Maybe.withDefault -100, List.maximum xs |> Maybe.withDefault 100 )

        ( minY, maxY ) =
            ( List.minimum ys |> Maybe.withDefault -100, List.maximum ys |> Maybe.withDefault 100 )

        ( mx, my ) =
            ( (minX + maxX) / 2, (minY + maxY) / 2 )

        ( hx, hy ) =
            ( max 1 ((maxX - minX) / 2), max 1 ((maxY - minY) / 2) )

        half =
            max hx hy

        -- the square of the layout becomes a disc, so that the dots fill the ball and the rim is as populated as the middle:
        -- a point keeps its direction and its distance, measured as a share of the square it lies on, becomes a share of the disc
        round_ ( x, y ) =
            let
                ( u, v ) =
                    ( (x - mx) / hx, (y - my) / hy )

                len =
                    sqrt (u * u + v * v)

                f =
                    if len < 0.0001 then
                        1

                    else
                        max (abs u) (abs v) / len
            in
            ( u * f * half, v * f * half )

        shaped =
            Dict.map (\_ p -> round_ p) squared

        k =
            clamp 0.15 1.6 (0.94 * min lens.hw lens.hh / (half + 12))
    in
    ( shaped, k, ( lens.cx, lens.cy ) )


centreOn : String -> Model -> Model
centreOn id model =
    case Dict.get id model.positions of
        Just ( x, y ) ->
            let
                k =
                    max 1.1 (Zoom.asRecord model.zoom).scale

                -- the node goes to the middle of the lens's focus (on a phone, above the balloon)
                targetY =
                    (lensFor model).cy
            in
            { model
                | zoom =
                    Zoom.setTransform (Zoom.animatedAround ( model.width / 2, model.height / 2 ))
                        { scale = k, translate = { x = model.width / 2 - k * x, y = targetY - k * y } }
                        model.zoom
            }

        Nothing ->
            model


{-| The lens of the map area (LN-1, LN-5): a circle centred in what the floating controls leave free, whose size follows the
zoom (see `growth`). On a phone, while a dot is selected the balloon covers the lower part of the screen, so the circle
shrinks into the part that stays visible and the selected dot lands in the middle of it. -}
lensFor : Model -> Lens
lensFor model =
    lensAt (growth ((Zoom.asRecord model.zoom).scale / model.fitScale)) model


{-| The lens with the ball [g] times the size of the one that fits the free area exactly. -}
lensAt : Float -> Model -> Lens
lensAt g model =
    let
        ( top, bottom ) =
            MapSize.insets model.width

        phone =
            MapSize.isPhone model.width

        -- the balloon covers about the lower half of a phone
        lower =
            if phone && model.selected /= Nothing then
                model.height * 0.48

            else
                model.height - bottom

        areaHeight =
            max 100 (lower - top)

        radius =
            g * min model.width areaHeight / 2
    in
    { cx = model.width / 2
    , cy = top + areaHeight / 2
    , hw = radius
    , hh = radius
    , strength = 1.2
    }


{-| How much bigger than the exact fit the ball is, when the map is zoomed to [ratio] times the zoom of the exact fit
(LN-5). The screen starts with the ball fitting exactly. The first part of the zoom grows the ball with it, until the edges
cut off 30 % of its area; after that the ball stays and zooming only spreads the dots further apart (the nodes grow).
Zooming out below the fit leaves the ball as it is. -}
growth : Float -> Float
growth ratio =
    clamp 1 maxGrowth ratio


{-| The ball at which the two edges cut off 30 % of its area (15 % each side): a cap of angle t has the share
(t - sin t cos t) / pi of the area, which is 0.15 at t = 0.945, and the strip left is 2 R cos t wide, so R = side / (2 cos t). -}
maxGrowth : Float
maxGrowth =
    1 / cos 0.945


{-| After the layout or the window changed, the dots start where they were on screen and spring to their new places
(DY-4); on the first load they start gathered towards the middle and spring open. -}
reflow : Model -> Model -> Model
reflow old new =
    let
        oldLive =
            Motion.apply old.motion old.positions

        offset ( id, ( bx, by ) ) =
            case Dict.get id oldLive of
                Just w ->
                    let
                        ( x, y ) =
                            Lens.unproject new.zoom (Lens.project old.zoom w)
                    in
                    ( id, ( x - bx, y - by ) )

                Nothing ->
                    ( id, ( -0.55 * bx, -0.55 * by ) )
    in
    { new | motion = Motion.from (Dict.fromList (List.map offset (Dict.toList new.positions))), moving = True }


{-| Displacements the hovered dot's neighbours are drawn towards: a fifth of the way to it, by at most 14 pixels (DY-3). -}
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
    case source |> Maybe.andThen (\h -> Dict.get h model.positions |> Maybe.map (Tuple.pair h)) of
        Just ( h, ( hx, hy ) ) ->
            Dict.get h model.adj
                |> Maybe.withDefault []
                |> List.filterMap
                    (\n ->
                        Dict.get n model.positions
                            |> Maybe.map
                                (\( nx, ny ) ->
                                    let
                                        ( dx, dy ) =
                                            ( fraction * (hx - nx), fraction * (hy - ny) )

                                        -- at most about 14 pixels on screen: a hover nudges its neighbours, it does not fling them
                                        cap =
                                            capPx / (Zoom.asRecord model.zoom).scale

                                        len =
                                            sqrt (dx * dx + dy * dy)

                                        f =
                                            if len > cap then
                                                cap / len

                                            else
                                                1
                                    in
                                    ( n, ( dx * f, dy * f ) )
                                )
                    )
                |> Dict.fromList

        Nothing ->
            Dict.empty


{-| The dragged dot is held at the pointer once the pointer has moved. -}
pinOf : Model -> Maybe ( String, ( Float, Float ) )
pinOf model =
    case model.drag of
        Just d ->
            if d.moved then
                Dict.get d.id model.positions |> Maybe.map (\( bx, by ) -> ( d.id, ( Tuple.first d.target - bx, Tuple.second d.target - by ) ))

            else
                Nothing

        Nothing ->
            Nothing
