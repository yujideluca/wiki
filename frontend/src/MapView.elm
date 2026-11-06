module MapView exposing (Info, Look, info, infoBoxes, map, node, sheet)

{-| The home screen: the system map (Dark-style), and the four info boxes that follow the hovered node. -}

import Data exposing (EdgeType(..), Graph, Node)
import Dict
import Html exposing (Html, a, button, div, h4, p, span, text)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as D
import UiText
import Array
import Globe exposing (Cam, Spot)
import GlobeGrab
import MapCamera
import MapGeometry exposing (Dot, Geometry, Statics)
import Motion
import Route exposing (Route(..))
import Set exposing (Set)
import Svg exposing (Svg)
import Svg.Attributes as S
import Svg.Events as SE
import Svg.Lazy
import Touch
import Types exposing (Msg(..))
import WikiText


type alias Info =
    { title : String
    , kind : String
    , what : String
    , does : String
    , fedBy : List String
    , receives : List String
    }


{-| What the four boxes show for a node. -}
info : Graph -> Node -> Info
info graph n =
    let
        t =
            Data.nodeText n

        titles ids =
            List.filterMap (Data.nodeById graph >> Maybe.map Data.title) ids

        titleOf id =
            Data.nodeById graph id |> Maybe.map Data.title |> Maybe.withDefault id
    in
    { title = t.title
    , kind = n.kind
    , what = WikiText.plain titleOf t.what
    , does = WikiText.plain titleOf t.does
    , fedBy = titles n.fedBy
    , receives = titles n.feeds
    }


