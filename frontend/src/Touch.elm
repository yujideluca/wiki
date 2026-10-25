module Touch exposing (Gesture(..), Phase(..), step)

{-| The finger on the map (TC-1..TC-3): one finger pans, two fingers pinch, nothing else zooms.

The zoom library also zooms in on two quick taps, and it remembers which fingers are down, so a lift it misses turns the
next touch into a second finger and a pinch. Here every touch event restates all the fingers that are down, so the state
cannot get stuck, and there is no double-tap zoom. Positions are in the zoom's own coordinates (before the lens). -}

import Zoom exposing (Zoom)


type Gesture
    = Idle
    | One ( Float, Float )
    | Two ( Float, Float ) ( Float, Float ) Float -- the two fingers in map coordinates, and how far apart they are on screen


type Phase
    = Start
    | Move
    | End


fromFingers : (( Float, Float ) -> ( Float, Float )) -> List ( Float, Float ) -> Gesture
fromFingers toMap fingers =
    case fingers of
        [] ->
            Idle

        [ a ] ->
            One (toMap a)

        a :: b :: _ ->
            Two (toMap a) (toMap b) (distance a b)


{-| The fingers now down (already mapped back through the lens) and what they do to the zoom. Only a move changes it. -}
step : (( Float, Float ) -> ( Float, Float )) -> Phase -> List ( Float, Float ) -> Gesture -> Zoom -> ( Gesture, Zoom )
step toMap phase fingers gesture zoom =
    let
        now =
            fromFingers toMap fingers
    in
    case phase of
        Move ->
            ( now, apply gesture now zoom )

        _ ->
            ( now, zoom )


apply : Gesture -> Gesture -> Zoom -> Zoom
apply before after zoom =
    case ( before, after ) of
        ( One ( ax, ay ), One ( bx, by ) ) ->
            move 1 ( ax, ay ) ( bx, by ) zoom

        ( Two a1 a2 da, Two b1 b2 db ) ->
            -- the pivot is where the fingers' midpoint is on the map; the zoom follows the distance the eye sees
            move (db / max 1 da) (midpoint a1 a2) (midpoint b1 b2) zoom

        _ ->
            zoom


{-| The point of the map that was under [from] ends under [to], magnified by [factor]. -}
move : Float -> ( Float, Float ) -> ( Float, Float ) -> Zoom -> Zoom
move factor ( fx, fy ) ( tx, ty ) zoom =
    let
        t =
            Zoom.asRecord zoom

        k =
            clamp 0.1 6 (t.scale * factor)

        ( wx, wy ) =
            ( (fx - t.translate.x) / t.scale, (fy - t.translate.y) / t.scale )
    in
    Zoom.setTransform Zoom.instantly { scale = k, translate = { x = tx - k * wx, y = ty - k * wy } } zoom


midpoint : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
midpoint ( x1, y1 ) ( x2, y2 ) =
    ( (x1 + x2) / 2, (y1 + y2) / 2 )


distance : ( Float, Float ) -> ( Float, Float ) -> Float
distance ( x1, y1 ) ( x2, y2 ) =
    sqrt ((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
