port module Main exposing (main)

import ArticleView
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Data exposing (Graph)
import Dict
import Filter
import FlowView
import Html exposing (Html, a, div, text)
import Html.Attributes as A
import Html.Events as E
import Http
import I18n exposing (Lang)
import Json.Decode as D
import Layout
import Globe
import MapCamera
import MapGeometry
import MapSize
import Motion
import Process
import Route exposing (Route(..))
import Search
import Set exposing (Set)
import Task
import Touch
import TopBar
import MapScreen
import Types exposing (Load(..), Model, Msg(..))
import Url exposing (Url)


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
            , sphere = Dict.empty
            , view = { lam = 0, beta = 0, z = 1 }
            , pan = Nothing
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
            , statics = MapGeometry.emptyStatics
            , geometry = MapGeometry.emptyGeometry
            , motion = Motion.rest
            , adj = Motion.noAdjacency
            , moving = False
            , drag = Nothing
            , justDragged = False
            , pressed = Nothing
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


{-| A diagram wider than its column is scrolled to its middle, where the top box sits, instead of to its left edge.
The charts are drawn a moment after the article arrives or a section opens, hence the short wait (PJ-3). -}
centreCharts : Cmd Msg
centreCharts =
    let
        centre domId =
            Browser.Dom.getViewportOf domId
                |> Task.andThen (\vp -> Browser.Dom.setViewportOf domId ((vp.scene.width - vp.viewport.width) / 2) 0)
                |> Task.onError (\_ -> Task.succeed ())
    in
    Process.sleep 80
        |> Task.andThen (\_ -> Task.sequence (List.map centre FlowView.chartIds.all))
        |> Task.perform (always NoOp)


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
    updateModel msg model |> Tuple.mapFirst MapCamera.refreshGeometry


updateModel : Msg -> Model -> ( Model, Cmd Msg )
updateModel msg model =
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
            ( { model | graph = Loaded g, layout = Dict.empty, sim = Just (Layout.start g), adj = Motion.adjacency (List.map .id g.nodes) g.edges, moving = True }, Cmd.none )

        GotGraph (Err _) ->
            ( { model | graph = Failed }, Cmd.none )

        GotArticle (Ok art) ->
            ( { model | article = Loaded art }, centreCharts )

        GotArticle (Err _) ->
            ( { model | article = Failed }, Cmd.none )

        GotViewport vp ->
            ( MapCamera.resized vp.viewport.width vp.viewport.height model, Cmd.none )

        Resized w h ->
            -- the dots are on the sphere, not in pixels: a new window size moves nothing, the ball is just sized again
            ( MapCamera.resized (toFloat w) (toFloat h) model, Cmd.none )

        Hover id ->
            -- a tap also sends mouseover on a phone; there the balloon (SelectNode) is the only preview
            if MapSize.isPhone model.width then
                ( model, Cmd.none )

            else
                ( { model | hovered = Just id, focused = Just id, justDragged = False, moving = True }, Cmd.none )

        Unhover ->
            -- the dots spring back only if something is displaced; with nothing displaced there is nothing to animate
            ( { model | hovered = Nothing, justDragged = False, moving = not (Motion.isRest model.motion) }, Cmd.none )

        PointerAt x y ->
            -- the dot under a pointer that is only moving (no globe turning, no dot dragged, no fingers): found by the camera maths
            case MapCamera.pointerMoved (model.pan /= Nothing || model.drag /= Nothing || model.gesture /= Touch.Idle) (\_ -> MapCamera.hitAt model x y) model.hovered of
                MapCamera.Light id ->
                    update (Hover id) model

                MapCamera.Unlight ->
                    update Unhover model

                MapCamera.Keep ->
                    ( model, Cmd.none )

        PointerLeft ->
            if model.hovered == Nothing then
                ( model, Cmd.none )

            else
                update Unhover model

        PressAt x y ->
            case MapCamera.hitAt model x y of
                Just id ->
                    update (DragStart id x y) { model | pressed = Just id }

                Nothing ->
                    ( { model | pan = Just ( x, y ), pressed = Nothing }, Cmd.none )

        ClickAt x y ->
            case MapCamera.clickOpens (MapCamera.hitAt model x y) model.pressed of
                Just id ->
                    update (OpenNode id) { model | pressed = Nothing }

                Nothing ->
                    ( model, Cmd.none )

        TouchEvent phase fingers ->
            let
                ( gesture, turned ) =
                    Touch.step (MapCamera.screenOf model) phase fingers model.gesture model.view
            in
            ( { model | gesture = gesture, view = turned }, Cmd.none )

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
                ( { model | drag = Just { id = id, startX = x, startY = y, moved = False, target = ( x, y ) }, justDragged = False }, Cmd.none )

        DragMove x y ->
            case model.drag of
                Just d ->
                    ( { model
                        | drag =
                            Just
                                { d
                                    | moved = d.moved || sqrt ((x - d.startX) ^ 2 + (y - d.startY) ^ 2) > 4
                                    , target = ( x, y )
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
            , if Set.member key model.openSecs then
                Cmd.none

              else
                centreCharts
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

        Wheel x y dy ->
            ( { model | view = Globe.zoom (MapCamera.screenOf model) model.view (e ^ (-dy * 0.002)) ( x, y ) }, Cmd.none )

        PanStart x y ->
            ( { model | pan = Just ( x, y ) }, Cmd.none )

        PanMove x y ->
            case model.pan of
                Just p ->
                    ( { model | pan = Just ( x, y ), view = Globe.dragView (MapCamera.camOf model) p ( x, y ) }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        PanEnd ->
            ( { model | pan = Nothing }, Cmd.none )

        StepTo i ->
            ( { model | step = max 0 i }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize Resized
        , if model.moving || model.sim /= Nothing then
            Browser.Events.onAnimationFrameDelta Frame

          else
            Sub.none
        , case model.pan of
            Just _ ->
                Sub.batch
                    [ Browser.Events.onMouseMove (D.map2 PanMove (D.field "clientX" D.float) (D.field "clientY" D.float))
                    , Browser.Events.onMouseUp (D.succeed PanEnd)
                    ]

            Nothing ->
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
                            MapScreen.view model g

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