{-| The map, drawn in window coordinates: the globe seen by one camera (`Globe`), which makes the dots in the middle bigger,
more spread and labelled, and the ones near the horizon smaller, flattened and plainer; the far side is not drawn.

The resting side comes ready from [geometry] and [statics] (see `MapGeometry`). [motion] holds how far the springs have pushed
each dot (milliradians east and north); only the dots that are displaced are placed again, the rest are drawn from the cache
through `Svg.Lazy`, so that a frame in which only a few dots move costs about that many dots (DY-1). [adj] says who is whose
neighbour. -}
map : Geometry -> Statics -> Motion.State -> Motion.Adjacency -> Float -> Float -> Maybe String -> Html Msg
map geometry statics motion adj width height active =
    let
        near =
            case active of
                Just id ->
                    Set.insert id (Set.fromList (Motion.neighbours adj id))

                Nothing ->
                    Set.empty

        -- the dots that are away from their resting place, with where they are placed now (the others are exactly at rest)
        moved : Dict.Dict String Dot
        moved =
            if Motion.isRest motion then
                Dict.empty

            else
                List.foldl
                    (\( id, dx, dy ) acc ->
                        case Dict.get id statics.byId |> Maybe.andThen (\i -> Array.get i statics.items) of
                            Just it ->
                                let
                                    v =
                                        GlobeGrab.displace it.vec (dx / MapCamera.mrad) (dy / MapCamera.mrad)
                                in
                                Dict.insert id (MapGeometry.dotAt geometry it v.x v.y v.z) acc

                            Nothing ->
                                acc
                    )
                    Dict.empty
                    (Motion.displaced adj motion)

        -- where a dot is drawn now; a dot on the far side is not drawn
        spotOf id =
            case Dict.get id moved of
                Just d ->
                    if d.spot.visible then
                        Just d.spot

                    else
                        Nothing

                Nothing ->
                    Dict.get id statics.byId
                        |> Maybe.andThen (\i -> Array.get i geometry.dots)
                        |> Maybe.andThen
                            (\d ->
                                if d.spot.visible then
                                    Just d.spot

                                else
                                    Nothing
                            )

        edgeView row =
            let
                lit =
                    active == Just row.from || active == Just row.to
            in
            -- far from the middle the dashed "mentions" lines are left out: less detail at the border
            if row.coarse && not lit then
                []

            else if not (Dict.isEmpty moved) && (Dict.member row.from moved || Dict.member row.to moved) then
                case ( spotOf row.from, spotOf row.to ) of
                    ( Just a, Just b ) ->
                        [ edgeLine row.feeds lit a b ]

                    _ ->
                        []

            else
                [ Svg.Lazy.lazy4 edgeLine row.feeds lit (Tuple.first row.ends) (Tuple.second row.ends) ]

        nodeView dot =
            let
                id =
                    dot.node.id

                isActive =
                    active == Just id

                -- the lit dot and its neighbours; the rest are dimmed by the stylesheet while a dot is lit (`.map.focus`), so that
                -- lighting a dot changes the classes of about forty elements and not of two hundred and a thousand lines
                isNear =
                    Set.member id near

                -- detail (label) follows the resting place, not the pulled drawing, so it cannot switch on and off
                labelled restLabelled =
                    isActive || dot.node.kind == "project" || Set.member id near || restLabelled
            in
            case Dict.get id moved of
                Nothing ->
                    [ Svg.Lazy.lazy4 restNode dot isActive isNear (labelled dot.labelled) ]

                Just d ->
                    if not d.spot.visible then
                        []

                    else
                        [ node d
                            { active = isActive
                            , offset = ( d.spot.x - dot.spot.x, d.spot.y - dot.spot.y )
                            , near = isNear
                            , label = labelled dot.labelled
                            }
                        ]
    in
    Svg.svg
        ([ S.class
            (if active == Nothing then
                "map"

             else
                "map focus"
            )
         , S.width (String.fromFloat width)
         , S.height (String.fromFloat height)
         , S.viewBox ("0 0 " ++ String.fromFloat width ++ " " ++ String.fromFloat height)
         , A.attribute "role" "img"
         , A.attribute "aria-label" "System map"
         , A.attribute "data-zoom" (String.fromFloat geometry.z)
         ]
            ++ pointerEvents
            ++ touchEvents
        )
        [ Svg.defs []
            [ Svg.radialGradient [ S.id "globe-shade", S.cx "46%", S.cy "38%", S.r "72%" ]
                [ Svg.stop [ S.offset "0%", S.stopColor "#5d84c2", S.stopOpacity "0.20" ] []
                , Svg.stop [ S.offset "65%", S.stopColor "#2a3f66", S.stopOpacity "0.08" ] []
                , Svg.stop [ S.offset "100%", S.stopColor "#000000", S.stopOpacity "0.30" ] []
                ]
            , Svg.marker [ S.id "arrow", S.viewBox "0 0 10 10", S.refX "22", S.refY "5", S.markerWidth "5", S.markerHeight "5", S.orient "auto" ]
                [ Svg.path [ S.d "M0,0 L10,5 L0,10 z", S.class "arrowhead" ] [] ]
            ]

        -- the glass and the pointer's discs do not change while the dots spring about: the browser is not asked again
        , Svg.Lazy.lazy globe geometry.cam
        , Svg.g [] (List.concatMap edgeView geometry.edges)
        , Svg.g [] (List.concatMap nodeView geometry.visible)
        ]


{-| The pointer on the globe itself: the wheel zooms about the pointer and a press on the glass (not on a dot, whose own
handler stops the event) turns the globe under it. -}
pointerEvents : List (Html.Attribute Msg)
pointerEvents =
    let
        wheel =
            D.map3 (\x y dy -> { message = Wheel x y dy, stopPropagation = True, preventDefault = True })
                (D.field "clientX" D.float)
                (D.field "clientY" D.float)
                (D.field "deltaY" D.float)
    in
    [ E.custom "wheel" wheel
    , E.on "mousedown"
        (D.field "button" D.int
            |> D.andThen
                (\b ->
                    if b == 0 then
                        D.map2 PressAt (D.field "clientX" D.float) (D.field "clientY" D.float)

                    else
                        D.fail "not the main button"
                )
        )
    , E.on "mousemove" (notOnLabel (D.map2 PointerAt (D.field "clientX" D.float) (D.field "clientY" D.float)))
    , E.on "mouseleave" (D.succeed PointerLeft)
    , E.on "click" (D.map2 ClickAt (D.field "clientX" D.float) (D.field "clientY" D.float))
    ]


