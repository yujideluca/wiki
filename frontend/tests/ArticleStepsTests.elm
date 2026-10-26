module ArticleStepsTests exposing (tests)

import ArticleView
import Data
import Expect
import I18n exposing (Lang(..))
import Set
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


article : Data.Article
article =
    { id = "example-skill"
    , lang = "en"
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
    { nodes = [], edges = [], kinds = [] }


-- REQ AR-1
tests : Test
tests =
    describe "REQ AR-1: skill steps appear only in the styled box"
        [ test "desktop and expanded phone sections have one stepper and no repeated list in every language" <|
            \_ ->
                [ ( En, False ), ( En, True ), ( De, False ), ( De, True ), ( PtBr, False ), ( PtBr, True ) ]
                    |> List.map
                        (\( lang, phone ) ->
                            \_ ->
                                ArticleView.view lang graph 0 phone (Set.singleton "steps") article
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
                ArticleView.view En graph 1 False Set.empty article
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "sec-steps" ]
                    |> Expect.all
                        [ Query.has [ Selector.text "Second instruction." ]
                        , Query.hasNot [ Selector.text "First instruction." ]
                        ]
        , test "other page kinds retain their existing steps presentation" <|
            \_ ->
                ArticleView.view En graph 0 False Set.empty { article | kind = "process" }
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "sec-steps" ]
                    |> Query.findAll [ Selector.tag "ol" ]
                    |> Query.count (Expect.equal 1)
        ]
