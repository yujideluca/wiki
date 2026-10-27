---
id: wiki-flow-view
title: Flow chart view
aliases: [FlowView, Flow.elm, flowchart]
kind: module
project: wiki
status: active
location: wiki:frontend/src/FlowView.elm
fed_by: []
feeds: [wiki-frontend]
sources: [wiki:frontend/src/Flow.elm, wiki:frontend/src/FlowView.elm, wiki:server/lib/wiki/content/flow.ex, wiki:frontend/tests/FlowTests.elm, wiki:server/test/flow_test.exs, wiki:docs/adr/0007-flow-chart-section.md]
reviewed: 2026-10-27T01:03Z
---

## What it is
The flow chart view turns the `Flow` section of a page into a picture read from top to bottom. A flowchart is a diagram of boxes joined by arrows that shows the order in which things happen.

## What it does
It shows how a big concept is started (the top), what it engages (the boxes in between, with diamonds for questions that split the chain) and what it produces (the double boxes at the bottom). Each box is coloured by the kind of the first page it links to, and the page names inside a box open those pages. A legend under the chart names the shapes. The chart is as wide as it needs to be; on a phone it scrolls sideways inside its box. On the server side, [[wiki-check]] refuses a flow that cannot be drawn sensibly: no starting box or no end product, a box that nothing leads to, a question without labelled answers, a loop, or a link to a page that does not exist.

## How it does it
The text has one line per box (`trigger`, `step`, `decide` or `product`, an id, a label and `| [[page]]` links) and one line per arrow (`a -> b`, or `d -yes-> b` for an answer). It is read twice, by `Wiki.Content.Flow` for the checks and by `Flow.elm` for the drawing, and both are tested on the same example. `Flow.layout` puts every box in a row below the last box that leads to it, adds an invisible stopover in each row that an arrow skips, orders each row by the average place of its neighbours (the barycenter method) and then sets the columns so that connected boxes line up as far as the spacing allows (a least-squares fit called isotonic regression). `FlowView` draws the result as SVG (Scalable Vector Graphics, a picture format made of shapes), with the arrows drawn by `Shape.bumpYCurve` of the elm-visualization library. No layout package is used on purpose: that library has no layered graph layout, and a small outside package that may stop working was judged a bigger risk than about 400 lines of our own code (ADR-0007; an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## Where it sits in the pipeline
Inside the [[wiki-frontend]], called by [[wiki-article-view]] for the section `flow`.

## Who receives its output
[[wiki-article-view]], and through it the reader.

## Functions
- `Flow.parse`: reads the section text into boxes and arrows.
- `Flow.layout`: gives every box its place and every arrow its route.
- `FlowView.view`: draws the chart and its legend.