{-| A label has its own hover (the text can be selected), so a pointer moving over one is not looked at by the dot search. -}
notOnLabel : D.Decoder Msg -> D.Decoder Msg
notOnLabel decoder =
    D.oneOf [ D.at [ "target", "className", "baseVal" ] D.string, D.succeed "" ]
        |> D.andThen
            (\cls ->
                if String.contains "label" cls then
                    D.fail "over a label"

                else
                    decoder
            )


{-| One line between two dots, from [a] to [b]. -}
edgeLine : Bool -> Bool -> Spot -> Spot -> Svg Msg
edgeLine feeds lit a b =
    Svg.line
        [ S.x1 (px a.x)
        , S.y1 (px a.y)
        , S.x2 (px b.x)
        , S.y2 (px b.y)
        , S.strokeWidth (ratio (clamp 0.5 2 ((if lit then 1.8 else 0.9) * (a.scale + b.scale) / 2)))
        , S.class
            ("edge"
                ++ (if feeds then
                        " feeds"

                    else
                        " mentions"
                   )
                ++ (if lit then
                        " lit"

                    else
                        ""
                   )
            )
        ]
        []


{-| A dot that is at rest: drawn from the cache, where the camera put it. -}
restNode : Dot -> Bool -> Bool -> Bool -> Svg Msg
restNode dot isActive near label =
    node dot { active = isActive, offset = ( 0, 0 ), near = near, label = label }


{-| The body of the globe: a soft sphere shading and a few lines of latitude and longitude, so the eye reads the curve. They stay
in place while the globe is turned only in that they belong to the glass: the lines are those of the sphere, so they move with
it. Each line is cut where it goes over the horizon. -}
globe : Cam -> Svg Msg
globe cam =
    let
        steps n a b =
            List.range 0 n |> List.map (\i -> a + toFloat i * (b - a) / toFloat n)

        runs toVec ts =
            List.foldr
                (\t ( cur, done ) ->
                    let
                        p =
                            Globe.project cam (toVec t)
                    in
                    if p.visible then
                        ( ( px p.x ++ "," ++ px p.y ) :: cur, done )

                    else if List.isEmpty cur then
                        ( cur, done )

                    else
                        ( [], cur :: done )
                )
                ( [], [] )
                ts
                |> (\( cur, done ) ->
                        if List.isEmpty cur then
                            done

                        else
                            cur :: done
                   )

        polyline pts =
            Svg.polyline [ S.points (String.join " " pts), S.class "graticule" ] []

        deg d =
            d * pi / 180

        meridian l t =
            { x = cos t * sin l, y = sin t, z = cos t * cos l }

        parallel b t =
            { x = cos b * sin t, y = sin b, z = cos b * cos t }

        meridians =
            List.range 0 11
                |> List.concatMap (\i -> runs (meridian (deg (toFloat i * 30))) (steps 24 (-pi / 2) (pi * 3 / 2)))

        parallels =
            [ -60, -30, 0, 30, 60 ]
                |> List.concatMap (\b -> runs (parallel (deg b)) (steps 48 -pi pi))
    in
    Svg.g [ S.pointerEvents "none" ]
        (Svg.circle
            [ S.cx (String.fromFloat cam.cx)
            , S.cy (String.fromFloat cam.cy)
            , S.r (String.fromFloat cam.r)
            , S.fill "url(#globe-shade)"
            , S.class "globe-body"
            ]
            []
            :: List.map polyline (meridians ++ parallels)
        )


{-| A number for an SVG attribute, rounded to a tenth of a pixel: the full-precision text of a float (`412.83719283749`) is
several times longer, and the browser parses it and the virtual DOM compares it for every dot and line on every frame. -}
px : Float -> String
px v =
    String.fromFloat (toFloat (round (v * 10)) / 10)


{-| A unitless ratio or angle for an attribute, rounded to a hundredth. -}
ratio : Float -> String
ratio v =
    String.fromFloat (toFloat (round (v * 100)) / 100)


