port module Main exposing (main)

import ArticleView
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Data exposing (Graph)
import Dict
import Filter
import Html exposing (Html, a, button, div, header, input, label, li, option, select, span, text, ul)
import Html.Attributes as A
import Html.Events as E
import Http
import I18n exposing (Lang)
import Json.Decode as D
import Layout
import MapSize
import MapView
import Route exposing (Route(..))
import Search
import Set
import Task
import Types exposing (Load(..), Model, Msg(..))
import Url exposing (Url)
import Zoom


port saveLang : String -> Cmd msg


main : Program { lang : String } Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init : { lang : String } -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            Route.fromUrl url

        model =
            { key = key
            , lang = I18n.fromCode flags.lang
            , route = route
            , graph = Loading
            , layout = Dict.empty
            , positions = Dict.empty
            , zoom = Zoom.init { width = 800, height = 500 }
            , width = 800
            , height = 500
            , boxHeight = Nothing
            , hovered = Nothing
            , focused = Nothing
            , query = ""
            , suggestionIndex = 0
            , suggestionsOpen = False
            , project = Nothing
            , month = Nothing
            , article = Loading
            , step = 0
            }
    in
    ( model
    , Cmd.batch
        [ Http.get { url = "/data/graph.json", expect = Http.expectJson GotGraph Data.graphDecoder }
        , Task.perform GotViewport Browser.Dom.getViewport
        , loadArticle model
        ]
    )


loadArticle : Model -> Cmd Msg
loadArticle model =
    case model.route of
        ArticleView id ->
            Http.get
                { url = "/data/pages/" ++ id ++ "." ++ I18n.code model.lang ++ ".json"
                , expect = Http.expectJson GotArticle Data.articleDecoder
                }

        MapView ->
            Cmd.none


{-| The window is [w] by [h]: size the map and the info boxes for it (MP-5). -}
resized : Float -> Float -> Model -> Model
resized w h model =
    let
        sz =
            MapSize.sizes w h
    in
    { model | width = w, height = sz.map, boxHeight = sz.box }


{-| Fit the whole map into the visible area: the layout is reshaped to the area's shape (clear of the floating controls
at the top and the legend at the bottom), then zoomed and centred to fill it. -}
fit : Model -> Model
fit model =
    let
        ( top, bottom ) =
            MapSize.insets model.width

        areaHeight =
            max 100 (model.height - top - bottom)

        shaped =
            Layout.matchAspect (model.width / areaHeight) model.layout

        xs =
            Dict.values shaped |> List.map Tuple.first

        ys =
            Dict.values shaped |> List.map Tuple.second

        ( minX, maxX ) =
            ( List.minimum xs |> Maybe.withDefault -100, List.maximum xs |> Maybe.withDefault 100 )

        ( minY, maxY ) =
            ( List.minimum ys |> Maybe.withDefault -100, List.maximum ys |> Maybe.withDefault 100 )

        k =
            clamp 0.15 1.6 (min (model.width / (maxX - minX + 140)) (areaHeight / (maxY - minY + 90)))
    in
    { model
        | positions = shaped
        , zoom =
            Zoom.init { width = model.width, height = model.height }
                |> Zoom.scaleExtent 0.1 6
                |> Zoom.setTransform Zoom.instantly
                    { scale = k
                    , translate = { x = model.width / 2 - k * (minX + maxX) / 2, y = top + areaHeight / 2 - k * (minY + maxY) / 2 }
                    }
    }


centreOn : String -> Model -> Model
centreOn id model =
    case Dict.get id model.positions of
        Just ( x, y ) ->
            let
                k =
                    max 1.1 (Zoom.asRecord model.zoom).scale
            in
            { model
                | zoom =
                    Zoom.setTransform (Zoom.animatedAround ( model.width / 2, model.height / 2 ))
                        { scale = k, translate = { x = model.width / 2 - k * x, y = model.height / 2 - k * y } }
                        model.zoom
            }

        Nothing ->
            model


