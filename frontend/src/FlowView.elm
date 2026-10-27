module FlowView exposing (view, viewArchitecture)

{-| The flowchart of a page (requirement FL-3): what starts the chain at the top, the steps and questions in between,
the end products at the bottom. Boxes take the colour of the kind of the first page they link to, so a box says what
sort of thing it is before it is read; the page names inside a box open those pages. The arrows use elm-visualization's
`Shape.bumpYCurve`; the placing is in `FlowLayout`.
-}

import Data exposing (Graph)
import Flow exposing (Role(..))
import FlowLayout exposing (Placed, Route)
import Html exposing (Html, div, h3, p, span, text)
import Html.Attributes as A
import I18n exposing (Lang)
import Path
import Shape
import Svg exposing (Svg)
import Svg.Attributes as S
import Svg.Events as SE
import Types exposing (Msg(..))


view : Lang -> Graph -> String -> Html Msg
view lang graph markdown =
    let
        chart =
            Flow.parse markdown

        s =
            I18n.strings lang
    in
    if List.isEmpty chart.boxes then
        text ""

    else
        div [ A.class "flow" ]
            [ chartSvg graph lang chart
            , div [ A.class "flow-legend" ]
                [ legendItem "fl-trigger" s.flowStart
                , legendItem "fl-step" s.flowStep
                , legendItem "fl-decide" s.flowQuestion
                , legendItem "fl-product" s.flowEnd
                , span [ A.class "flow-hint" ] [ text s.flowHint ]
                ]
            ]


{-| The `## Architecture` section (requirement PJ-3): the C4 context diagram and the containers diagram of a project,
one under the other, with a key to the five kinds of box. -}
viewArchitecture : Lang -> Graph -> String -> Html Msg
viewArchitecture lang graph markdown =
    let
        s =
            I18n.strings lang

        captions =
            [ s.archContext, s.archContainers ]

        level i ( heading, chart ) =
            div [ A.class "arch-level" ]
                [ h3 [] [ text heading ]
                , p [ A.class "arch-caption" ] [ text (captions |> List.drop i |> List.head |> Maybe.withDefault "") ]
                , chartSvg graph lang chart
                ]
    in
    div [ A.class "flow arch" ]
        (List.indexedMap level (Flow.parseLevels markdown)
            ++ [ div [ A.class "flow-legend" ]
                    [ legendItem "fl-person" s.archPerson
                    , legendItem "fl-system" s.archSystem
                    , legendItem "fl-container" s.archContainer
                    , legendItem "fl-store" s.archStore
                    , legendItem "fl-external" s.archExternal
                    , span [ A.class "flow-hint" ] [ text s.flowHint ]
                    ]
               ]
        )


chartSvg : Graph -> Lang -> Flow.Chart -> Html Msg
chartSvg graph lang chart =
    let
        laid =
            FlowLayout.layout chart

        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id

        accent b =
            b.links
                |> List.head
                |> Maybe.andThen (Data.nodeById graph)
                |> Maybe.map (.kind >> Data.kindColour graph)
                |> Maybe.withDefault "#8a8f98"
    in
    div [ A.class "flow-scroll" ]
        [ Svg.svg
            [ S.viewBox ("0 0 " ++ String.fromFloat laid.width ++ " " ++ String.fromFloat laid.height)
            , S.width (String.fromFloat laid.width)
            , S.height (String.fromFloat laid.height)
            , S.class "flow-svg"
            , A.attribute "role" "img"
            ]
            (Svg.defs []
                [ Svg.marker
                    [ S.id "flow-arrow", S.viewBox "0 0 10 10", S.refX "9", S.refY "5", S.markerWidth "7", S.markerHeight "7", S.orient "auto-start-reverse" ]
                    [ Svg.path [ S.d "M0,0 L10,5 L0,10 z", S.class "fl-head" ] [] ]
                ]
                :: List.map route laid.routes
                ++ List.map (box titleOf accent) laid.boxes
                ++ List.map routeLabel laid.routes
            )
        ]


legendItem : String -> String -> Html msg
legendItem cls label =
    span [ A.class "flow-key" ] [ span [ A.class ("flow-swatch " ++ cls) ] [], text label ]


route : Route -> Svg msg
route r =
    Svg.path
        [ S.d (Shape.line Shape.bumpYCurve (List.map Just r.points) |> Path.toString)
        , S.class "fl-edge"
        , S.markerEnd "url(#flow-arrow)"
        ]
        []


routeLabel : Route -> Svg msg
routeLabel r =
    if r.arrow.label == "" then
        text_ ""

    else
        Svg.text_
            [ S.x (String.fromFloat (Tuple.first r.labelAt))
            , S.y (String.fromFloat (Tuple.second r.labelAt))
            , S.class "fl-elabel"
            , S.textAnchor
                (if r.labelRight then
                    "start"

                 else
                    "end"
                )
            ]
            [ Svg.text r.arrow.label ]


text_ : String -> Svg msg
text_ t =
    Svg.text t


