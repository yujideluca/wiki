module Lens exposing (Lens, Shape(..), Spot, apply, invert, project, unproject)

{-| The map's lens (LN-1..LN-3): a fisheye over the visible area. The middle of the window is magnified, so dots there
are bigger and further apart, and the border is squeezed, so dots there are smaller. Points on the ellipse that
touches the four sides stay where they are; everything inside moves outwards, everything outside moves inwards, so
nothing leaves the window because of the lens.

With distance `r` from the centre (1 at the ellipse) and strength `d`, a point moves to `r * (d + 1) / (d * r + 1)`
(the fisheye of Sarkar and Brown). `strength = 0` is the identity, used on phones. -}

import Zoom exposing (Zoom)


{-| The focus: an `Ellipse` (the desktop) or a `Rectangle` (the phone, LN-4). The rectangle bends each axis on its own,
so the middle band is magnified, every side of the area stays where it is, and the corners of a tall screen are used. -}
type Shape
    = Ellipse
    | Rectangle


type alias Lens =
    { shape : Shape
    , cx : Float
    , cy : Float
    , hw : Float -- half the width of the area
    , hh : Float -- half the height of the area
    , strength : Float
    }


{-| Where a point lands, how much it is magnified there (about 1 on the ellipse, more inside, less outside) and its
distance from the centre after the lens, with 1 at the ellipse. -}
type alias Spot =
    { x : Float
    , y : Float
    , scale : Float
    , r : Float
    }


apply : Lens -> ( Float, Float ) -> Spot
apply lens ( x, y ) =
    case lens.shape of
        Ellipse ->
            applyEllipse lens ( x, y )

        Rectangle ->
            applyRectangle lens ( x, y )


{-| One axis of the rectangular lens: [t] is the offset in half-extents (1 at the side). -}
bend : Float -> Float -> ( Float, Float )
bend d t =
    let
        a =
            abs t

        moved =
            (d + 1) * a / (d * a + 1)

        slope =
            (d + 1) / ((d * a + 1) * (d * a + 1))
    in
    ( if t < 0 then
        -moved

      else
        moved
    , slope
    )


unbend : Float -> Float -> Float
unbend d t =
    let
        a =
            abs t

        back =
            a / max 0.02 (d + 1 - d * a)
    in
    if t < 0 then
        -back

    else
        back


applyRectangle : Lens -> ( Float, Float ) -> Spot
applyRectangle lens ( x, y ) =
    let
        ( fx, gx ) =
            bend lens.strength ((x - lens.cx) / lens.hw)

        ( fy, gy ) =
            bend lens.strength ((y - lens.cy) / lens.hh)
    in
    { x = lens.cx + fx * lens.hw
    , y = lens.cy + fy * lens.hh
    , scale = sqrt (gx * gy)
    , r = max (abs fx) (abs fy)
    }


applyEllipse : Lens -> ( Float, Float ) -> Spot
applyEllipse lens ( x, y ) =
    let
        u =
            (x - lens.cx) / lens.hw

        v =
            (y - lens.cy) / lens.hh

        r =
            sqrt (u * u + v * v)

        d =
            lens.strength

        s =
            (d + 1) / (d * r + 1)

        radial =
            s / (d * r + 1)
    in
    { x = lens.cx + u * s * lens.hw
    , y = lens.cy + v * s * lens.hh
    , scale = sqrt (s * radial)
    , r = r * s
    }


{-| The point that the lens puts at [(x, y)]: used to turn a pointer position back into the map. -}
invert : Lens -> ( Float, Float ) -> ( Float, Float )
invert lens ( x, y ) =
    case lens.shape of
        Rectangle ->
            ( lens.cx + unbend lens.strength ((x - lens.cx) / lens.hw) * lens.hw
            , lens.cy + unbend lens.strength ((y - lens.cy) / lens.hh) * lens.hh
            )

        Ellipse ->
            invertEllipse lens ( x, y )


invertEllipse : Lens -> ( Float, Float ) -> ( Float, Float )
invertEllipse lens ( x, y ) =
    let
        u =
            (x - lens.cx) / lens.hw

        v =
            (y - lens.cy) / lens.hh

        r2 =
            sqrt (u * u + v * v)

        d =
            lens.strength

        -- r = r' / (d + 1 - d r'); the lens never reaches r' = (d + 1) / d, so stay clear of it
        r =
            r2 / max 0.02 (d + 1 - d * r2)

        k =
            if r2 == 0 then
                1

            else
                r / r2
    in
    ( lens.cx + u * k * lens.hw, lens.cy + v * k * lens.hh )


{-| Map coordinates to window coordinates, and back. -}
project : Zoom -> ( Float, Float ) -> ( Float, Float )
project zoom ( x, y ) =
    let
        t =
            Zoom.asRecord zoom
    in
    ( t.scale * x + t.translate.x, t.scale * y + t.translate.y )


unproject : Zoom -> ( Float, Float ) -> ( Float, Float )
unproject zoom ( x, y ) =
    let
        t =
            Zoom.asRecord zoom
    in
    ( (x - t.translate.x) / t.scale, (y - t.translate.y) / t.scale )
