module Touch exposing (Gesture(..), Phase(..), step)

{-| The finger on the map (TC-1..TC-3): one finger pans, two fingers pinch, nothing else zooms.

The zoom library also zooms in on two quick taps, and it remembers which fingers are down, so a lift it misses turns the
next touch into a second finger and a pinch. Here every touch event restates all the fingers that are down, so the state
cannot get stuck, and there is no double-tap zoom. Positions are window pixels; the globe turns under the fingers
(`GlobeGrab.dragView`, `GlobeGrab.zoom`). -}

import Globe exposing (Screen, View)
import GlobeGrab


type Gesture
    = Idle
    | One ( Float, Float )
    | Two ( Float, Float ) ( Float, Float ) Float -- the two fingers on the screen, and how far apart they are


type Phase
    = Start
    | Move
    | End


fromFingers : List ( Float, Float ) -> Gesture
fromFingers fingers =
    case fingers of
        [] ->
            Idle

        [ a ] ->
            One a

        a :: b :: _ ->
            Two a b (distance a b)


{-| The fingers now down and what they do to the camera. Only a move changes it. -}
step : Screen -> Phase -> List ( Float, Float ) -> Gesture -> View -> ( Gesture, View )
step screen phase fingers gesture view =
    let
        now =
            fromFingers fingers
    in
    case phase of
        Move ->
            ( now, apply screen gesture now view )

        _ ->
            ( now, view )


apply : Screen -> Gesture -> Gesture -> View -> View
apply screen before after view =
    case ( before, after ) of
        ( One a, One b ) ->
            GlobeGrab.dragView (Globe.camera screen view) a b

        ( Two a1 a2 da, Two b1 b2 db ) ->
            -- the midpoint is held under the fingers (a drag of the globe), then zoomed about it by the change in distance
            let
                turned =
                    GlobeGrab.dragView (Globe.camera screen view) (midpoint a1 a2) (midpoint b1 b2)
            in
            GlobeGrab.zoom screen turned (db / max 1 da) (midpoint b1 b2)

        _ ->
            view


midpoint : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
midpoint ( x1, y1 ) ( x2, y2 ) =
    ( (x1 + x2) / 2, (y1 + y2) / 2 )


distance : ( Float, Float ) -> ( Float, Float ) -> Float
distance ( x1, y1 ) ( x2, y2 ) =
    sqrt ((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
