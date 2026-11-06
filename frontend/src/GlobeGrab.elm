module GlobeGrab exposing
    ( Aim
    , DragResult
    , HitResult
    , Mode(..)
    , aim
    , components
    , displace
    , drag
    , dragView
    , hitTest
    , hoverPull
    , logMap
    , tangentMove
    , tangentMoveLB
    , zoom
    )

{-| Taking hold of the globe (the second half of `Globe`, split off to keep each file small): what the pointer does to the camera
(turn it so that the point under the pointer stays under it, zoom about the pointer), the nearest dot to a pointer by the maths of
the sphere, the moves of a point along the sphere (for the springs and the hover pull), and a dot's displacement as two numbers. -}

import Globe exposing (Cam, Node, Screen, Vec, View, camera, nodeOf, eps, fadeBand, grabMinCos, grabMinDepth, halfPi, hitRay, hypot, limbPoint, pi2, project, rotate, targetPoint, unrotate, wrapPi, zMax)


type Mode
    = Exact
    | Limb
    | Clamped
    | Pan


type alias Aim =
    { lam : Float, beta : Float, mode : Mode }


type alias DragResult =
    { dlam : Float, dbeta : Float, mode : Mode }


type alias HitResult =
    { index : Maybe Int, n : Vec, insideDisc : Bool, angle : Maybe Float }


-- 5. AIM, DRAG, ZOOM


{-| Turn `(lam, beta)` so that the world point `n0` lands on the camera-frame unit vector `a` (section 4.4 of the spec). -}
aim : Vec -> Vec -> Float -> Float -> Aim
aim n0 a lam beta =
    let
        l0 =
            atan2 n0.x n0.z

        cb0 =
            sqrt (max 0 (1 - n0.y * n0.y))

        cb =
            if cb0 < 1.0e-9 then
                0

            else
                cb0

        sb =
            clamp -1 1 n0.y

        axc =
            clamp (negate cb) cb a.x

        xClamped =
            axc /= a.x

        ( ay, az ) =
            if xClamped then
                let
                    rr =
                        sqrt (max 0 (1 - axc * axc))

                    h =
                        hypot a.y a.z
                in
                if h > eps then
                    ( a.y * rr / h, a.z * rr / h )

                else
                    ( 0, rr )

            else
                ( a.y, a.z )

        ( lam2, vy, vz ) =
            if cb == 0 then
                ( lam
                , if sb > 0 then
                    1

                  else
                    -1
                , 0
                )

            else
                let
                    s =
                        clamp -1 1 (axc / cb)

                    delta =
                        if cos (l0 - lam) >= -1.0e-9 then
                            asin s

                        else
                            pi - asin s
                in
                ( wrapPi (l0 - delta), sb, cb * cos delta )

        betaRaw =
            if hypot vy vz < 1.0e-12 then
                beta

            else
                beta + wrapPi (atan2 az ay - atan2 vz vy - beta)

        beta2 =
            clamp -halfPi halfPi betaRaw

        atPole =
            abs (betaRaw - beta2) > 1.0e-12

        lam3 =
            if atPole && cb > 0 && hypot a.x a.y > 1.0e-9 then
                let
                    sg =
                        if beta2 > 0 then
                            1

                        else
                            -1
                in
                wrapPi (l0 - atan2 a.x (-sg * a.y))

            else
                lam2
    in
    { lam = lam3
    , beta = beta2
    , mode =
        if xClamped || atPole then
            Clamped

        else
            Exact
    }


{-| One pointer event of a drag: the point that was under `m0` is brought under `m1`, with the north held. -}
drag : Cam -> ( Float, Float ) -> ( Float, Float ) -> DragResult
drag c (( m0x, m0y ) as m0) (( m1x, m1y ) as m1) =
    let
        pan =
            let
                sc =
                    c.r * sqrt ((1 + c.q) / (1 - c.q))

                l2 =
                    wrapPi (c.lam - (m1x - m0x) / sc)

                b2 =
                    clamp -halfPi halfPi (c.beta + (m1y - m0y) / sc)
            in
            { dlam = wrapPi (l2 - c.lam), dbeta = b2 - c.beta, mode = Pan }
    in
    case hitRay c m0 of
        Nothing ->
            pan

        Just a0 ->
            let
                n0 =
                    unrotate c a0
            in
            if (a0.z - c.q) / (1 - c.q) < grabMinDepth || sqrt (max 0 (1 - n0.y * n0.y)) < grabMinCos then
                pan

            else
                let
                    ( a1, outside ) =
                        case hitRay c m1 of
                            Just a ->
                                ( a, False )

                            Nothing ->
                                ( limbPoint c m1, True )

                    r =
                        aim n0 a1 c.lam c.beta
                in
                { dlam = wrapPi (r.lam - c.lam)
                , dbeta = r.beta - c.beta
                , mode =
                    if outside && r.mode == Exact then
                        Limb

                    else
                        r.mode
                }


dragView : Cam -> ( Float, Float ) -> ( Float, Float ) -> View
dragView c m0 m1 =
    let
        d =
            drag c m0 m1
    in
    { lam = wrapPi (c.lam + d.dlam), beta = c.beta + d.dbeta, z = c.z }


{-| Zoom by the factor `f` about the pointer `m`: the sphere turns so that the point under the pointer stays. -}
zoom : Screen -> View -> Float -> ( Float, Float ) -> View
zoom s v f m =
    let
        z2 =
            clamp 1 zMax (v.z * f)

        c0 =
            camera s v
    in
    case hitRay c0 m of
        Nothing ->
            { v | z = z2 }

        Just a0 ->
            if z2 == v.z then
                { v | z = z2 }

            else
                let
                    c1 =
                        camera s { v | z = z2 }

                    r =
                        aim (unrotate c0 a0) (targetPoint c1 m) v.lam v.beta
                in
                { lam = r.lam, beta = r.beta, z = z2 }


-- 6. HIT TEST


hitTest : Cam -> List Vec -> ( Float, Float ) -> Float -> HitResult
hitTest c nodes ( mx, my ) tol =
    let
        ( a, inside ) =
            case hitRay c ( mx, my ) of
                Just v ->
                    ( v, True )

                Nothing ->
                    ( limbPoint c ( mx, my ), False )

        n =
            unrotate c a

        ( best, bd, _ ) =
            List.foldl
                (\ni ( bi, bdot, i ) ->
                    if c.m20 * ni.x + c.m21 * ni.y + c.m22 * ni.z > c.q then
                        let
                            d =
                                n.x * ni.x + n.y * ni.y + n.z * ni.z
                        in
                        if d > bdot then
                            ( Just i, d, i + 1 )

                        else
                            ( bi, bdot, i + 1 )

                    else
                        ( bi, bdot, i + 1 )
                )
                ( Nothing, -2, 0 )
                nodes

        index =
            case best of
                Just i ->
                    case List.drop i nodes |> List.head of
                        Just ni ->
                            let
                                p =
                                    project c ni
                            in
                            if hypot (p.x - mx) (p.y - my) > tol then
                                Nothing

                            else
                                Just i

                        Nothing ->
                            Nothing

                Nothing ->
                    Nothing
    in
    { index = index
    , n = n
    , insideDisc = inside
    , angle =
        if bd > -2 then
            Just (acos (clamp -1 1 bd))

        else
            Nothing
    }


-- 7. MOVES ON THE SPHERE


tangentMove : Vec -> Vec -> Vec
tangentMove n delta =
    let
        t =
            sqrt (delta.x * delta.x + delta.y * delta.y + delta.z * delta.z)
    in
    if t < 1.0e-15 then
        n

    else
        let
            ct =
                cos t

            st =
                sin t / t

            rx =
                n.x * ct + delta.x * st

            ry =
                n.y * ct + delta.y * st

            rz =
                n.z * ct + delta.z * st

            s =
                sqrt (rx * rx + ry * ry + rz * rz)
        in
        { x = rx / s, y = ry / s, z = rz / s }


tangentMoveLB : Float -> Float -> Float -> Float -> ( Float, Float )
tangentMoveLB l b de dn =
    let
        n =
            nodeOf l b

        n2 =
            tangentMove { x = n.x, y = n.y, z = n.z }
                { x = de * n.ex + dn * n.tx, y = dn * n.ty, z = de * n.ez + dn * n.tz }
    in
    if hypot n2.x n2.z < 1.0e-12 then
        ( l
        , if n2.y < 0 then
            -halfPi

          else
            halfPi
        )

    else
        ( atan2 n2.x n2.z, asin (clamp -1 1 n2.y) )


logMap : Vec -> Vec -> Vec
logMap n n2 =
    let
        d =
            clamp -1 1 (n.x * n2.x + n.y * n2.y + n.z * n2.z)

        tx =
            n2.x - d * n.x

        ty =
            n2.y - d * n.y

        tz =
            n2.z - d * n.z

        tn =
            sqrt (tx * tx + ty * ty + tz * tz)
    in
    if tn < 1.0e-12 then
        { x = 0, y = 0, z = 0 }

    else
        let
            f =
                acos d / tn
        in
        { x = tx * f, y = ty * f, z = tz * f }


{-| The displacement of dot `n` towards the hovered dot `nh`: a fraction of the way along the geodesic, at most `capPx` long
on the screen. -}
hoverPull : Cam -> Vec -> Vec -> Float -> Float -> Vec
hoverPull c n nh frac capPx =
    let
        d =
            logMap n nh

        len =
            sqrt (d.x * d.x + d.y * d.y + d.z * d.z)
    in
    if len < 1.0e-12 then
        { x = 0, y = 0, z = 0 }

    else
        let
            delta =
                { x = frac * d.x, y = frac * d.y, z = frac * d.z }

            a =
                rotate c n

            dc =
                rotate c delta

            g =
                1 - c.q * a.z

            f =
                c.k / g

            px =
                f * (dc.x + c.q * a.x * dc.z / g)

            py =
                f * (-dc.y - c.q * a.y * dc.z / g)

            pl =
                hypot px py
        in
        if pl > capPx then
            let
                s =
                    capPx / pl
            in
            { x = delta.x * s, y = delta.y * s, z = delta.z * s }

        else
            delta


-- 8. THE DISPLACEMENT OF A DOT AS TWO NUMBERS


{-| A tangent vector at `n` as its east and north parts (radians of arc): what the springs of `Motion` keep per dot. -}
components : Node -> Vec -> ( Float, Float )
components n d =
    ( d.x * n.ex + d.z * n.ez, d.x * n.tx + d.y * n.ty + d.z * n.tz )


{-| The dot moved `de` east and `dn` north (arcs, radians) along the exponential map. Needs one sqrt, one sin and one cos,
and only for dots that are displaced. -}
displace : Node -> Float -> Float -> Vec
displace n de dn =
    let
        dx =
            de * n.ex + dn * n.tx

        dy =
            dn * n.ty

        dz =
            de * n.ez + dn * n.tz

        t =
            sqrt (de * de + dn * dn)
    in
    if t < 1.0e-15 then
        { x = n.x, y = n.y, z = n.z }

    else
        let
            ct =
                cos t

            st =
                sin t / t
        in
        { x = n.x * ct + dx * st, y = n.y * ct + dy * st, z = n.z * ct + dz * st }
