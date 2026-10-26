module Types exposing (Drag, Load(..), Model, Msg(..))

import Browser
import Browser.Dom
import Browser.Navigation as Nav
import Data exposing (Article, Graph)
import Http
import I18n exposing (Lang)
import Layout exposing (Positions)
import Motion
import Touch
import Route exposing (Route)
import Set exposing (Set)
import Url exposing (Url)
import Zoom exposing (OnZoom, Zoom)


type Load a
    = Loading
    | Loaded a
    | Failed


type alias Model =
    { key : Nav.Key
    , lang : Lang
    , route : Route
    , graph : Load Graph
    , layout : Positions -- the force layout as computed, in layout units
    , sim : Maybe Layout.Sim -- the force simulation while it is still running (a few steps per frame)
    , positions : Positions -- the layout reshaped to the map area (see Layout.matchAspect)
    , zoom : Zoom
    , fitScale : Float -- the zoom scale at which the ball fits the free area exactly (see MapCamera.growth)
    , width : Float
    , height : Float
    , boxHeight : Maybe Float -- height of the info boxes under the map; Nothing where they size themselves
    , hovered : Maybe String
    , focused : Maybe String
    , query : String
    , suggestionIndex : Int
    , suggestionsOpen : Bool
    , project : Maybe String
    , month : Maybe String
    , article : Load Article
    , step : Int
    , selected : Maybe String -- phone: the node whose balloon is open
    , menuOpen : Bool -- phone: the menu under the search bar
    , openSecs : Set String -- phone: article sections opened by a tap (all start closed)
    , motion : Motion.State -- the elastic displacement of every dot on top of its resting place in `positions`
    , adj : Motion.Adjacency
    , moving : Bool -- the dots are not at rest: ask for animation frames
    , drag : Maybe Drag
    , justDragged : Bool -- a click that ends a drag must not open the page
    , gesture : Touch.Gesture -- the fingers on the map
    }


{-| A dot held by the mouse. It is only pinned once the pointer has moved a few pixels, so a plain click still opens the page. -}
type alias Drag =
    { id : String
    , startX : Float
    , startY : Float
    , moved : Bool
    , target : ( Float, Float ) -- where the pointer is, in map coordinates
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | GotGraph (Result Http.Error Graph)
    | GotArticle (Result Http.Error Article)
    | GotViewport Browser.Dom.Viewport
    | Resized Int Int
    | Hover String
    | Unhover
    | OpenNode String
    | QueryChanged String
    | SearchKey String
    | PickSuggestion String
    | CloseSuggestions
    | SetLang String
    | SetProject String
    | SetMonth String
    | ZoomMsg OnZoom
    | StepTo Int
    | SelectNode String
    | CloseSheet
    | ToggleMenu
    | ToggleSection String
    | Frame Float
    | TouchEvent Touch.Phase (List ( Float, Float ))
    | DragStart String Float Float
    | DragMove Float Float
    | DragEnd
    | NoOp
