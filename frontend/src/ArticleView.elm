module ArticleView exposing (view)

{-| The article page, Wikipedia-style: text on the left, infobox on the right with the pipeline strip
(what feeds it → it → who receives its output) and the list of connected pages. Process pages get a
step-through diagram.
-}

import Data exposing (Article, Graph)
import Dict
import Filter
import FlowView
import Html exposing (Html, a, aside, button, code, div, h1, h2, li, p, section, span, table, td, text, th, tr, ul)
import Html.Attributes as A
import Html.Events as E
import I18n exposing (Lang)
import Set exposing (Set)
import Types exposing (Msg(..))
import WikiText


view : Lang -> Graph -> Int -> Bool -> Set String -> Article -> Html Msg
view lang graph step phone openSecs art =
    let
        s =
            I18n.strings lang

        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id

        body sec =
            if sec.key == "flow" then
                [ FlowView.view lang graph sec.markdown ]

            else if sec.key == "architecture" then
                [ FlowView.viewArchitecture lang graph sec.markdown ]

            else if sec.key == "steps" && art.kind == "skill" then
                [ stepper lang graph step (WikiText.steps sec.markdown) ]

            else
                (if sec.key == "steps" then
                    [ stepper lang graph step (WikiText.steps sec.markdown) ]

                 else
                    []
                )
                    ++ WikiText.toHtml titleOf sec.markdown

        -- On a phone every section starts closed and a tap on its heading opens it, as in Wikipedia's mobile site (MB-4).
        sectionView sec =
            if phone then
                let
                    isOpen =
                        Set.member sec.key openSecs
                in
                section [ A.class ("sec sec-" ++ sec.key ++ " collapsible") ]
                    (h2
                        [ A.class
                            (if isOpen then
                                "open"

                             else
                                ""
                            )
                        ]
                        [ button
                            [ A.class "sec-toggle"
                            , E.onClick (ToggleSection sec.key)
                            , A.attribute "aria-expanded"
                                (if isOpen then
                                    "true"

                                 else
                                    "false"
                                )
                            ]
                            [ text (I18n.sectionHeading lang sec.key) ]
                        ]
                        :: (if isOpen then
                                [ div [ A.class "sec-body" ] (body sec) ]

                            else
                                []
                           )
                    )

            else
                section [ A.class ("sec sec-" ++ sec.key) ]
                    (h2 [] [ text (I18n.sectionHeading lang sec.key) ] :: body sec)

        lead =
            art.sections |> List.filter (\x -> x.key == "what") |> List.head

        rest =
            art.sections |> List.filter (\x -> x.key /= "what")
    in
    div [ A.class "article-page" ]
        [ Html.article [ A.class "article" ]
            ([ h1 [] [ text art.title ]
             , p [ A.class "subtitle" ]
                [ text
                    (if art.project == "none" then
                        art.kind

                     else
                        art.kind ++ " · " ++ titleOf art.project
                    )
                ]
             ]
                ++ (if art.lang /= I18n.code lang then
                        [ p [ A.class "notice" ] [ text s.notTranslated ] ]

                    else
                        []
                   )
                ++ (if art.mayBeStale then
                        [ p [ A.class "notice stale" ] [ text (s.mayBeStale ++ " " ++ Maybe.withDefault "?" art.reviewed) ] ]

                    else
                        []
                   )
                ++ [ infobox lang graph art ]
                ++ (case lead of
                        Just l ->
                            [ div [ A.class "lead" ] (WikiText.toHtml titleOf l.markdown) ]

                        Nothing ->
                            []
                   )
                ++ List.map sectionView rest
                ++ history lang art
            )
        ]


infobox : Lang -> Graph -> Article -> Html Msg
infobox lang graph art =
    let
        s =
            I18n.strings lang

        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id

        row label content =
            tr [] [ th [] [ text label ], td [] content ]

        pageLink id =
            a [ A.href ("/p/" ++ id) ] [ text (titleOf id) ]

        maybeRow label m f =
            case m of
                Just v ->
                    [ row label (f v) ]

                Nothing ->
                    []
    in
    aside [ A.class "infobox" ]
        [ div [ A.class "ib-title" ] [ text art.title ]
        , div [ A.class "ib-kind" ] [ span [ A.class "chip", A.style "--c" (Data.kindColour graph art.kind) ] [ text art.kind ] ]
        , table []
            (row s.project
                [ if art.project == "none" then
                    text "—"

                  else
                    pageLink art.project
                ]
                :: row s.status [ text art.status ]
                :: maybeRow s.location art.location (\l -> [ code [] [ text l ] ])
                ++ [ row s.since [ text art.since ] ]
                ++ maybeRow s.until art.until (\u -> [ text u ])
                ++ (if List.isEmpty art.sources then
                        []

                    else
                        [ row s.sources [ ul [] (List.map (\x -> li [] [ code [] [ text x ] ]) art.sources) ] ]
                   )
                ++ (if List.isEmpty art.memory then
                        []

                    else
                        [ row s.memory [ text (String.join ", " art.memory) ] ]
                   )
            )
        , div [ A.class "ib-head" ] [ text s.pipeline ]
        , pipelineStrip lang graph art
        , div [ A.class "ib-head" ] [ text s.neighbours ]
        , connectedPages lang graph art.id
        ]


