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
import Lens exposing (Lens)
import MapCamera
import MapSize
import MapView
import Motion
import Route exposing (Route(..))
import Search
import Set exposing (Set)
import Task
import Touch
import TopBar
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
            , sim = Nothing
            , positions = Dict.empty
            , zoom = Zoom.init { width = 800, height = 500 }
            , fitScale = 1
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
            , selected = Nothing
            , menuOpen = False
            , openSecs = Set.empty
            , motion = Dict.empty
            , adj = Dict.empty
            , moving = False
            , drag = Nothing
            , justDragged = False
            , gesture = Touch.Idle
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
                    { model | route = Route.fromUrl url, article = Loading, step = 0, suggestionsOpen = False, selected = Nothing, menuOpen = False, openSecs = Set.empty }
            in
            ( m, Cmd.batch [ loadArticle m, Task.perform (always NoOp) (Browser.Dom.setViewport 0 0) ] )

        GotGraph (Ok g) ->
            -- the layout is computed a few steps per frame (LY-1), so a slow phone keeps answering meanwhile
            ( { model | graph = Loaded g, layout = Dict.empty, sim = Just (Layout.start g), adj = Motion.adjacency g.edges, moving = True }, Cmd.none )

        GotGraph (Err _) ->
            ( { model | graph = Failed }, Cmd.none )

        GotArticle (Ok art) ->
            ( { model | article = Loaded art }, Cmd.none )

        GotArticle (Err _) ->
            ( { model | article = Failed }, Cmd.none )

        GotViewport vp ->
            ( MapCamera.reflow model (MapCamera.fit (MapCamera.resized vp.viewport.width vp.viewport.height model)), Cmd.none )

        Resized w h ->
            if MapSize.isPhone model.width && toFloat w == model.width && model.graph /= Loading then
                -- on a phone only the height changes when the keyboard or the address bar comes and goes: the view stays
                ( MapCamera.resized (toFloat w) (toFloat h) model, Cmd.none )

            else
                ( MapCamera.reflow model (MapCamera.fit (MapCamera.resized (toFloat w) (toFloat h) model)), Cmd.none )

        Hover id ->
            -- a tap also sends mouseover on a phone; there the balloon (SelectNode) is the only preview
            if MapSize.isPhone model.width then
                ( model, Cmd.none )

            else
                ( { model | hovered = Just id, focused = Just id, justDragged = False, moving = True }, Cmd.none )

        Unhover ->
            ( { model | hovered = Nothing, justDragged = False, moving = True }, Cmd.none )

        TouchEvent phase fingers ->
            let
                ( gesture, zoom ) =
                    Touch.step (Lens.invert (MapCamera.lensFor model)) phase fingers model.gesture model.zoom
            in
            ( { model | gesture = gesture, zoom = zoom }, Cmd.none )

        Frame ms ->
            let
                m1 =
                    case model.sim of
                        Just sim ->
                            let
                                next =
                                    Layout.advance
                                        (if MapSize.isPhone model.width then
                                            4

                                         else
                                            40
                                        )
                                        sim
                            in
                            if Layout.isDone next then
                                MapCamera.reflow model (MapCamera.fit { model | layout = Layout.positionsOf next, sim = Nothing })

                            else
                                { model | sim = Just next }

                        Nothing ->
                            model

                ( state, settled ) =
                    Motion.step (min 0.033 (ms / 1000))
                        (if MapSize.isPhone model.width then
                            Motion.phone

                         else
                            Motion.desktop
                        )
                        m1.adj { pulls = MapCamera.hoverPulls m1, pin = MapCamera.pinOf m1 } m1.motion
            in
            ( { m1 | motion = state, moving = not settled || m1.sim /= Nothing }, Cmd.none )

        DragStart id x y ->
            if MapSize.isPhone model.width then
                ( model, Cmd.none )

            else
                ( { model | drag = Just { id = id, startX = x, startY = y, moved = False, target = Dict.get id model.positions |> Maybe.withDefault ( 0, 0 ) }, justDragged = False }, Cmd.none )

        DragMove x y ->
            case model.drag of
                Just d ->
                    ( { model
                        | drag =
                            Just
                                { d
                                    | moved = d.moved || sqrt ((x - d.startX) ^ 2 + (y - d.startY) ^ 2) > 4
                                    , target = Lens.unproject model.zoom (Lens.invert (MapCamera.lensFor model) ( x, y ))
                                }
                        , moving = True
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        DragEnd ->
            ( { model | drag = Nothing, justDragged = (model.drag |> Maybe.map .moved |> Maybe.withDefault False), moving = True }, Cmd.none )

        OpenNode id ->
            if model.justDragged then
                ( { model | justDragged = False }, Cmd.none )

            else if MapSize.isPhone model.width then
                update (SelectNode id) model

            else
                ( model, Nav.pushUrl model.key (Route.toPath (ArticleView id)) )

        SelectNode id ->
            ( MapCamera.centreOn id { model | selected = Just id, focused = Just id, menuOpen = False, suggestionsOpen = False, moving = True }, Cmd.none )

        CloseSheet ->
            ( { model | selected = Nothing, moving = True }, Cmd.none )

        ToggleMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        ToggleSection key ->
            ( { model
                | openSecs =
                    if Set.member key model.openSecs then
                        Set.remove key model.openSecs

                    else
                        Set.insert key model.openSecs
              }
            , Cmd.none
            )

        QueryChanged q ->
            ( { model | query = q, suggestionIndex = 0, suggestionsOpen = True }, Cmd.none )

        SearchKey key ->
            let
                list =
                    TopBar.currentSuggestions model

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
                    { model
                        | query = ""
                        , suggestionsOpen = False
                        , focused = Just id
                        , selected =
                            if MapSize.isPhone model.width then
                                Just id

                            else
                                model.selected
                        , menuOpen = False
                        , moving = True
                        , project = Nothing
                        , month = Nothing
                    }
            in
            case model.route of
                MapView ->
                    -- on a phone the keyboard would cover the balloon: let the search field go
                    ( MapCamera.centreOn id m, Task.attempt (always NoOp) (Browser.Dom.blur "search-input") )

                ArticleView _ ->
                    ( m, Cmd.batch [ Nav.pushUrl model.key (Route.toPath (ArticleView id)), Task.attempt (always NoOp) (Browser.Dom.blur "search-input") ] )

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
        , if model.moving || model.sim /= Nothing then
            Browser.Events.onAnimationFrameDelta Frame

          else
            Sub.none
        , case model.drag of
            Just _ ->
                Sub.batch
                    [ Browser.Events.onMouseMove (D.map2 DragMove (D.field "clientX" D.float) (D.field "clientY" D.float))
                    , Browser.Events.onMouseUp (D.succeed DragEnd)
                    ]

            Nothing ->
                Sub.none
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
            [ TopBar.topBar model
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
                                    ArticleView.view model.lang g model.step (MapSize.isPhone model.width) model.openSecs art
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


mapScreen : Model -> Graph -> Html Msg
mapScreen model g =
    let
        s =
            I18n.strings model.lang

        phone =
            MapSize.isPhone model.width

        active =
            if phone then
                model.selected

            else
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
        (div [ A.class "map-wrap" ]
            [ MapView.map model.lang g (Motion.apply model.motion model.positions) model.positions model.zoom (MapCamera.lensFor model) model.width model.height model.project model.month active
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
            , if model.sim /= Nothing then
                div [ A.class "layout-wait" ] [ text s.loading ]

              else
                text ""
            ]
            :: (if phone then
                    [ case active |> Maybe.andThen (Data.nodeById g) of
                        Just n ->
                            MapView.sheet model.lang g n

                        Nothing ->
                            div [ A.class "tap-hint" ] [ text s.tapHint ]
                    ]

                else
                    desktopLower model g active focusInfo
               )
        )


desktopLower : Model -> Graph -> Maybe String -> Maybe MapView.Info -> List (Html Msg)
desktopLower model g active focusInfo =
    let
        s =
            I18n.strings model.lang
    in
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
