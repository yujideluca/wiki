module Globe exposing
    ( Cam
    , Fit
    , Node
    , Screen
    , Shape
    , Spot
    , Vec
    , View
    , camera
    , camParams
    , embed
    , embedFit
    , eps
    , fadeBand
    , gMax
    , grabMinCos
    , grabMinDepth
    , halfPi
    , hiddenSpot
    , hitRay
    , hypot
    , limbPoint
    , nodeOf
    , nodeShape
    , pi2
    , place
    , project
    , rotate
    , sb_
    , targetPoint
    , unrotate
    , wrapPi
    , zMax
    )

{-| The globe with a held north (see `~/dev/wiki-bench/globe/spec/SPEC.md`), written for cost.

The state is `(lam, beta, Z)`: the camera turns about the vertical axis by `lam` and then tips by `beta`, so the north pole
is always straight up on the screen (roll is not a state). Every dot is a unit vector on the sphere, computed once per
layout. A frame costs one `camera` (four trig calls, one sqrt, the 3x3 matrix), and then for each dot the matrix product,
a compare against the horizon (a dot on the far side stops there), and for the dots that are seen a closed form for the
shape of the dot: no trig, no pow, no atan2 per dot. The dot is drawn as a circle under an SVG `matrix` (see `place`), so the
tilt angle is never computed either.

Units: radians, pixels, unit vectors; the screen has y down. Taking hold of the globe with the pointer (turning, zooming, the nearest
dot, moves along the sphere) is in `GlobeGrab`, split off to keep each file under the gate's line limit. -}


-- CONSTANTS


pi2 : Float
pi2 =
    2 * pi


halfPi : Float
halfPi =
    pi / 2


{-| `1 / cos 0.945`: the biggest the ball grows (see `MapCamera.growth` in the old lens). -}
gMax : Float
gMax =
    1 / cos 0.945


zMax : Float
zMax =
    12


sb_ : Float
sb_ =
    0.95


fadeBand : Float
fadeBand =
    0.15


grabMinDepth : Float
grabMinDepth =
    0.25


grabMinCos : Float
grabMinCos =
    0.1


eps : Float
eps =
    1.0e-12


-- TYPES


type alias Vec =
    { x : Float, y : Float, z : Float }


{-| A dot on the sphere, stored once per layout: its longitude and latitude, the unit vector, and the east and north
tangent vectors there (the east one is `(ex, 0, ez)`), so that a small displacement in arc is a few multiplications. -}
type alias Node =
    { l : Float
    , b : Float
    , x : Float
    , y : Float
    , z : Float
    , ex : Float
    , ez : Float
    , tx : Float
    , ty : Float
    , tz : Float
    }


{-| The ball's centre and the radius of the ball that fits the free area exactly. -}
type alias Screen =
    { cx : Float, cy : Float, rho : Float }


type alias View =
    { lam : Float, beta : Float, z : Float }


{-| Everything that is the same for all dots in a frame: the camera matrix and the projection constants. -}
type alias Cam =
    { lam : Float
    , beta : Float
    , z : Float
    , cx : Float
    , cy : Float
    , rho : Float
    , r : Float -- radius of the ball on the screen
    , q : Float -- 1 / D
    , k : Float -- r sqrt(1 - q^2)
    , cl : Float
    , sl : Float
    , cb : Float
    , sb : Float
    , m00 : Float
    , m02 : Float
    , m10 : Float
    , m11 : Float
    , m12 : Float
    , m20 : Float
    , m21 : Float
    , m22 : Float
    , fade : Float -- 1 / ((1 - q) FADE)
    }


{-| Where one dot is on the screen, how it is flattened, and how clearly it is seen. The ellipse of a dot of radius `r` is the
circle of radius `r` under the matrix `[[la, lb], [lb, ld]]` (the symmetric square root of the shape matrix, already divided
by the reference radius). `scale` is the area scale (1 in the middle at Z = 1). -}
type alias Spot =
    { visible : Bool
    , x : Float
    , y : Float
    , z : Float
    , la : Float
    , lb : Float
    , ld : Float
    , scale : Float
    , opacity : Float
    }


type alias Fit =
    { mx : Float, my : Float, hx : Float, hy : Float }


type alias Shape =
    { z : Float
    , visible : Bool
    , opacity : Float
    , long : Float
    , short : Float
    , scale : Float
    , squash : Float
    , tilt : Float
    }


-- SMALL HELPERS


wrapPi : Float -> Float
wrapPi a =
    let
        t =
            a + pi
    in
    t - pi2 * toFloat (floor (t / pi2)) - pi


hypot : Float -> Float -> Float
hypot a b =
    sqrt (a * a + b * b)


-- 1. EMBEDDING


embedFit : List ( Float, Float ) -> Fit
embedFit points =
    case points of
        [] ->
            { mx = 0, my = 0, hx = 1, hy = 1 }

        ( x0, y0 ) :: rest ->
            let
                bb =
                    List.foldl
                        (\( x, y ) acc -> { x1 = min acc.x1 x, x2 = max acc.x2 x, y1 = min acc.y1 y, y2 = max acc.y2 y })
                        { x1 = x0, x2 = x0, y1 = y0, y2 = y0 }
                        rest
            in
            { mx = (bb.x1 + bb.x2) / 2, my = (bb.y1 + bb.y2) / 2, hx = max 1 ((bb.x2 - bb.x1) / 2), hy = max 1 ((bb.y2 - bb.y1) / 2) }



{-| A layout point (y down) on the sphere, cylindrical equal-area: east is the layout's right, north is its up. -}
embed : ( Float, Float ) -> Fit -> Node
embed ( x, y ) fit =
    let
        u =
            clamp -1 1 ((x - fit.mx) / fit.hx)

        v =
            clamp -1 1 (-(y - fit.my) / fit.hy)
    in
    nodeOf (pi * u) (asin (sb_ * v))


nodeOf : Float -> Float -> Node
nodeOf l b =
    let
        cl =
            cos l

        sl =
            sin l

        cb =
            cos b

        sb =
            sin b
    in
    { l = l
    , b = b
    , x = cb * sl
    , y = sb
    , z = cb * cl
    , ex = cl
    , ez = -sl
    , tx = -sb * sl
    , ty = cb
    , tz = -sb * cl
    }


-- 2. CAMERA


{-| The ball's radius and `q = 1/D` for the zoom state `z`. -}
camParams : Float -> Float -> ( Float, Float )
camParams z rho =
    let
        g =
            clamp 1 gMax z

        m =
            z / g

        m2 =
            m * m
    in
    ( g * rho, (m2 - 1) / (m2 + 1) )


{-| The frame's constants: called once per frame, never per dot. -}
camera : Screen -> View -> Cam
camera s v =
    let
        ( r, q ) =
            camParams v.z s.rho

        cl =
            cos v.lam

        sl =
            sin v.lam

        cb =
            cos v.beta

        sb =
            sin v.beta
    in
    { lam = v.lam
    , beta = v.beta
    , z = v.z
    , cx = s.cx
    , cy = s.cy
    , rho = s.rho
    , r = r
    , q = q
    , k = r * sqrt (1 - q * q)
    , cl = cl
    , sl = sl
    , cb = cb
    , sb = sb
    , m00 = cl
    , m02 = -sl
    , m10 = -sb * sl
    , m11 = cb
    , m12 = -sb * cl
    , m20 = cb * sl
    , m21 = sb
    , m22 = cb * cl
    , fade = 1 / ((1 - q) * fadeBand)
    }


rotate : Cam -> Vec -> Vec
rotate c n =
    { x = c.m00 * n.x + c.m02 * n.z
    , y = c.m10 * n.x + c.m11 * n.y + c.m12 * n.z
    , z = c.m20 * n.x + c.m21 * n.y + c.m22 * n.z
    }


unrotate : Cam -> Vec -> Vec
unrotate c a =
    let
        y =
            c.cb * a.y + c.sb * a.z

        z =
            -c.sb * a.y + c.cb * a.z
    in
    { x = c.cl * a.x + c.sl * z, y = y, z = -c.sl * a.x + c.cl * z }


{-| Screen position, depth z' and whether it is on the near side of the horizon. -}
project : Cam -> Vec -> { x : Float, y : Float, z : Float, visible : Bool }
project c n =
    let
        a =
            rotate c n

        g =
            1 - c.q * a.z
    in
    { x = c.cx + c.k * a.x / g, y = c.cy - c.k * a.y / g, z = a.z, visible = a.z > c.q }


hitRay : Cam -> ( Float, Float ) -> Maybe Vec
hitRay c ( mx, my ) =
    let
        q =
            c.q

        ex =
            (mx - c.cx) / c.k

        ey =
            -(my - c.cy) / c.k

        bigE =
            ex * ex + ey * ey

        disc =
            1 - bigE * (1 - q * q)
    in
    if disc < 0 then
        Nothing

    else
        let
            z =
                (bigE * q + sqrt disc) / (1 + bigE * q * q)

            g =
                1 - q * z
        in
        Just { x = ex * g, y = ey * g, z = z }


limbPoint : Cam -> ( Float, Float ) -> Vec
limbPoint c ( mx, my ) =
    let
        xx =
            mx - c.cx

        yy =
            -(my - c.cy)

        r =
            hypot xx yy

        s =
            sqrt (1 - c.q * c.q)
    in
    if r < eps then
        { x = 0, y = s, z = c.q }

    else
        { x = xx / r * s, y = yy / r * s, z = c.q }


targetPoint : Cam -> ( Float, Float ) -> Vec
targetPoint c m =
    case hitRay c m of
        Just a ->
            a

        Nothing ->
            limbPoint c m


-- 3. THE SHAPE OF A DOT, FAST PATH (the one the frame uses)


hiddenSpot : Spot
hiddenSpot =
    { visible = False, x = 0, y = 0, z = 0, la = 0, lb = 0, ld = 0, scale = 0, opacity = 0 }


{-| A dot with the unit vector `(nx, ny, nz)` seen by the camera. A dot beyond the horizon (z' <= q) returns at once with the
shared `hiddenSpot`, before any shape is computed.

With `a = k / g` and `g = 1 - q z'`, the shape matrix `M = J (I - a a^T) J^T` of the spec reduces to
`M00 = a^2 - x'^2 e`, `M11 = a^2 - y'^2 e`, `M01 = x' y' e`, with `e = w^2 - b^2`, `w = a + b z'`, `b = q a / g`, and its
determinant to `a^2 (a^2 - e (x'^2 + y'^2))`. A round dot becomes the ellipse that the symmetric square root `L` of `M`
makes of a circle: `L = (M + sd I) / sqrt(tr + 2 sd)` with `sd = sqrt(det M)` (`= long * short`), because `L L = M`. So three
square roots and no trig give the whole ellipse, and the browser rotates it: it is handed as `matrix(la lb lb ld 0 0)`. -}
place : Cam -> Float -> Float -> Float -> Spot
place c nx ny nz =
    let
        zz =
            c.m20 * nx + c.m21 * ny + c.m22 * nz
    in
    if zz <= c.q then
        hiddenSpot

    else
        let
            xx =
                c.m00 * nx + c.m02 * nz

            yy =
                c.m10 * nx + c.m11 * ny + c.m12 * nz

            q =
                c.q

            ig =
                1 / (1 - q * zz)

            a =
                c.k * ig

            b =
                q * a * ig

            w =
                a + b * zz

            e =
                (w - b) * (w + b)

            a2 =
                a * a

            rr =
                xx * xx + yy * yy

            m00 =
                a2 - xx * xx * e

            m11 =
                a2 - yy * yy * e

            m01 =
                xx * yy * e

            sd =
                a * sqrt (max 0 (a2 - e * rr))

            den =
                sqrt (m00 + m11 + 2 * sd)

            inv =
                if den > 1.0e-12 then
                    1 / (den * c.rho)

                else
                    0
        in
        { visible = True
        , x = c.cx + a * xx
        , y = c.cy - a * yy
        , z = zz
        , la = (m00 + sd) * inv
        , lb = m01 * inv
        , ld = (m11 + sd) * inv
        , scale = sqrt sd / c.rho
        , opacity = clamp 0 1 ((zz - c.q) * c.fade)
        }


-- 4. THE SHAPE OF A DOT, REFERENCE FORM (as in the spec: eigenvalues, squash and tilt in degrees)


nodeShape : Cam -> Vec -> Float -> Shape
nodeShape c n rhoRef =
    let
        a =
            rotate c n

        k =
            c.k

        g =
            1 - c.q * a.z

        j00 =
            k / g

        j02 =
            k * c.q * a.x / (g * g)

        j11 =
            -k / g

        j12 =
            -k * c.q * a.y / (g * g)

        -- M = J (I - a a^T) J^T, J = [[j00, 0, j02], [0, j11, j12]]
        p r s =
            (if r == s then
                1

             else
                0
            )
                - a2 r * a2 s

        a2 i =
            if i == 0 then
                a.x

            else if i == 1 then
                a.y

            else
                a.z

        jr row i =
            case ( row, i ) of
                ( 0, 0 ) ->
                    j00

                ( 0, 2 ) ->
                    j02

                ( 1, 1 ) ->
                    j11

                ( 1, 2 ) ->
                    j12

                _ ->
                    0

        mm i j =
            List.sum
                (List.concatMap (\s -> List.map (\r -> jr i s * p s r * jr j r) [ 0, 1, 2 ]) [ 0, 1, 2 ])

        m00 =
            mm 0 0

        m01 =
            mm 0 1

        m11 =
            mm 1 1

        tr =
            m00 + m11

        det =
            m00 * m11 - m01 * m01

        half =
            tr / 2

        d =
            sqrt (max 0 (half * half - det))

        long =
            sqrt (half + d)

        short =
            sqrt (max 0 (half - d))

        tilt =
            if abs (m00 - m11) < 1.0e-12 * max 1 tr && abs m01 < 1.0e-12 * max 1 tr then
                0

            else
                0.5 * atan2 (2 * m01) (m00 - m11) * 180 / pi

        depth =
            (a.z - c.q) / (1 - c.q)
    in
    { z = a.z
    , visible = a.z > c.q
    , opacity = clamp 0 1 (depth / fadeBand)
    , long = long
    , short = short
    , scale = sqrt (long * short) / rhoRef
    , squash =
        if long > 1.0e-9 then
            short / long

        else
            1
    , tilt = tilt
    }