{-| inputs → this → outputs, as small boxes with arrows.
-}
pipelineStrip : Lang -> Graph -> Article -> Html Msg
pipelineStrip lang graph art =
    let
        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id

        column ids cls =
            div [ A.class ("pl-col " ++ cls) ]
                (if List.isEmpty ids then
                    [ span [ A.class "pl-none" ] [ text "·" ] ]

                 else
                    List.map (\id -> a [ A.class "pl-box", A.href ("/p/" ++ id) ] [ text (titleOf id) ]) ids
                )
    in
    div [ A.class "pipeline" ]
        [ column art.fedBy "in"
        , span [ A.class "pl-arrow" ] [ text "→" ]
        , div [ A.class "pl-col me" ] [ span [ A.class "pl-box me" ] [ text art.title ] ]
        , span [ A.class "pl-arrow" ] [ text "→" ]
        , column art.feeds "out"
        ]


{-| Full page names remain readable even when a page has many neighbours.
-}
connectedPages : Lang -> Graph -> String -> Html Msg
connectedPages lang graph id =
    let
        neighbours =
            Filter.neighbours graph.edges id
                |> Set.toList
                |> List.filterMap (Data.nodeById graph)
                |> List.sortBy (Data.title lang >> String.toLower)

        item node =
            li []
                [ a [ A.href ("/p/" ++ node.id), A.style "--c" (Data.kindColour graph node.kind) ]
                    [ span [ A.class "connected-dot", A.attribute "aria-hidden" "true" ] []
                    , span [ A.class "connected-title" ] [ text (Data.title lang node) ]
                    , span [ A.class "connected-kind" ] [ text node.kind ]
                    ]
                ]
    in
    ul [ A.class "connected-pages" ] (List.map item neighbours)


{-| Step-through diagram for process pages: the steps as a chain, the current one lit, with its text and
the pages it involves.
-}
stepper : Lang -> Graph -> Int -> List String -> Html Msg
stepper lang graph current steps =
    let
        s =
            I18n.strings lang

        n =
            List.length steps

        cur =
            clamp 0 (max 0 (n - 1)) current

        titleOf id =
            Data.nodeById graph id |> Maybe.map (Data.title lang) |> Maybe.withDefault id

        currentText =
            steps |> List.drop cur |> List.head |> Maybe.withDefault ""
    in
    if n == 0 then
        text ""

    else
        div [ A.class "stepper" ]
            [ div [ A.class "chain" ]
                (List.indexedMap
                    (\i _ ->
                        button
                            [ A.class
                                ("dot-step"
                                    ++ (if i == cur then
                                            " on"

                                        else if i < cur then
                                            " done"

                                        else
                                            ""
                                       )
                                )
                            , E.onClick (StepTo i)
                            , A.attribute "aria-label" (s.step ++ " " ++ String.fromInt (i + 1))
                            ]
                            [ text (String.fromInt (i + 1)) ]
                    )
                    steps
                )
            , div [ A.class "step-card" ]
                (div [ A.class "step-label" ] [ text (s.step ++ " " ++ String.fromInt (cur + 1) ++ " / " ++ String.fromInt n) ]
                    :: WikiText.toHtml titleOf currentText
                    ++ [ div [ A.class "step-involves" ]
                            (List.map
                                (\id ->
                                    a [ A.class "chip", A.href ("/p/" ++ id), A.style "--c" (Data.nodeById graph id |> Maybe.map (.kind >> Data.kindColour graph) |> Maybe.withDefault "#888") ]
                                        [ text (titleOf id) ]
                                )
                                (WikiText.linkIds currentText)
                            )
                       ]
                )
            , div [ A.class "step-nav" ]
                [ button [ E.onClick (StepTo (cur - 1)), A.disabled (cur == 0) ] [ text s.previous ]
                , button [ E.onClick (StepTo (cur + 1)), A.disabled (cur >= n - 1) ] [ text s.next ]
                ]
            ]


history : Lang -> Article -> List (Html Msg)
history lang art =
    if List.isEmpty art.history then
        []

    else
        [ section [ A.class "sec history" ]
            [ h2 [] [ text (I18n.strings lang).history ]
            , ul [] (List.map (\h -> li [] [ span [ A.class "date" ] [ text h.date ], text (" " ++ h.subject) ]) art.history)
            ]
        ]
