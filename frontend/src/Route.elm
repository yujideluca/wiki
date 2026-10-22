module Route exposing (Route(..), fromUrl, toPath)

import Url exposing (Url)
import Url.Parser as P exposing ((</>))


type Route
    = MapView
    | ArticleView String


fromUrl : Url -> Route
fromUrl url =
    P.parse (P.oneOf [ P.map MapView P.top, P.map ArticleView (P.s "p" </> P.string) ]) url
        |> Maybe.withDefault MapView


toPath : Route -> String
toPath route =
    case route of
        MapView ->
            "/"

        ArticleView id ->
            "/p/" ++ id
