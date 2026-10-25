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
import MapSize
import MapView
import Motion
import Route exposing (Route(..))
import Search
import Set exposing (Set)
import Task
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
            , selected = Nothing
            , menuOpen = False
            , openSecs = Set.empty
            , motion = Dict.empty
            , adj = Dict.empty
            , moving = False
            , drag = Nothing
            , justDragged = False
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

                -- on a phone the balloon covers the lower half, so the node goes to the upper part
                targetY =
                    if MapSize.isPhone model.width then
                        model.height * 0.3

                    else
                        (lensFor model).cy
            in
            { model
                | zoom =
                    Zoom.setTransform (Zoom.animatedAround ( model.width / 2, model.height / 2 ))
                        { scale = k, translate = { x = model.width / 2 - k * x, y = targetY - k * y } }
                        model.zoom
            }

        Nothing ->
            model


{-| The lens of the map area: centred in what the floating controls leave free, as strong as it is on a desktop and off
on a phone (LN-1). -}
lensFor : Model -> Lens
lensFor model =
    let
        ( top, bottom ) =
            MapSize.insets model.width

        areaHeight =
            max 100 (model.height - top - bottom)
    in
    { cx = model.width / 2
    , cy = top + areaHeight / 2
    , hw = model.width / 2
    , hh = areaHeight / 2
    , strength =
        if MapSize.isPhone model.width then
            0

        else
            1.2
    }


{-| After the layout or the window changed, the dots start where they were on screen and spring to their new places
(DY-4); on the first load they start gathered towards the middle and spring open. -}
reflow : Model -> Model -> Model
reflow old new =
    let
        oldLive =
            Motion.apply old.motion old.positions

        offset ( id, ( bx, by ) ) =
            case Dict.get id oldLive of
                Just w ->
                    let
                        ( x, y ) =
                            Lens.unproject new.zoom (Lens.project old.zoom w)
                    in
                    ( id, ( x - bx, y - by ) )

                Nothing ->
                    ( id, ( -0.55 * bx, -0.55 * by ) )
    in
    { new | motion = Motion.from (Dict.fromList (List.map offset (Dict.toList new.positions))), moving = True }


{-| Where the dots are drawn from. On a phone, once everything has settled, the resting places themselves: the same value
every time, so the map's cached drawing is reused while the map is panned or zoomed. -}
livePositions : Model -> Layout.Positions
livePositions model =
    if MapSize.isPhone model.width && not model.moving then
        model.positions

    else
        Motion.apply model.motion model.positions


{-| Displacements the hovered dot's neighbours are drawn towards: a fifth of the way to it (DY-3). -}
hoverPulls : Model -> Dict.Dict String ( Float, Float )
hoverPulls model =
    case model.hovered |> Maybe.andThen (\h -> Dict.get h model.positions |> Maybe.map (Tuple.pair h)) of
        Just ( h, ( hx, hy ) ) ->
            Dict.get h model.adj
                |> Maybe.withDefault []
                |> List.filterMap
                    (\n -> Dict.get n model.positions |> Maybe.map (\( nx, ny ) -> ( n, ( 0.2 * (hx - nx), 0.2 * (hy - ny) ) )))
                |> Dict.fromList

        Nothing ->
            Dict.empty


{-| The dragged dot is held at the pointer once the pointer has moved. -}
pinOf : Model -> Maybe ( String, ( Float, Float ) )
pinOf model =
    case model.drag of
        Just d ->
            if d.moved then
                Dict.get d.id model.positions |> Maybe.map (\( bx, by ) -> ( d.id, ( Tuple.first d.target - bx, Tuple.second d.target - by ) ))

            else
                Nothing

        Nothing ->
            Nothing


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
            ( reflow model (fit { model | graph = Loaded g, layout = Layout.compute g, adj = Motion.adjacency g.edges }), Cmd.none )

        GotGraph (Err _) ->
            ( { model | graph = Failed }, Cmd.none )

        GotArticle (Ok art) ->
            ( { model | article = Loaded art }, Cmd.none )

        GotArticle (Err _) ->
            ( { model | article = Failed }, Cmd.none )

        GotViewport vp ->
            ( reflow model (fit (resized vp.viewport.width vp.viewport.height model)), Cmd.none )

        Resized w h ->
            if MapSize.isPhone model.width && toFloat w == model.width && model.graph /= Loading then
                -- on a phone only the height changes when the keyboard or the address bar comes and goes: the view stays
                ( resized (toFloat w) (toFloat h) model, Cmd.none )

            else
                ( reflow model (fit (resized (toFloat w) (toFloat h) model)), Cmd.none )

        Hover id ->
            -- a tap also sends mouseover on a phone; there the balloon (SelectNode) is the only preview
            if MapSize.isPhone model.width then
                ( model, Cmd.none )

            else
                ( { model | hovered = Just id, focused = Just id, justDragged = False, moving = True }, Cmd.none )

        Unhover ->
            ( { model | hovered = Nothing, justDragged = False, moving = True }, Cmd.none )

        Frame ms ->
            let
                ( state, settled ) =
                    Motion.step (min 0.033 (ms / 1000)) model.adj { pulls = hoverPulls model, pin = pinOf model } model.motion
            in
            ( { model | motion = state, moving = not settled }, Cmd.none )

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
                                    , target = Lens.unproject model.zoom (Lens.invert (lensFor model) ( x, y ))
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
            ( centreOn id { model | selected = Just id, focused = Just id, menuOpen = False, suggestionsOpen = False }, Cmd.none )

        CloseSheet ->
            ( { model | selected = Nothing }, Cmd.none )

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
                        , project = Nothing
                        , month = Nothing
                    }
            in
            case model.route of
                MapView ->
                    -- on a phone the keyboard would cover the balloon: let the search field go
                    ( centreOn id m, Task.attempt (always NoOp) (Browser.Dom.blur "search-input") )

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
        , if model.moving then
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
            [ MapView.map model.lang g (livePositions model) model.zoom (lensFor model) model.width model.height model.project model.month active
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
