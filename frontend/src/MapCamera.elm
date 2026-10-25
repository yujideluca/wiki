module MapCamera exposing (centreOn, fit, hoverPulls, lensFor, pinOf, reflow, resized)

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


{-| Fit the whole map into the visible area: the layout is reshaped to the area's shape (clear of the floating controls
at the top and the legend at the bottom), then zoomed and centred to fill it. -}
fit : Model -> Model
fit model =
    let
        ( top, bottom ) =
            MapSize.insets model.width

        areaHeight =
            max 100 (model.height - top - bottom)

        shaped =
            Layout.matchAspect (model.width / areaHeight) model.layout

        xs =
            Dict.values shaped |> List.map Tuple.first

        ys =
            Dict.values shaped |> List.map Tuple.second

        ( minX, maxX ) =
            ( List.minimum xs |> Maybe.withDefault -100, List.maximum xs |> Maybe.withDefault 100 )

        ( minY, maxY ) =
            ( List.minimum ys |> Maybe.withDefault -100, List.maximum ys |> Maybe.withDefault 100 )

        k =
            clamp 0.15 1.6 (min (model.width / (maxX - minX + 140)) (areaHeight / (maxY - minY + 90)))
    in
    { model
        | positions = shaped
        , zoom =
            Zoom.init { width = model.width, height = model.height }
                |> Zoom.scaleExtent 0.1 6
                |> Zoom.setTransform Zoom.instantly
                    { scale = k
                    , translate = { x = model.width / 2 - k * (minX + maxX) / 2, y = top + areaHeight / 2 - k * (minY + maxY) / 2 }
                    }
    }


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


{-| The lens of the map area (LN-1, LN-4). On a desktop an ellipse centred in what the floating controls leave free. On a
phone a rectangle, a little weaker; while a dot is selected the balloon covers the lower part of the screen, so the focus
moves up to the part that stays visible and the selected dot lands in the middle of it. -}
lensFor : Model -> Lens
lensFor model =
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
    in
    { shape =
        if phone then
            Lens.Rectangle

        else
            Lens.Ellipse
    , cx = model.width / 2
    , cy = top + areaHeight / 2
    , hw = model.width / 2
    , hh = areaHeight / 2
    , strength =
        if phone then
            0.8

        else
            1.2
    }


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
