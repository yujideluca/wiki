module MapView exposing (Info, info, infoBoxes, map, node)

{-| The home screen: the system map (Dark-style), and the four info boxes that follow the hovered node. -}

import Data exposing (EdgeType(..), Graph, Node)
import Dict
import Filter
import Html exposing (Html, div, h4, p, span, text)
import Html.Attributes as A
import I18n exposing (Lang)
import Layout exposing (Positions)
import Set exposing (Set)
import Svg exposing (Svg)
import Svg.Attributes as S
import Svg.Events as SE
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


map : Lang -> Graph -> Positions -> Zoom -> Float -> Float -> Set String -> Maybe String -> Html Msg
map lang graph positions zoom width height visibleIds active =
    let
        scale =
            (Zoom.asRecord zoom).scale

        allLabels =
            scale >= 0.95

        labelSize =
            12 / clamp 0.35 1 scale

        near =
            case active of
                Just id ->
                    Set.insert id (Filter.neighbours graph.edges id)

                Nothing ->
                    Set.empty

        pos id =
            Dict.get id positions

        edgeView e =
            case ( pos e.from, pos e.to ) of
                ( Just ( x1, y1 ), Just ( x2, y2 ) ) ->
                    if Set.member e.from visibleIds && Set.member e.to visibleIds then
                        let
                            lit =
                                active == Just e.from || active == Just e.to
                        in
                        [ Svg.line
                            [ S.x1 (String.fromFloat x1)
                            , S.y1 (String.fromFloat y1)
                            , S.x2 (String.fromFloat x2)
                            , S.y2 (String.fromFloat y2)
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

                    else
                        []

                _ ->
                    []

        nodeView n =
            case pos n.id of
                Just xy ->
                    if Set.member n.id visibleIds then
                        [ node lang graph xy (active == Just n.id) (active /= Nothing && not (Set.member n.id near)) (allLabels || n.kind == "project" || Set.member n.id near) labelSize n ]

                    else
                        []

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
         ]
            ++ Zoom.events zoom ZoomMsg
        )
        [ Svg.defs []
            [ Svg.marker [ S.id "arrow", S.viewBox "0 0 10 10", S.refX "22", S.refY "5", S.markerWidth "5", S.markerHeight "5", S.orient "auto" ]
                [ Svg.path [ S.d "M0,0 L10,5 L0,10 z", S.class "arrowhead" ] [] ]
            ]
        , Svg.g [ Zoom.transform zoom ]
            [ Svg.g [] (List.concatMap edgeView graph.edges)
            , Svg.g [] (List.concatMap nodeView graph.nodes)
            ]
        ]


{-| One dot. Hover previews it in the boxes; click opens its page (MP-2). -}
node : Lang -> Graph -> ( Float, Float ) -> Bool -> Bool -> Bool -> Float -> Node -> Svg Msg
node lang graph ( x, y ) isActive isDim showLabel labelSize n =
    let
        r =
            if n.kind == "project" then
                11

            else if isActive then
                9

            else
                6
    in
    Svg.g
        [ S.class
            ("node"
                ++ (if isActive then
                        " active"

                    else if isDim then
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
        , A.attribute "data-id" n.id
        ]
        ([ if isActive then
            Svg.circle [ S.r (String.fromFloat (r + 7)), S.class "halo" ] []

           else
            Svg.text ""
         , Svg.circle [ S.r (String.fromFloat r), S.fill (Data.kindColour graph n.kind), S.class "dot" ] []
         , if showLabel then
            Svg.text_
                [ S.y (String.fromFloat (r + labelSize + 2))
                , S.textAnchor "middle"
                , S.class "label"
                , S.fontSize (String.fromFloat labelSize)
                ]
                [ Svg.text (Data.title lang n) ]

           else
            Svg.title [] [ Svg.text (Data.title lang n) ]
         ]
        )


infoBoxes : Lang -> Maybe Info -> Html Msg
infoBoxes lang maybeInfo =
    let
        s =
            I18n.strings lang

        box heading body =
            div [ A.class "box" ] [ h4 [] [ text heading ], body ]

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
