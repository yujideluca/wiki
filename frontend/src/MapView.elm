module MapView exposing (Info, Look, info, infoBoxes, lookAt, map, node, sheet)

{-| The home screen: the system map (Dark-style), and the four info boxes that follow the hovered node. -}

import Data exposing (EdgeType(..), Graph, Node)
import Dict
import Filter
import Html exposing (Html, a, button, div, h4, p, span, text)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as D
import I18n exposing (Lang)
import Layout exposing (Positions)
import Lens exposing (Lens)
import Route exposing (Route(..))
import Set exposing (Set)
import Svg exposing (Svg)
import Svg.Attributes as S
import Svg.Events as SE
import Touch
import Types exposing (Msg(..))
import WikiText
import Zoom exposing (Zoom)


type alias Info =
    { title : String
    , kind : String
    , what : String
    , does : String
    , fedBy : List String
    , receives : List String
    }


{-| What the four boxes show for a node. -}
info : Lang -> Graph -> Node -> Info
info lang graph n =
    let
        t =
            Data.nodeText lang n

        titles ids =
            List.filterMap (Data.nodeById graph >> Maybe.map (Data.title lang)) ids

        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id
    in
    { title = t.title
    , kind = n.kind
    , what = WikiText.plain titleOf t.what
    , does = WikiText.plain titleOf t.does
    , fedBy = titles n.fedBy
    , receives = titles n.feeds
    }


{-| The map, drawn in window coordinates: each dot is placed by the zoom and then by the lens (LN-1..LN-3), which
makes the dots in the middle bigger, more spread and labelled, and the ones near the border smaller and plainer. -}
map : Lang -> Graph -> Positions -> Positions -> Zoom -> Lens -> Float -> Float -> Maybe String -> Maybe String -> Maybe String -> Html Msg
map lang graph positions rest zoom lens width height project month active =
    let
        visibleIds =
            Filter.visible project month graph

        k =
            (Zoom.asRecord zoom).scale

        near =
            case active of
                Just id ->
                    Set.insert id (Filter.neighbours graph.edges id)

                Nothing ->
                    Set.empty

        place =
            Dict.filter (\id _ -> Set.member id visibleIds) >> Dict.map (\_ xy -> Lens.apply lens (Lens.project zoom xy))

        spots =
            place positions

        -- where each dot answers the pointer: at its resting place, so that the elastic movement can never slide a dot
        -- under (or out from under) a still pointer and make the hover flicker (DY-5)
        spotsAtRest =
            place rest

        edgeView e =
            case ( Dict.get e.from spots, Dict.get e.to spots ) of
                ( Just a, Just b ) ->
                    let
                        lit =
                            active == Just e.from || active == Just e.to

                        -- far from the middle the dashed "mentions" lines are left out: less detail at the border
                        coarse =
                            e.edgeType /= Feeds && min a.scale b.scale < 0.78
                    in
                    if coarse && not lit then
                        []

                    else
                        [ Svg.line
                            [ S.x1 (String.fromFloat a.x)
                            , S.y1 (String.fromFloat a.y)
                            , S.x2 (String.fromFloat b.x)
                            , S.y2 (String.fromFloat b.y)
                            , S.strokeWidth (String.fromFloat (clamp 0.5 2 ((if lit then 1.8 else 0.9) * (a.scale + b.scale) / 2)))
                            , S.class
                                ("edge"
                                    ++ (if e.edgeType == Feeds then
                                            " feeds"

                                        else
                                            " mentions"
                                       )
                                    ++ (if lit then
                                            " lit"

                                        else if active /= Nothing then
                                            " dim"

                                        else
                                            ""
                                       )
                                )
                            ]
                            []
                        ]

                _ ->
                    []

        nodeView n =
            case Dict.get n.id spots of
                Just spot ->
                    let
                        l =
                            lookAt k spot

                        isActive =
                            active == Just n.id
                    in
                    let
                        hit =
                            Dict.get n.id spotsAtRest |> Maybe.withDefault spot
                    in
                    [ node lang
                        graph
                        ( hit.x, hit.y )
                        { active = isActive
                        , offset = ( spot.x - hit.x, spot.y - hit.y )
                        , dim = active /= Nothing && not (Set.member n.id near)
                        , label = isActive || n.kind == "project" || Set.member n.id near || l.labelled
                        , radiusScale = l.radiusScale
                        , labelSize = l.labelSize
                        }
                        n
                    ]

                Nothing ->
                    []
    in
    Svg.svg
        ([ S.class "map"
         , S.width (String.fromFloat width)
         , S.height (String.fromFloat height)
           -- Zoom reads pointer positions through the viewBox; without one Chrome reports an empty box and every
           -- position becomes (0,0), so wheel zoom anchors at the corner and dragging does not pan.
         , S.viewBox ("0 0 " ++ String.fromFloat width ++ " " ++ String.fromFloat height)
         , A.attribute "role" "img"
         , A.attribute "aria-label" "System map"
         , A.attribute "data-zoom" (String.fromFloat k)
         ]
            ++ (Zoom.onWheel zoom ZoomMsg :: Zoom.onDrag zoom ZoomMsg ++ Zoom.onGesture zoom ZoomMsg)
            ++ touchEvents
        )
        [ Svg.defs []
            [ Svg.marker [ S.id "arrow", S.viewBox "0 0 10 10", S.refX "22", S.refY "5", S.markerWidth "5", S.markerHeight "5", S.orient "auto" ]
                [ Svg.path [ S.d "M0,0 L10,5 L0,10 z", S.class "arrowhead" ] [] ]
            ]
        , Svg.g [] (List.concatMap edgeView graph.edges ++ List.concatMap nodeView graph.nodes)
        ]


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