{-| The matrix entries of a dot's ellipse, to a thousandth. -}
thou : Float -> String
thou v =
    String.fromFloat (toFloat (round (v * 1000)) / 1000)


{-| A round dot at the place of [spot] is an ellipse: the circle under this matrix (`Globe.place`). -}
flatten : Spot -> String
flatten sp =
    "matrix(" ++ thou sp.la ++ " " ++ thou sp.lb ++ " " ++ thou sp.lb ++ " " ++ thou sp.ld ++ " 0 0)"


{-| The fingers on the map (TC-1..TC-3): see `Touch`. No double-tap or double-click zoom. -}
touchEvents : List (Html.Attribute Msg)
touchEvents =
    let
        fingers =
            D.field "touches"
                (D.keyValuePairs (D.map2 Tuple.pair (D.field "clientX" D.float) (D.field "clientY" D.float))
                    |> D.map (List.map Tuple.second)
                )

        on name phase =
            E.custom name (D.map (\f -> { message = TouchEvent phase f, stopPropagation = True, preventDefault = phase == Touch.Move }) fingers)
    in
    [ on "touchstart" Touch.Start, on "touchmove" Touch.Move, on "touchend" Touch.End, on "touchcancel" Touch.End ]


{-| How one dot is drawn: lit, dimmed, with a label or not. -}
type alias Look =
    { active : Bool
    , offset : ( Float, Float ) -- how far the drawing is from where the dot answers the pointer
    , near : Bool -- the lit dot or one of its neighbours: while a dot is lit, the others are dimmed (`.map.focus` in the stylesheet)
    , label : Bool
    }


{-| One dot as drawn, at the place the springs have put it. It hears nothing itself, except its label while that is at rest
(the discs of `hit` do the rest), and a label's pointer events are the same as the disc's, so moving from a dot to its label
looks the same to the page as before (MP-2). -}
node : Dot -> Look -> Svg Msg
node dot look =
    let
        n =
            dot.node

        base =
            if n.kind == "project" then
                11

            else if look.active then
                9

            else
                6

        r =
            base * dot.radiusScale

        -- where the globe turns away the round dot is seen at a slant: an ellipse whose short axis points to the middle
        slant =
            flatten dot.spot

        -- a label answers the pointer only if it is at rest, and (the stylesheet) only while no other dot is lit: a neighbour's
        -- label that is pulled, or that springs back, would otherwise slide under a still pointer and take the hover from the
        -- lit dot (DY-7)
        labelAtRest =
            abs (Tuple.first look.offset) + abs (Tuple.second look.offset) < 0.5
    in
    Svg.g
        ([ S.class
            ("node"
                ++ (if look.active then
                        " active near"

                    else if look.near then
                        " near"

                    else
                        ""
                   )
                ++ (if n.status == "retired" then
                        " retired"

                    else
                        ""
                   )
            )
         , S.transform ("translate(" ++ px dot.spot.x ++ "," ++ px dot.spot.y ++ ")")
         , S.pointerEvents "none"
         ]
            ++ (if dot.spot.opacity < 1 then
                    [ S.opacity (ratio dot.spot.opacity) ]

                else
                    []
               )
        )
        [ if look.active then
            Svg.circle [ S.r (px (r + 7)), S.class "halo", S.transform slant ] []

          else
            Svg.text ""
        , Svg.circle [ S.r (px r), S.fill dot.colour, S.class "dot", S.transform slant ] []
        , if dot.labelled || look.label then
            Svg.text_
                ([ S.y (px (r + dot.labelSize + 2))
                 , S.textAnchor "middle"
                 , S.class "label"
                 , S.pointerEvents
                    (if labelAtRest then
                        "all"

                     else
                        "none"
                    )
                 , S.fontSize (px dot.labelSize)

                 -- only a drag that starts on the text selects it: no pan, no dot drag, no page opening
                 , SE.stopPropagationOn "mousedown" (D.succeed ( NoOp, True ))
                 , SE.stopPropagationOn "click" (D.succeed ( NoOp, True ))
                 ]
                    ++ [ SE.onMouseOver (Hover n.id), SE.onMouseOut Unhover ]
                )
                [ Svg.text dot.title ]

          else
            Svg.title [] [ Svg.text dot.title ]
        ]


{-| The four boxes. [boxHeight] is their fixed height on wide windows (a longer text scrolls inside), `Nothing` on
narrow ones where they size themselves (MP-5). -}
infoBoxes : Maybe Float -> Maybe Info -> Html Msg
infoBoxes boxHeight maybeInfo =
    let
        s =
            UiText.strings

        box heading body =
            div
                (A.class "box"
                    :: (case boxHeight of
                            Just h ->
                                [ A.style "height" (String.fromFloat h ++ "px"), A.style "overflow-y" "auto" ]

                            Nothing ->
                                []
                       )
                )
                [ h4 [] [ text heading ], body ]

        para str =
            p []
                [ text
                    (if String.isEmpty str then
                        s.nothing

                     else
                        str
                    )
                ]

        names list =
            if List.isEmpty list then
                p [] [ text s.nothing ]

            else
                p [] (List.intersperse (text " · ") (List.map (\t -> span [ A.class "name" ] [ text t ]) list))
    in
    case maybeInfo of
        Nothing ->
            div [ A.class "boxes empty" ] [ p [ A.class "hint" ] [ text s.hoverHint ] ]

        Just i ->
            div [ A.class "boxes" ]
                [ box s.whatItIs (para i.what)
                , box s.whatItDoes (para i.does)
                , box s.fedBy (names i.fedBy)
                , box s.receives (names i.receives)
                ]


{-| The phone's balloon for the selected node (MB-2): a card sliding up over the map, as the place card of Google Maps,
with the four texts of the desktop boxes, the neighbours as buttons that jump to them, and the link to the page. -}
sheet : Graph -> Node -> Html Msg
sheet graph n =
    let
        s =
            UiText.strings

        i =
            info graph n

        pill id =
            case Data.nodeById graph id of
                Just m ->
                    [ button
                        [ A.class "chip pill"
                        , A.style "--c" (Data.kindColour graph m.kind)
                        , E.onClick (SelectNode id)
                        ]
                        [ text (Data.title m) ]
                    ]

                Nothing ->
                    []

        textBlock heading str =
            [ h4 [] [ text heading ]
            , p []
                [ text
                    (if String.isEmpty str then
                        s.nothing

                     else
                        str
                    )
                ]
            ]

        pills heading ids =
            if List.isEmpty ids then
                []

            else
                [ h4 [] [ text heading ], div [ A.class "pills" ] (List.concatMap pill ids) ]

        owner =
            if n.project == "none" then
                []

            else
                [ Data.nodeById graph n.project |> Maybe.map Data.title |> Maybe.withDefault n.project ]
    in
    div [ A.class "sheet", A.attribute "role" "dialog", A.attribute "aria-label" i.title ]
        [ div [ A.class "sheet-grip" ] []
        , div [ A.class "sheet-head" ]
            [ div [ A.class "sheet-titles" ]
                [ div [ A.class "sheet-title" ] [ text i.title ]
                , div [ A.class "sheet-kind" ]
                    [ span [ A.class "sdot", A.style "background" (Data.kindColour graph n.kind) ] []
                    , text (String.join " · " (i.kind :: owner ++ [ n.status ]))
                    ]
                ]
            , button [ A.class "sheet-close", E.onClick CloseSheet, A.attribute "aria-label" s.close ] [ text "×" ]
            ]
        , a [ A.class "sheet-open", A.href (Route.toPath (ArticleView n.id)) ] [ text s.openArticle ]
        , div [ A.class "sheet-body" ]
            (textBlock s.whatItIs i.what
                ++ textBlock s.whatItDoes i.does
                ++ pills s.fedBy n.fedBy
                ++ pills s.receives n.feeds
            )
        ]
