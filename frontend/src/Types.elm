module Types exposing (Load(..), Model, Msg(..))

import Browser
import Browser.Dom
import Browser.Navigation as Nav
import Data exposing (Article, Graph)
import Http
import I18n exposing (Lang)
import Layout exposing (Positions)
import Route exposing (Route)
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
    , positions : Positions -- the layout reshaped to the map area (see Layout.matchAspect)
    , zoom : Zoom
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
    | NoOp
