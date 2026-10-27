module FlowTests exposing (tests)

import ArticleView
import Data
import Dict
import Expect
import Flow exposing (Role(..))
import FlowLayout
import I18n exposing (Lang(..))
import Set
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


-- the same text as server/test/flow_test.exs, so both parsers are held to one example
sample : String
sample =
    String.join "\n"
        [ "trigger t: Giovanni asks | [[a]]"
        , "step s: Reads the brief | [[b]], [[a]]"
        , "decide d: Did it change a system?"
        , "product p: Page updated"
        , "product q: Nothing to do"
        , ""
        , "t -> s"
        , "s -> d"
        , "d -yes-> p"
        , "d -no-> q"
        ]


-- a chain with a long arrow: t -> a -> b -> p and t2 -> p skipping two rows
long : String
long =
    String.join "\n"
        [ "trigger t: Start"
        , "step a: One"
        , "step b: Two"
        , "product p: End"
        , "t -> a"
        , "a -> b"
        , "b -> p"
        , "t -> p"
        ]


graph : Data.Graph
graph =
    { nodes = [], edges = [], kinds = [] }


article : String -> Data.Article
article markdown =
    { id = "example"
    , lang = "en"
    , title = "Example"
    , kind = "actor"
    , project = "none"
    , status = "active"
    , location = Nothing
    , since = "2026-10-27"
    , until = Nothing
    , reviewed = Nothing
    , mayBeStale = False
    , fedBy = []
    , feeds = []
    , memory = []
    , sources = []
    , sections = [ { key = "flow", markdown = markdown } ]
    , history = []
    }


rowOf : FlowLayout.Layout -> String -> Float
rowOf layout id =
    layout.boxes |> List.filter (\p -> p.box.id == id) |> List.head |> Maybe.map .y |> Maybe.withDefault -1


xOf : FlowLayout.Layout -> String -> Float
xOf layout id =
    layout.boxes |> List.filter (\p -> p.box.id == id) |> List.head |> Maybe.map .x |> Maybe.withDefault -1


-- REQ FL-3
parsing : Test
parsing =
    describe "REQ FL-3: the flow text is read into boxes and arrows"
        [ test "boxes keep their kind, label and page links; arrows keep their label" <|
            \_ ->
                let
                    chart =
                        Flow.parse sample
                in
                Expect.all
                    [ .boxes >> List.map (\b -> ( b.id, b.role )) >> Expect.equal [ ( "t", Trigger ), ( "s", Step ), ( "d", Decide ), ( "p", Product ), ( "q", Product ) ]
                    , .boxes >> List.filter (\b -> b.id == "s") >> List.concatMap .links >> Expect.equal [ "b", "a" ]
                    , .arrows >> List.filter (\a -> a.from == "d" && a.to == "q") >> List.map .label >> Expect.equal [ "no" ]
                    , .arrows >> List.length >> Expect.equal 4
                    ]
                    chart
        ]


