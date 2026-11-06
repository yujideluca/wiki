module GlobeTests exposing (suite)

{-| The pure functions of `Globe` against the spec's `vectors.json` (generated into `GlobeVectors`), to 1e-9. -}

import Expect exposing (Expectation)
import Globe exposing (Mode(..))
import GlobeVectors
import Json.Decode as D exposing (Decoder)
import Test exposing (Test, describe, test)


tol : Float
tol =
    1.0e-9


close : String -> Float -> Float -> List String
close name want got =
    if abs (want - got) <= tol then
        []

    else
        [ name ++ ": want " ++ String.fromFloat want ++ " got " ++ String.fromFloat got ]


closeAngle : String -> Float -> Float -> List String
closeAngle name want got =
    close name 0 (Globe.wrapPi (want - got))


vec : Decoder Globe.Vec
vec =
    D.list D.float
        |> D.andThen
            (\l ->
                case l of
                    [ x, y, z ] ->
                        D.succeed { x = x, y = y, z = z }

                    _ ->
                        D.fail "vec"
            )


pair : Decoder ( Float, Float )
pair =
    D.list D.float
        |> D.andThen
            (\l ->
                case l of
                    [ x, y ] ->
                        D.succeed ( x, y )

                    _ ->
                        D.fail "pair"
            )


section : String -> Decoder a -> (Int -> a -> List String) -> Test
section key decoder check =
    case D.decodeString (D.field key (D.list decoder)) GlobeVectors.json of
        Err e ->
            test key (\_ -> Expect.fail (D.errorToString e))

        Ok items ->
            describe key
                (List.indexedMap
                    (\i it ->
                        test (key ++ " #" ++ String.fromInt i) (\_ -> Expect.equal [] (check i it))
                    )
                    items
                )


screenOf : ( Float, Float ) -> Float -> Globe.Screen
screenOf ( cx, cy ) rho =
    { cx = cx, cy = cy, rho = rho }


inDecoder : Decoder { lam : Float, beta : Float, z : Float, c : ( Float, Float ), rho : Float }
inDecoder =
    D.map5 (\a b c d e -> { lam = a, beta = b, z = c, c = d, rho = e })
        (D.at [ "in", "lam" ] D.float)
        (D.at [ "in", "beta" ] D.float)
        (D.at [ "in", "Z" ] D.float)
        (D.oneOf [ D.at [ "in", "c" ] pair, D.succeed ( 500, 400 ) ])
        (D.at [ "in", "rho_fit" ] D.float)


suite : Test
suite =
    describe "Globe against vectors.json"
        [ section "embed_fit"
            (D.map2 Tuple.pair
                (D.at [ "in", "points" ] (D.list pair))
                (D.at [ "out" ] (D.map4 (\a b c d -> [ a, b, c, d ]) (D.field "mx" D.float) (D.field "my" D.float) (D.field "hx" D.float) (D.field "hy" D.float)))
            )
            (\_ ( pts, want ) ->
                let
                    f =
                        Globe.embedFit pts
                in
                List.concat (List.map3 close [ "mx", "my", "hx", "hy" ] want [ f.mx, f.my, f.hx, f.hy ])
            )
        , section "embed"
            (D.map3 (\w f o -> ( w, f, o ))
                (D.at [ "in", "w" ] pair)
                (D.at [ "in", "fit" ] (D.map4 (\a b c d -> { mx = a, my = b, hx = c, hy = d }) (D.field "mx" D.float) (D.field "my" D.float) (D.field "hx" D.float) (D.field "hy" D.float)))
                (D.at [ "out" ] (D.map3 (\l b n -> ( l, b, n )) (D.field "l" D.float) (D.field "b" D.float) (D.field "n" vec)))
            )
            (\_ ( w, fit, ( l, b, n ) ) ->
                let
                    g =
                        Globe.embed w fit
                in
                close "l" l g.l ++ close "b" b g.b ++ close "nx" n.x g.x ++ close "ny" n.y g.y ++ close "nz" n.z g.z
            )
        , section "drag"
            (D.map4 (\i m0 m1 o -> ( i, m0, ( m1, o ) ))
                inDecoder
                (D.at [ "in", "m0" ] pair)
                (D.at [ "in", "m1" ] pair)
                (D.at [ "out" ] (D.map3 (\a b c -> ( a, b, c )) (D.field "dlam" D.float) (D.field "dbeta" D.float) (D.field "mode" D.string)))
            )
            (\_ ( i, m0, ( m1, ( dl, db, mode ) ) ) ->
                let
                    cam =
                        Globe.camera (screenOf i.c i.rho) { lam = i.lam, beta = i.beta, z = i.z }

                    r =
                        Globe.drag cam m0 m1

                    modeName =
                        case r.mode of
                            Exact ->
                                "exact"

                            Limb ->
                                "limb"

                            Clamped ->
                                "clamped"

                            Pan ->
                                "pan"
                in
                closeAngle "dlam" dl r.dlam
                    ++ close "dbeta" db r.dbeta
                    ++ (if modeName == mode then
                            []

                        else
                            [ "mode " ++ modeName ++ " /= " ++ mode ]
                       )
            )
        , section "zoom"
            (D.map4 (\i f m o -> ( i, f, ( m, o ) ))
                inDecoder
                (D.at [ "in", "f" ] D.float)
                (D.at [ "in", "m" ] pair)
                (D.at [ "out" ] (D.map3 (\a b c -> ( a, b, c )) (D.field "lam" D.float) (D.field "beta" D.float) (D.field "Z" D.float)))
            )
            (\_ ( i, f, ( m, ( l, b, z ) ) ) ->
                let
                    r =
                        Globe.zoom (screenOf i.c i.rho) { lam = i.lam, beta = i.beta, z = i.z } f m
                in
                closeAngle "lam" l r.lam ++ close "beta" b r.beta ++ close "Z" z r.z
            )
        , section "nodeShape"
            (D.map3 (\i n o -> ( i, n, o ))
                (D.map2 Tuple.pair inDecoder (D.at [ "in", "rho_ref" ] D.float))
                (D.at [ "in", "n" ] vec)
                (D.field "out"
                    (D.map8 (\z v o lg sh sc sq ti -> { z = z, v = v, o = o, lg = lg, sh = sh, sc = sc, sq = sq, ti = ti })
                        (D.field "z" D.float)
                        (D.field "visible" D.bool)
                        (D.field "opacity" D.float)
                        (D.field "long_px_per_rad" D.float)
                        (D.field "short_px_per_rad" D.float)
                        (D.field "scale" D.float)
                        (D.field "squash" D.float)
                        (D.field "tilt_deg" D.float)
                    )
                )
            )
            (\_ ( ( i, rhoRef ), n, o ) ->
                let
                    cam =
                        Globe.camera (screenOf i.c i.rho) { lam = i.lam, beta = i.beta, z = i.z }

                    s =
                        Globe.nodeShape cam n rhoRef

                    -- the fast path: place gives L (divided by rho); long and short are the eigenvalues of L * rho
                    sp =
                        Globe.place cam n.x n.y n.z

                    la =
                        sp.la * cam.rho

                    lb =
                        sp.lb * cam.rho

                    ld =
                        sp.ld * cam.rho

                    trL =
                        la + ld

                    detL =
                        la * ld - lb * lb

                    dd =
                        sqrt (max 0 (trL * trL / 4 - detL))

                    fastLong =
                        trL / 2 + dd

                    fastShort =
                        trL / 2 - dd

                    fastTilt =
                        0.5 * atan2 (2 * lb) (la - ld) * 180 / pi

                    tiltOk =
                        if o.sq > 0.999 then
                            []

                        else
                            close "fast tilt" 0 (let d = fastTilt - o.ti + 90 in d - 180 * toFloat (floor (d / 180)) - 90)
                in
                (if o.v then
                    close "z" o.z s.z
                        ++ close "opacity" o.o s.opacity
                        ++ close "long" o.lg s.long
                        ++ close "short" o.sh s.short
                        ++ close "scale" o.sc s.scale
                        ++ close "squash" o.sq s.squash
                        ++ close "tilt" o.ti s.tilt
                        ++ (if sp.visible then
                                close "fast long" o.lg fastLong
                                    ++ close "fast short" o.sh fastShort
                                    ++ close "fast scale" o.sc (sp.scale * cam.rho / rhoRef)
                                    ++ close "fast opacity" o.o sp.opacity
                                    ++ tiltOk

                            else
                                [ "fast path hid a visible dot" ]
                           )

                 else if sp.visible then
                    [ "fast path shows a hidden dot" ]

                 else
                    close "z" o.z s.z
                )
            )
        , section "hitTest"
            (D.map4 (\i m tolPx o -> ( i, m, ( tolPx, o ) ))
                inDecoder
                (D.at [ "in", "m" ] pair)
                (D.at [ "in", "tol_px" ] D.float)
                (D.field "out"
                    (D.map3 (\ix n a -> ( ix, n, a ))
                        (D.field "index" (D.nullable D.int))
                        (D.field "n" vec)
                        (D.field "inside_disc" D.bool)
                    )
                )
            )
            (\_ ( i, m, ( tolPx, ( ix, n, inside ) ) ) ->
                case D.decodeString (D.field "hitTest_nodes" (D.list vec)) GlobeVectors.json of
                    Err _ ->
                        [ "no nodes" ]

                    Ok nodes ->
                        let
                            cam =
                                Globe.camera (screenOf i.c i.rho) { lam = i.lam, beta = i.beta, z = i.z }

                            r =
                                Globe.hitTest cam nodes m tolPx
                        in
                        (if r.index == ix then
                            []

                         else
                            [ "index" ]
                        )
                            ++ (if r.insideDisc == inside then
                                    []

                                else
                                    [ "inside" ]
                               )
                            ++ close "nx" n.x r.n.x
                            ++ close "ny" n.y r.n.y
                            ++ close "nz" n.z r.n.z
            )
        , section "tangentMove"
            (D.map3 (\n d o -> ( n, d, o )) (D.at [ "in", "n" ] vec) (D.at [ "in", "delta" ] vec) (D.at [ "out", "n" ] vec))
            (\_ ( n, d, o ) ->
                let
                    r =
                        Globe.tangentMove n d
                in
                close "x" o.x r.x ++ close "y" o.y r.y ++ close "z" o.z r.z
            )
        , section "tangentMoveLB"
            (D.map3 (\a b o -> ( a, b, o ))
                (D.map2 Tuple.pair (D.at [ "in", "l" ] D.float) (D.at [ "in", "b" ] D.float))
                (D.map2 Tuple.pair (D.at [ "in", "de" ] D.float) (D.at [ "in", "dn" ] D.float))
                (D.map2 Tuple.pair (D.at [ "out", "l" ] D.float) (D.at [ "out", "b" ] D.float))
            )
            (\_ ( ( l, b ), ( de, dn ), ( wl, wb ) ) ->
                let
                    ( l2, b2 ) =
                        Globe.tangentMoveLB l b de dn
                in
                closeAngle "l" wl l2 ++ close "b" wb b2
            )
        , section "hoverPull"
            (D.map4 (\i n nh o -> ( i, n, ( nh, o ) ))
                (D.map4 (\a b c d -> { lam = a, beta = b, z = c, rho = d })
                    (D.at [ "in", "lam" ] D.float)
                    (D.at [ "in", "beta" ] D.float)
                    (D.at [ "in", "Z" ] D.float)
                    (D.at [ "in", "rho_fit" ] D.float)
                )
                (D.at [ "in", "n" ] vec)
                (D.at [ "in", "nh" ] vec)
                (D.at [ "out", "delta" ] vec)
            )
            (\_ ( i, n, ( nh, o ) ) ->
                let
                    cam =
                        Globe.camera (screenOf ( 500, 400 ) i.rho) { lam = i.lam, beta = i.beta, z = i.z }

                    r =
                        Globe.hoverPull cam n nh 0.2 14
                in
                close "x" o.x r.x ++ close "y" o.y r.y ++ close "z" o.z r.z
            )
        ]
