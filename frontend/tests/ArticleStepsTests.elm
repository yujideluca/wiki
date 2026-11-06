module ArticleStepsTests exposing (tests)

import ArticleView
import Data
import Dict
import Html.Attributes
import Expect
import Set
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


article : Data.Article
article =
    { id = "example-skill"
    , title = "Example skill"
    , kind = "skill"
    , project = "none"
    , status = "active"
    , location = Nothing
    , since = "2026-10-25"
    , until = Nothing
    , reviewed = Nothing
    , mayBeStale = False
    , fedBy = []
    , feeds = []
    , memory = []
    , sources = []
    , sections = [ { key = "steps", markdown = "1. First instruction.\n2. Second instruction." } ]
    , history = []
    }


graph : Data.Graph
graph =
    Data.indexed [] [] []


-- REQ AR-1
-- REQ AR-2
tests : Test
tests =
    describe "REQ AR-1: skill steps appear only in the styled box"
        [ test "REQ AR-2: connected pages use full linked titles rather than a crowded graph" <|
            \_ ->
                let
                    node =
                        { id = "long-page", kind = "module", project = "none", status = "active", since = "2026-10-25", until = Nothing, fedBy = [], feeds = [], functions = [], process = False, text = { title = "A connected page with a very long readable title", aliases = [], what = "", does = "" } }

                    connected =
                        Data.indexed [ node ] [ { from = article.id, to = node.id, edgeType = Data.Mentions }, { from = node.id, to = article.id, edgeType = Data.Feeds } ] graph.kinds
                in
                [ False, True ]
                    |> List.map
                        (\phone ->
                            \_ ->
                                ArticleView.view connected 0 phone Set.empty article
                                    |> Query.fromHtml
                                    |> Query.find [ Selector.class "connected-pages" ]
                                    |> Expect.all
                                        [ Query.find [ Selector.class "connected-dot" ] >> Query.has [ Selector.attribute (Html.Attributes.style "background-color" (Data.kindColour connected node.kind)) ]
                                        , Query.findAll [ Selector.tag "li" ] >> Query.count (Expect.equal 1)
                                        , Query.find [ Selector.tag "a", Selector.attribute (Html.Attributes.href "/p/long-page") ] >> Query.has [ Selector.text "A connected page with a very long readable title" ]
                                        ]
                        )
                    |> (\checks -> Expect.all checks ())
        , test "desktop and expanded phone sections have one stepper and no repeated list" <|
            \_ ->
                [ False, True ]
                    |> List.map
                        (\phone ->
                            \_ ->
                                ArticleView.view graph 0 phone (Set.singleton "steps") article
                                    |> Query.fromHtml
                                    |> Query.find [ Selector.class "sec-steps" ]
                                    |> Expect.all
                                        [ Query.findAll [ Selector.class "stepper" ] >> Query.count (Expect.equal 1)
                                        , Query.findAll [ Selector.tag "ol" ] >> Query.count (Expect.equal 0)
                                        , Query.find [ Selector.class "step-card" ] >> Query.has [ Selector.text "First instruction." ]
                                        ]
                        )
                    |> (\checks -> Expect.all checks ())
        , test "the next instruction remains accessible in the styled box" <|
            \_ ->
                ArticleView.view graph 1 False Set.empty article
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "sec-steps" ]
                    |> Expect.all
                        [ Query.has [ Selector.text "Second instruction." ]
                        , Query.hasNot [ Selector.text "First instruction." ]
                        ]
        , test "other page kinds retain their existing steps presentation" <|
            \_ ->
                ArticleView.view graph 0 False Set.empty { article | kind = "process" }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "sec-steps" ]
                    |> Query.findAll [ Selector.tag "ol" ]
                    |> Query.count (Expect.equal 1)
        ]
