module Lens exposing (Lens, Spot, apply, invert, project, unproject)

{-| The map's lens (LN-1..LN-3): the visible area seen as a ball. The cloud of dots is wrapped onto a sphere and looked at
from the front: the middle faces us, so dots there are bigger and further apart, and towards the rim the surface turns
away, so dots there are smaller, closer and flattened into ovals along the direction of the turn, as the land on a globe
is. The ball is a circle (an ellipse only when the area has been given two different half-extents) and the dots are laid
out to fill it (`MapCamera.fit`), so the rim is evenly populated; a dot beyond the rim is on the far side and is not drawn.

With distance `r` from the centre (1 at the rim) a point is put on the sphere at the angle `r * strength` from the front
and lands at `sin (r * strength) / sin strength`. Points on the rim stay where they are, everything inside moves outwards,
everything outside moves inwards. `strength = 0` is the identity. -}

import Zoom exposing (Zoom)


type alias Lens =
    { cx : Float
    , cy : Float
    , hw : Float -- half the width of the area
    , hh : Float -- half the height of the area
    , strength : Float -- the angle of the sphere's turn at the border, in radians
    }


{-| Where a point lands, how much it is magnified there (about 1 at the rim, more inside, less outside), its
distance from the centre after the lens (1 at the rim), and how a round dot looks there: `squash` is the short axis
over the long one (1 facing us, less where the surface turns away) and `tilt` the direction of the long axis in
degrees. -}
type alias Spot =
    { x : Float
    , y : Float
    , scale : Float
    , r : Float
    , squash : Float
    , tilt : Float
    }


apply : Lens -> ( Float, Float ) -> Spot
apply lens ( x, y ) =
    if lens.strength < 0.001 then
        { x = x
        , y = y
        , scale = 1
        , r = max (abs (x - lens.cx) / lens.hw) (abs (y - lens.cy) / lens.hh)
        , squash = 1
        , tilt = 0
        }

    else
        applyGlobe lens ( x, y )


-- The sphere is followed to this angle (80 degrees); further out the surface continues as a straight slope,
-- so that a point far outside the window still lands further out and never folds back over the sphere.
reach : Float
reach =
    1.4


{-| The height of a point at angle [w] on the sphere seen from the front, and its slope. -}
surface : Float -> Float
surface w =
    if abs w <= reach then
        sin w

    else
        sign w * (sin reach + cos reach * (abs w - reach))


surfaceSlope : Float -> Float
surfaceSlope w =
    cos (min (abs w) reach)


{-| The angle whose height is [y]. -}
unsurface : Float -> Float
unsurface y =
    if abs y <= sin reach then
        asin y

    else
        sign y * (reach + (abs y - sin reach) / cos reach)


sign : Float -> Float
sign v =
    if v < 0 then
        -1

    else
        1


{-| The sphere seen from the front, as a function of the offset [t] in half-extents: where it lands, and the slope. -}
bend : Float -> Float -> ( Float, Float )
bend phi t =
    ( surface (t * phi) / sin phi, phi * surfaceSlope (t * phi) / sin phi )


unbend : Float -> Float -> Float
unbend phi t =
    unsurface (t * sin phi) / phi


applyGlobe : Lens -> ( Float, Float ) -> Spot
applyGlobe lens ( x, y ) =
    let
        u =
            (x - lens.cx) / lens.hw

        v =
            (y - lens.cy) / lens.hh

        r =
            sqrt (u * u + v * v)

        phi =
            lens.strength

        -- where r lands, and the slope of that along the radius
        ( landed, slope ) =
            bend phi r

        -- s: how much the radius is multiplied; k: how fast s changes with the radius, over r
        ( s, k ) =
            if r < 0.0001 then
                ( slope, 0 )

            else
                ( landed / r, (slope - landed / r) / (r * r) )

        -- the Jacobian in pixels (how a small step on the map becomes a step on the screen)
        ja =
            s + u * u * k

        jb =
            u * v * k * lens.hw / lens.hh

        jc =
            u * v * k * lens.hh / lens.hw

        jd =
            s + v * v * k

        ( squash, tilt ) =
            ellipseOf ja jb jc jd
    in
    { x = lens.cx + u * s * lens.hw
    , y = lens.cy + v * s * lens.hh
    , scale = sqrt (abs (ja * jd - jb * jc))
    , r = r * s
    , squash = squash
    , tilt = tilt
    }


{-| What a small circle becomes under the matrix [[a, b], [c, d]]: an ellipse, given as short axis over long axis and the
direction of the long axis in degrees. -}
ellipseOf : Float -> Float -> Float -> Float -> ( Float, Float )
ellipseOf a b c d =
    let
        e =
            (a + d) / 2

        f =
            (a - d) / 2

        g =
            (c + b) / 2

        h =
            (c - b) / 2

        q =
            sqrt (e * e + h * h)

        rr =
            sqrt (f * f + g * g)

        long =
            q + rr

        short =
            abs (q - rr)
    in
    ( if long < 0.0001 then
        1

      else
        short / long
    , (atan2 h e + atan2 g f) / 2 * 180 / pi
    )


{-| The point that the lens puts at [(x, y)]: used to turn a pointer position back into the map. -}
invert : Lens -> ( Float, Float ) -> ( Float, Float )
invert lens ( x, y ) =
    if lens.strength < 0.001 then
        ( x, y )

    else
        invertGlobe lens ( x, y )


invertGlobe : Lens -> ( Float, Float ) -> ( Float, Float )
invertGlobe lens ( x, y ) =
    let
        u =
            (x - lens.cx) / lens.hw

        v =
            (y - lens.cy) / lens.hh

        landed =
            sqrt (u * u + v * v)

        r =
            unbend lens.strength landed

        k =
            if landed == 0 then
                1

            else
                r / landed
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