-- REQ FL-4
layouts : Test
layouts =
    describe "REQ FL-4: the layout is a top-to-bottom flowchart"
        [ test "every arrow points to a lower row and no two boxes overlap" <|
            \_ ->
                let
                    chart =
                        Flow.parse sample

                    laid =
                        FlowLayout.layout chart

                    lower =
                        chart.arrows |> List.all (\a -> rowOf laid a.to > rowOf laid a.from)

                    overlap p q =
                        p.box.id /= q.box.id && abs (p.x - q.x) < (p.w + q.w) / 2 && abs (p.y - q.y) < (p.h + q.h) / 2

                    clash =
                        laid.boxes |> List.any (\p -> List.any (overlap p) laid.boxes)
                in
                Expect.all
                    [ \_ -> Expect.equal True lower
                    , \_ -> Expect.equal False clash
                    ]
                    ()
        , test "a plain chain stands in one vertical line" <|
            \_ ->
                let
                    laid =
                        FlowLayout.layout (Flow.parse "trigger a: A\nstep b: B\nstep c: C\nproduct d: D\na -> b\nb -> c\nc -> d")
                in
                [ "a", "b", "c", "d" ] |> List.map (xOf laid) |> List.map (\x -> round x) |> Set.fromList |> Set.size |> Expect.equal 1
        , test "an answer of a question sits on each side below it" <|
            \_ ->
                let
                    laid =
                        FlowLayout.layout (Flow.parse sample)
                in
                Expect.all
                    [ \_ -> Expect.lessThan (xOf laid "d") (xOf laid "p")
                    , \_ -> Expect.greaterThan (xOf laid "d") (xOf laid "q")
                    ]
                    ()
        , test "an arrow that skips rows passes a stopover in each row it crosses" <|
            \_ ->
                let
                    laid =
                        FlowLayout.layout (Flow.parse long)

                    skipping =
                        laid.routes |> List.filter (\r -> r.arrow.from == "t" && r.arrow.to == "p") |> List.head
                in
                skipping |> Maybe.map (.points >> List.length) |> Expect.equal (Just 4)
        , test "an answer's label sits beside its own curve, on the side the arrow leans to" <|
            \_ ->
                let
                    laid =
                        FlowLayout.layout (Flow.parse sample)

                    side answer =
                        laid.routes |> List.filter (\r -> r.arrow.label == answer) |> List.map .labelRight
                in
                Expect.all
                    [ \_ -> Expect.equal [ False ] (side "yes")
                    , \_ -> Expect.equal [ True ] (side "no")
                    ]
                    ()
        , test "the same text always gives the same picture" <|
            \_ -> Expect.equal (FlowLayout.layout (Flow.parse sample)) (FlowLayout.layout (Flow.parse sample))
        , test "an arrow back to an earlier box does not hang the layout" <|
            \_ ->
                FlowLayout.layout (Flow.parse "trigger a: A\nstep b: B\nproduct c: C\na -> b\nb -> a\nb -> c")
                    |> .boxes
                    |> List.length
                    |> Expect.equal 3
        ]


-- REQ FL-3
view : Test
view =
    describe "REQ FL-3: the article shows the Flow section as a chart with a legend, in every language"
        [ test "one group per box, one arrow per arrow line, and the legend" <|
            \_ ->
                [ En, De, PtBr ]
                    |> List.map
                        (\lang ->
                            \_ ->
                                ArticleView.view lang graph 0 False Set.empty (article sample)
                                    |> Query.fromHtml
                                    |> Query.find [ Selector.class "sec-flow" ]
                                    |> Expect.all
                                        [ Query.findAll [ Selector.class "fl-group" ] >> Query.count (Expect.equal 5)
                                        , Query.findAll [ Selector.class "fl-edge" ] >> Query.count (Expect.equal 4)
                                        , Query.findAll [ Selector.class "flow-key" ] >> Query.count (Expect.equal 4)
                                        ]
                        )
                    |> (\checks -> Expect.all checks ())
        , test "the section heading is translated" <|
            \_ ->
                [ ( En, "Flow chart" ), ( De, "Flussdiagramm" ), ( PtBr, "Fluxograma" ) ]
                    |> List.map
                        (\( lang, heading ) ->
                            \_ ->
                                ArticleView.view lang graph 0 False Set.empty (article sample)
                                    |> Query.fromHtml
                                    |> Query.find [ Selector.class "sec-flow" ]
                                    |> Query.has [ Selector.text heading ]
                        )
                    |> (\checks -> Expect.all checks ())
        , test "a decision is drawn as a diamond and a product as a double box" <|
            \_ ->
                ArticleView.view En graph 0 False Set.empty (article sample)
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.findAll [ Selector.tag "polygon" ] >> Query.count (Expect.equal 1)
                        , Query.findAll [ Selector.class "fl-inner" ] >> Query.count (Expect.equal 2)
                        ]
        ]


tests : Test
tests =
    describe "flow chart" [ parsing, layouts, view ]