{-| How much detail a dot gets where the lens puts it, at zoom [k] (LN-2): near the middle it is bigger and labelled, near
the border smaller and without a label. -}
lookAt : Float -> Lens.Spot -> { radiusScale : Float, labelSize : Float, labelled : Bool }
lookAt k spot =
    { radiusScale = clamp 0.5 1.6 (spot.scale ^ 0.8) * clamp 0.7 2.2 (k ^ 0.6)
    , labelSize = 11 * clamp 0.85 1.25 spot.scale * clamp 1 1.6 (sqrt k)
    , labelled = k * spot.scale >= 0.95
    }


{-| How one dot is drawn: lit, dimmed, with a label or not, its radius factor and its label size in pixels. -}
type alias Look =
    { active : Bool
    , offset : ( Float, Float ) -- how far the drawing is from where the dot answers the pointer
    , dim : Bool
    , label : Bool
    , radiusScale : Float
    , labelSize : Float
    }


{-| One dot. Hover previews it in the boxes; click opens its page (MP-2); pressing and moving drags it, and its
neighbours follow elastically (DY-2). -}
node : Lang -> Graph -> ( Float, Float ) -> Look -> Node -> Svg Msg
node lang graph ( x, y ) look n =
    let
        base =
            if n.kind == "project" then
                11

            else if look.active then
                9

            else
                6

        r =
            base * look.radiusScale
    in
    Svg.g
        [ S.class
            ("node"
                ++ (if look.active then
                        " active"

                    else if look.dim then
                        " dim"

                    else
                        ""
                   )
                ++ (if n.status == "retired" then
                        " retired"

                    else
                        ""
                   )
            )
        , S.transform ("translate(" ++ String.fromFloat x ++ "," ++ String.fromFloat y ++ ")")
        , SE.onMouseOver (Hover n.id)
        , SE.onMouseOut Unhover
        , SE.onClick (OpenNode n.id)
        , SE.stopPropagationOn "mousedown" (D.map2 (\cx cy -> ( DragStart n.id cx cy, True )) (D.field "clientX" D.float) (D.field "clientY" D.float))
        , A.attribute "data-id" n.id
        ]
        [ Svg.g [ S.pointerEvents "none", S.transform ("translate(" ++ String.fromFloat (Tuple.first look.offset) ++ "," ++ String.fromFloat (Tuple.second look.offset) ++ ")") ]
            [ if look.active then
                Svg.circle [ S.r (String.fromFloat (r + 7)), S.class "halo" ] []

              else
                Svg.text ""
            , Svg.circle [ S.r (String.fromFloat r), S.fill (Data.kindColour graph n.kind), S.class "dot" ] []
            , if look.label then
                Svg.text_
                    [ S.y (String.fromFloat (r + look.labelSize + 2))
                    , S.textAnchor "middle"
                    , S.class "label"
                    , S.fontSize (String.fromFloat look.labelSize)
                    ]
                    [ Svg.text (Data.title lang n) ]

              else
                Svg.title [] [ Svg.text (Data.title lang n) ]
            ]

        -- A larger invisible disc around the dot, so the pointer reaches a node a few pixels early.
        , Svg.circle [ S.r (String.fromFloat (r + 6)), S.fill "transparent", S.class "hit" ] []
        ]


{-| The four boxes. [boxHeight] is their fixed height on wide windows (a longer text scrolls inside), `Nothing` on
narrow ones where they size themselves (MP-5). -}
infoBoxes : Lang -> Maybe Float -> Maybe Info -> Html Msg
infoBoxes lang boxHeight maybeInfo =
    let
        s =
            I18n.strings lang

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
sheet : Lang -> Graph -> Node -> Html Msg
sheet lang graph n =
    let
        s =
            I18n.strings lang

        i =
            info lang graph n

        pill id =
            case Data.nodeById graph id of
                Just m ->
                    [ button
                        [ A.class "chip pill"
                        , A.style "--c" (Data.kindColour graph m.kind)
                        , E.onClick (SelectNode id)
                        ]
                        [ text (Data.title lang m) ]
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
                [ Data.nodeById graph n.project |> Maybe.map (Data.title lang) |> Maybe.withDefault n.project ]
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
