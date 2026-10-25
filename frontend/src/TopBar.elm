module TopBar exposing (currentSuggestions, topBar)

{-| The bar at the top of every screen: on a desktop the brand, the search field, glossary, language and sign-out; on a
phone a search pill with the menu inside it (MB-1). -}

import Data
import Html exposing (Html, a, button, div, header, input, li, option, select, span, text, ul)
import Html.Attributes as A
import Html.Events as E
import I18n
import Json.Decode as D
import MapSize
import Route exposing (Route(..))
import Search
import Types exposing (Load(..), Model, Msg(..))


currentSuggestions : Model -> List Data.Node
currentSuggestions model =
    case model.graph of
        Loaded g ->
            Search.suggestions model.lang 8 model.query g.nodes

        _ ->
            []


topBar : Model -> Html Msg
topBar model =
    let
        s =
            I18n.strings model.lang
    in
    if MapSize.isPhone model.width then
        phoneBar model

    else
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
            , searchBox model
            , a [ A.class "glossary", A.href "/p/glossary" ] [ text s.glossary ]
            , langSelect model
            , a [ A.class "logout", A.href "/logout", A.attribute "data-native" "1" ] [ text s.logout ]
            ]


{-| The phone's top bar (MB-1): a search pill with the menu button inside it, as in Google Maps; on an article page a
back arrow to the map comes first, as in the Wikipedia app. The glossary, language and sign-out sit in the menu. -}
phoneBar : Model -> Html Msg
phoneBar model =
    let
        s =
            I18n.strings model.lang
    in
    header [ A.class "topbar phone-bar" ]
        [ div [ A.class "pill-bar" ]
            ((case model.route of
                ArticleView _ ->
                    [ a [ A.class "back-btn", A.href "/", A.attribute "aria-label" s.backToMap ] [ text "←" ] ]

                MapView ->
                    []
             )
                ++ [ button [ A.class "menu-btn", E.onClick ToggleMenu, A.attribute "aria-label" s.menu, A.attribute "aria-expanded" (boolAttr model.menuOpen) ] [ text "☰" ]
                   , searchBox model
                   ]
            )
        , if model.menuOpen then
            div [ A.class "menu-panel" ]
                [ a [ A.href "/" ] [ text "Map" ]
                , a [ A.href "/p/glossary" ] [ text s.glossary ]
                , langSelect model
                , a [ A.href "/logout", A.attribute "data-native" "1" ] [ text s.logout ]
                ]

          else
            text ""
        ]


boolAttr : Bool -> String
boolAttr b =
    if b then
        "true"

    else
        "false"


langSelect : Model -> Html Msg
langSelect model =
    select [ A.class "lang", E.onInput SetLang, A.attribute "aria-label" "Language" ]
        (List.map
            (\l -> option [ A.value (I18n.code l), A.selected (l == model.lang) ] [ text (I18n.label l) ])
            I18n.all
        )


searchBox : Model -> Html Msg
searchBox model =
    let
        s =
            I18n.strings model.lang

        suggestions =
            currentSuggestions model
    in
    div [ A.class "search" ]
        [ input
            [ A.type_ "search"
            , A.id "search-input"
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
