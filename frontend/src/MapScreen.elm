module MapScreen exposing (view)

{-| The home screen around the map (MP-1..MP-5, MB-1..MB-3): the map itself, the project filter and the timeline over it, the
legend, and under it the title line and the four boxes (on a phone the balloon). Everything but the map is wrapped in
`Html.Lazy`, so while the dots spring about and none of its inputs has changed it is not built or compared again (DY-8). -}

import Data exposing (Graph)
import Filter
import Html exposing (Html, a, div, input, label, option, select, span, text)
import Html.Attributes as A
import Html.Events as E
import Html.Lazy
import I18n exposing (Lang)
import MapSize
import MapView
import Route exposing (Route(..))
import Set
import Types exposing (Model, Msg(..))


view : Model -> Graph -> Html Msg
view model g =
    let
        phone =
            MapSize.isPhone model.width

        -- the model's own values, not new `Just`s, so that the lazy views below can tell that nothing changed
        active =
            if phone then
                model.selected

            else if model.hovered /= Nothing then
                model.hovered

            else
                model.focused
    in
    div [ A.class "map-screen" ]
        (div [ A.class "map-wrap" ]
            [ MapView.map model.geometry model.statics model.motion model.adj model.width model.height active

            -- everything around the map is skipped while the dots spring about and nothing here has changed
            , Html.Lazy.lazy4 controls model.lang g model.project model.month
            , Html.Lazy.lazy legend g
            , if model.sim /= Nothing then
                div [ A.class "layout-wait" ] [ text (I18n.strings model.lang).loading ]

              else
                text ""
            ]
            :: (if phone then
                    [ Html.Lazy.lazy3 balloon model.lang g active ]

                else
                    [ Html.Lazy.lazy4 desktopLower model.lang g model.boxHeight active ]
               )
        )


{-| The project filter and the timeline slider over the map. -}
controls : Lang -> Graph -> Maybe String -> Maybe String -> Html Msg
controls lang g project month =
    let
        s =
            I18n.strings lang

        stops =
            Filter.days g.nodes

        stopIndex =
            case month of
                Nothing ->
                    List.length stops - 1

                Just m ->
                    stops |> List.indexedMap Tuple.pair |> List.filter (\( _, x ) -> x == m) |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault 0

        projects =
            g.nodes |> List.filter (\n -> n.kind == "project") |> List.sortBy (Data.title lang)
    in
    div [ A.class "controls" ]
        [ select [ E.onInput SetProject, A.attribute "aria-label" s.project ]
            (option [ A.value "" ] [ text s.allProjects ]
                :: List.map (\p -> option [ A.value p.id, A.selected (project == Just p.id) ] [ text (Data.title lang p) ]) projects
            )
        , if List.length stops > 1 then
            label [ A.class "timeline" ]
                [ span [] [ text (s.timeline ++ " " ++ Maybe.withDefault "—" (month |> orLast stops)) ]
                , input
                    [ A.type_ "range"
                    , A.min "0"
                    , A.max (String.fromInt (List.length stops - 1))
                    , A.value (String.fromInt stopIndex)
                    , E.onInput SetMonth
                    ]
                    []
                ]

          else
            text ""
        ]


{-| The phone's balloon for the selected node, or the hint to tap one. -}
balloon : Lang -> Graph -> Maybe String -> Html Msg
balloon lang g active =
    case active |> Maybe.andThen (Data.nodeById g) of
        Just n ->
            MapView.sheet lang g n

        Nothing ->
            div [ A.class "tap-hint" ] [ text (I18n.strings lang).tapHint ]


{-| The title line and the four boxes under the map on a desktop. -}
desktopLower : Lang -> Graph -> Maybe Float -> Maybe String -> Html Msg
desktopLower lang g boxHeight active =
    let
        s =
            I18n.strings lang

        focusInfo =
            active |> Maybe.andThen (Data.nodeById g) |> Maybe.map (MapView.info lang g)
    in
    div [ A.class "lower" ]
        [ div [ A.class "focus-title" ]
            (case ( active |> Maybe.andThen (Data.nodeById g), focusInfo ) of
                ( Just n, Just i ) ->
                    [ span [ A.class "ft-title" ] [ text i.title ]
                    , span [ A.class "ft-kind" ]
                        [ text
                            (String.join " · "
                                (i.kind
                                    :: (if n.project == "none" then
                                            []

                                        else
                                            [ Data.nodeById g n.project |> Maybe.map (Data.title lang) |> Maybe.withDefault n.project ]
                                       )
                                    ++ [ n.status ]
                                )
                            )
                        ]
                    , a [ A.class "ft-open", A.href (Route.toPath (ArticleView n.id)) ] [ text s.openArticle ]
                    ]

                _ ->
                    []
            )
        , MapView.infoBoxes lang boxHeight focusInfo
        ]


orLast : List String -> Maybe String -> Maybe String
orLast stops m =
    case m of
        Just x ->
            Just x

        Nothing ->
            List.reverse stops |> List.head


legend : Graph -> Html Msg
legend g =
    let
        used =
            g.nodes |> List.map .kind |> Set.fromList
    in
    div [ A.class "legend" ]
        (g.kinds
            |> List.filter (\k -> Set.member k.name used)
            |> List.map (\k -> span [ A.class "lg-item", A.title k.description ] [ span [ A.class "sdot", A.style "background" k.colour ] [], text k.name ])
        )