currentSuggestions : Model -> List Data.Node
currentSuggestions model =
    case model.graph of
        Loaded g ->
            Search.suggestions model.lang 8 model.query g.nodes

        _ ->
            []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested (Browser.Internal url) ->
            if String.startsWith "/logout" url.path || String.startsWith "/auth" url.path then
                ( model, Nav.load (Url.toString url) )

            else
                ( model, Nav.pushUrl model.key (Url.toString url) )

        UrlRequested (Browser.External href) ->
            ( model, Nav.load href )

        UrlChanged url ->
            let
                m =
                    { model | route = Route.fromUrl url, article = Loading, step = 0, suggestionsOpen = False }
            in
            ( m, Cmd.batch [ loadArticle m, Task.perform (always NoOp) (Browser.Dom.setViewport 0 0) ] )

        GotGraph (Ok g) ->
            ( fit { model | graph = Loaded g, layout = Layout.compute g }, Cmd.none )

        GotGraph (Err _) ->
            ( { model | graph = Failed }, Cmd.none )

        GotArticle (Ok art) ->
            ( { model | article = Loaded art }, Cmd.none )

        GotArticle (Err _) ->
            ( { model | article = Failed }, Cmd.none )

        GotViewport vp ->
            ( fit (resized vp.viewport.width vp.viewport.height model), Cmd.none )

        Resized w h ->
            ( fit (resized (toFloat w) (toFloat h) model), Cmd.none )

        Hover id ->
            ( { model | hovered = Just id, focused = Just id }, Cmd.none )

        Unhover ->
            ( { model | hovered = Nothing }, Cmd.none )

        OpenNode id ->
            ( model, Nav.pushUrl model.key (Route.toPath (ArticleView id)) )

        QueryChanged q ->
            ( { model | query = q, suggestionIndex = 0, suggestionsOpen = True }, Cmd.none )

        SearchKey key ->
            let
                list =
                    currentSuggestions model

                n =
                    List.length list
            in
            case key of
                "ArrowDown" ->
                    ( { model | suggestionIndex = modBy (max 1 n) (model.suggestionIndex + 1), suggestionsOpen = True }, Cmd.none )

                "ArrowUp" ->
                    ( { model | suggestionIndex = modBy (max 1 n) (model.suggestionIndex - 1 + n) }, Cmd.none )

                "Enter" ->
                    case list |> List.drop model.suggestionIndex |> List.head of
                        Just node ->
                            update (PickSuggestion node.id) model

                        Nothing ->
                            ( model, Cmd.none )

                "Escape" ->
                    ( { model | suggestionsOpen = False }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        PickSuggestion id ->
            let
                m =
                    { model | query = "", suggestionsOpen = False, focused = Just id, project = Nothing, month = Nothing }
            in
            case model.route of
                MapView ->
                    ( centreOn id m, Cmd.none )

                ArticleView _ ->
                    ( m, Nav.pushUrl model.key (Route.toPath (ArticleView id)) )

        CloseSuggestions ->
            ( { model | suggestionsOpen = False }, Cmd.none )

        SetLang c ->
            let
                m =
                    { model | lang = I18n.fromCode c }
            in
            ( m, Cmd.batch [ saveLang c, loadArticle m ] )

        SetProject p ->
            ( { model
                | project =
                    if p == "" then
                        Nothing

                    else
                        Just p
              }
            , Cmd.none
            )

        SetMonth idx ->
            let
                stops =
                    case model.graph of
                        Loaded g ->
                            Filter.days g.nodes

                        _ ->
                            []

                i =
                    String.toInt idx |> Maybe.withDefault 0
            in
            ( { model
                | month =
                    if i >= List.length stops - 1 then
                        Nothing

                    else
                        stops |> List.drop i |> List.head
              }
            , Cmd.none
            )

        ZoomMsg z ->
            ( { model | zoom = Zoom.update z model.zoom }, Cmd.none )

        StepTo i ->
            ( { model | step = max 0 i }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Zoom.subscriptions model.zoom ZoomMsg
        , Browser.Events.onResize Resized
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        s =
            I18n.strings model.lang
    in
    { title =
        case ( model.route, model.article ) of
            ( ArticleView _, Loaded art ) ->
                art.title ++ " · Wiki"

            _ ->
                "Wiki"
    , body =
        [ div [ A.class ("app " ++ routeClass model.route) ]
            [ topBar model
            , case model.graph of
                Loading ->
                    div [ A.class "status" ] [ text s.loading ]

                Failed ->
                    div [ A.class "status" ] [ text s.loadError ]

                Loaded g ->
                    case model.route of
                        MapView ->
                            mapScreen model g

                        ArticleView _ ->
                            case model.article of
                                Loading ->
                                    div [ A.class "status" ] [ text s.loading ]

                                Failed ->
                                    div [ A.class "status" ] [ text s.loadError ]

                                Loaded art ->
                                    ArticleView.view model.lang g model.step art
            ]
        ]
    }


routeClass : Route -> String
routeClass route =
    case route of
        MapView ->
            "on-map"

        ArticleView _ ->
            "on-article"


topBar : Model -> Html Msg
topBar model =
    let
        s =
            I18n.strings model.lang

        suggestions =
            currentSuggestions model
    in
    header [ A.class "topbar" ]
        [ a [ A.class "brand", A.href "/" ]
            [ span [ A.class "brand-dot" ] []
            , text
                (case model.route of
                    MapView ->
                        "Wiki"

                    ArticleView _ ->
                        s.backToMap
                )
            ]
        , div [ A.class "search" ]
            [ input
                [ A.type_ "search"
                , A.placeholder s.search
                , A.value model.query
                , A.attribute "aria-label" s.search
                , A.attribute "autocomplete" "off"
                , E.onInput QueryChanged
                , E.on "keydown" (D.map SearchKey (D.field "key" D.string))
                , E.onBlur CloseSuggestions
                ]
                []
            , if model.suggestionsOpen && model.query /= "" then
                ul [ A.class "suggestions", A.attribute "role" "listbox" ]
                    (if List.isEmpty suggestions then
                        [ li [ A.class "none" ] [ text s.noResults ] ]

                     else
                        List.indexedMap (suggestionView model) suggestions
                    )

              else
                text ""
            ]
        , a [ A.class "glossary", A.href "/p/glossary" ] [ text s.glossary ]
        , select [ A.class "lang", E.onInput SetLang, A.attribute "aria-label" "Language" ]
            (List.map
                (\l -> option [ A.value (I18n.code l), A.selected (l == model.lang) ] [ text (I18n.label l) ])
                I18n.all
            )
        , a [ A.class "logout", A.href "/logout", A.attribute "data-native" "1" ] [ text s.logout ]
        ]


suggestionView : Model -> Int -> Data.Node -> Html Msg
suggestionView model i node =
    let
        graphKinds =
            case model.graph of
                Loaded g ->
                    Data.kindColour g node.kind

                _ ->
                    "#888"
    in
    li
        [ A.classList [ ( "sel", i == model.suggestionIndex ) ]
        , E.preventDefaultOn "mousedown" (D.succeed ( PickSuggestion node.id, True ))
        , A.attribute "role" "option"
        ]
        [ span [ A.class "sdot", A.style "background" graphKinds ] []
        , span [ A.class "stitle" ] [ text (Data.title model.lang node) ]
        , span [ A.class "skind" ]
            [ text
                (if node.project == "none" then
                    node.kind

                 else
                    node.kind ++ " · " ++ node.project
                )
            ]
        ]


mapScreen : Model -> Graph -> Html Msg
mapScreen model g =
    let
        s =
            I18n.strings model.lang

        visibleIds =
            Filter.visible model.project model.month g

        active =
            case model.hovered of
                Just h ->
                    Just h

                Nothing ->
                    model.focused

        stops =
            Filter.days g.nodes

        stopIndex =
            case model.month of
                Nothing ->
                    List.length stops - 1

                Just m ->
                    stops |> List.indexedMap Tuple.pair |> List.filter (\( _, x ) -> x == m) |> List.head |> Maybe.map Tuple.first |> Maybe.withDefault 0

        projects =
            g.nodes |> List.filter (\n -> n.kind == "project") |> List.sortBy (Data.title model.lang)

        focusInfo =
            active |> Maybe.andThen (Data.nodeById g) |> Maybe.map (MapView.info model.lang g)
    in
    div [ A.class "map-screen" ]
        [ div [ A.class "map-wrap" ]
            [ MapView.map model.lang g model.positions model.zoom model.width model.height visibleIds active
            , div [ A.class "controls" ]
                [ select [ E.onInput SetProject, A.attribute "aria-label" s.project ]
                    (option [ A.value "" ] [ text s.allProjects ]
                        :: List.map (\p -> option [ A.value p.id, A.selected (model.project == Just p.id) ] [ text (Data.title model.lang p) ]) projects
                    )
                , if List.length stops > 1 then
                    label [ A.class "timeline" ]
                        [ span [] [ text (s.timeline ++ " " ++ Maybe.withDefault "—" (model.month |> Maybe.map identity |> orLast stops)) ]
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
            , legend model g
            ]
        , div [ A.class "focus-title" ]
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
                                            [ Data.nodeById g n.project |> Maybe.map (Data.title model.lang) |> Maybe.withDefault n.project ]
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
        , MapView.infoBoxes model.lang model.boxHeight focusInfo
        ]


orLast : List String -> Maybe String -> Maybe String
orLast stops m =
    case m of
        Just x ->
            Just x

        Nothing ->
            List.reverse stops |> List.head


legend : Model -> Graph -> Html Msg
legend model g =
    let
        used =
            g.nodes |> List.map .kind |> Set.fromList
    in
    div [ A.class "legend" ]
        (g.kinds
            |> List.filter (\k -> Set.member k.name used)
            |> List.map (\k -> span [ A.class "lg-item", A.title k.description ] [ span [ A.class "sdot", A.style "background" k.colour ] [], text k.name ])
        )
