module Types exposing (Drag, Load(..), Model, Msg(..))

import Browser
import Browser.Dom
import Browser.Navigation as Nav
import Data exposing (Article, Graph)
import Http
import Dict exposing (Dict)
import Globe
import Layout exposing (Positions)
import MapGeometry
import Motion
import Touch
import Route exposing (Route)
import Set exposing (Set)
import Url exposing (Url)


type Load a
    = Loading
    | Loaded a
    | Failed


type alias Model =
    { key : Nav.Key
    , route : Route
    , graph : Load Graph
    , layout : Positions -- the force layout as computed, in layout units
    , sim : Maybe Layout.Sim -- the force simulation while it is still running (a few steps per frame)
    , sphere : Dict String Globe.Node -- every dot as a unit vector on the sphere (`Globe.embed`), once per layout
    , view : Globe.View -- the camera: longitude, latitude (north is held up) and zoom
    , pan : Maybe ( Float, Float ) -- the pointer of a drag of the globe itself, at the last event
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
    , statics : MapGeometry.Statics -- the dots and edges, refreshed by `MapCamera.refreshGeometry`
    , geometry : MapGeometry.Geometry -- what is the same while the dots spring about, refreshed likewise
    , motion : Motion.State -- the elastic displacement of every dot on top of its resting place on the sphere, in milliradians east and north (see `MapCamera.mrad`)
    , adj : Motion.Adjacency
    , pressed : Maybe String -- the dot the last mouse press was on (the dots are found by the camera maths, not by discs in the page), so that a click is a click on that dot and not the end of a drag of the globe
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
    , target : ( Float, Float ) -- where the pointer is, in window pixels
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
    | PointerAt Float Float
    | PointerLeft
    | PressAt Float Float
    | ClickAt Float Float
    | OpenNode String
    | QueryChanged String
    | SearchKey String
    | PickSuggestion String
    | CloseSuggestions
    | SetProject String
    | SetMonth String
    | Wheel Float Float Float
    | PanStart Float Float
    | PanMove Float Float
    | PanEnd
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