box : (String -> String) -> (Flow.Box -> String) -> Placed -> Svg Msg
box titleOf accent p =
    let
        left =
            p.x - p.w / 2

        top =
            p.y - p.h / 2

        cls =
            case p.box.role of
                Trigger ->
                    "fl-box fl-trigger"

                Step ->
                    "fl-box fl-step"

                Decide ->
                    "fl-box fl-decide"

                Product ->
                    "fl-box fl-product"

                Person ->
                    "fl-box fl-person"

                System ->
                    "fl-box fl-system"

                Container ->
                    "fl-box fl-container"

                Store ->
                    "fl-box fl-store"

                External ->
                    "fl-box fl-external"

        shape =
            case p.box.role of
                Decide ->
                    [ Svg.polygon
                        [ S.points (pointsOf [ ( p.x, top ), ( left + p.w, p.y ), ( p.x, top + p.h ), ( left, p.y ) ])
                        , S.class cls
                        ]
                        []
                    ]

                Trigger ->
                    [ Svg.rect [ S.x (f left), S.y (f top), S.width (f p.w), S.height (f p.h), S.rx (f (p.h / 2)), S.class cls ] [] ]

                Product ->
                    [ Svg.rect [ S.x (f left), S.y (f top), S.width (f p.w), S.height (f p.h), S.rx "8", S.class cls ] []
                    , Svg.rect [ S.x (f (left + 4)), S.y (f (top + 4)), S.width (f (p.w - 8)), S.height (f (p.h - 8)), S.rx "5", S.class "fl-inner" ] []
                    ]

                Step ->
                    [ Svg.rect [ S.x (f left), S.y (f top), S.width (f p.w), S.height (f p.h), S.rx "8", S.class cls ] [] ]

                Person ->
                    [ Svg.rect [ S.x (f left), S.y (f top), S.width (f p.w), S.height (f p.h), S.rx "14", S.class cls ] []
                    , Svg.circle [ S.cx (f p.x), S.cy (f top), S.r "9", S.class cls ] []
                    ]

                Store ->
                    let
                        rx =
                            p.w / 2
                    in
                    [ Svg.path
                        [ S.d
                            ("M" ++ f left ++ "," ++ f (top + 9) ++ " a" ++ f rx ++ ",9 0 0 1 " ++ f p.w ++ ",0 v" ++ f (p.h - 18) ++ " a" ++ f rx ++ ",9 0 0 1 -" ++ f p.w ++ ",0 z")
                        , S.class cls
                        ]
                        []
                    , Svg.path [ S.d ("M" ++ f left ++ "," ++ f (top + 9) ++ " a" ++ f rx ++ ",9 0 0 0 " ++ f p.w ++ ",0"), S.class "fl-inner" ] []
                    ]

                _ ->
                    [ Svg.rect [ S.x (f left), S.y (f top), S.width (f p.w), S.height (f p.h), S.rx "5", S.class cls ] [] ]

        count =
            List.length p.lines

        linkRow =
            if List.isEmpty p.box.links || p.box.role == Decide then
                0

            else
                20

        drop =
            if p.box.role == Person then
                7

            else
                0

        firstBaseline =
            p.y - (toFloat count * 16 + linkRow) / 2 + 12 + drop

        textLines =
            p.lines
                |> List.indexedMap
                    (\i line ->
                        Svg.text_
                            [ S.x (f p.x)
                            , S.y (f (firstBaseline + 16 * toFloat i))
                            , S.textAnchor "middle"
                            , S.class
                                (if i < p.head then
                                    "fl-text fl-name"

                                 else
                                    "fl-text"
                                )
                            ]
                            [ Svg.text line ]
                    )

        links =
            case ( p.box.role, p.box.links ) of
                ( Decide, _ ) ->
                    []

                ( _, [] ) ->
                    []

                ( _, [ one ] ) ->
                    [ linkText titleOf one p.x (top + p.h - 11) 30 ]

                ( _, first :: second :: _ ) ->
                    [ linkText titleOf first (p.x - p.w / 4) (top + p.h - 11) 14
                    , linkText titleOf second (p.x + p.w / 4) (top + p.h - 11) 14
                    ]
    in
    Svg.g [ S.class "fl-group", S.style ("--c:" ++ accent p.box) ] (shape ++ textLines ++ links)


linkText : (String -> String) -> String -> Float -> Float -> Int -> Svg Msg
linkText titleOf id x y limit =
    Svg.text_
        [ S.x (f x)
        , S.y (f y)
        , S.textAnchor "middle"
        , S.class "fl-link"
        , SE.onClick (OpenNode id)
        , A.attribute "role" "link"
        ]
        [ Svg.text ("↗ " ++ shorten limit (titleOf id)) ]


shorten : Int -> String -> String
shorten limit t =
    if String.length t <= limit then
        t

    else
        String.left (limit - 1) t ++ "…"


f : Float -> String
f =
    String.fromFloat


pointsOf : List ( Float, Float ) -> String
pointsOf pts =
    pts |> List.map (\( x, y ) -> f x ++ "," ++ f y) |> String.join " "
