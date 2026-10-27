---
id: wiki-article-view
title: Article view
aliases: [ArticleView, infobox, pipeline strip]
kind: function
project: wiki
status: active
location: wiki:frontend/src/ArticleView.elm
fed_by: []
feeds: [wiki-frontend]
sources: [wiki:frontend/src/ArticleView.elm, wiki:frontend/src/WikiText.elm, wiki:frontend/tests/ArticleStepsTests.elm, wiki:frontend/static/style.css]
reviewed: 2026-10-27T02:25Z
---

## What it is
The article view is the full page of one concept, laid out like Wikipedia (option A of the design mockups).

## What it does
It shows the title and kind, the lead paragraph, an infobox (kind, project, status, location, since and until dates, sources, memory entries) with the pipeline strip (what feeds it → it → who receives its output) and an alphabetical list of connected pages with full linked titles, colored kind markers and kind labels. Long titles wrap onto the next line, then the sections with translated headings, and the history of the page from git. A process page (one with a Steps section, such as a skill or a procedure) also gets a step-through diagram: numbered dots, the current step lit, its text and the pages it involves, with Previous and Next buttons. The ring around the lit step (its glow and its slight growth) is kept whole by padding around the row of dots.

On a phone (a window 760 pixels wide or less) the page follows the layout of Wikipedia's mobile site: a bar at the top with a back arrow to the map, the menu button and the search field; then the title, the lead paragraph and the infobox in one column; every other section starts closed and opens when its heading is tapped (`ArticleView` hides the text of a closed section). A page with a Flow section shows it as a flowchart under the lead paragraph: a pill for what starts the chain, boxes for steps, a diamond for a question and a double box for an end product, coloured by the kind of the page they link to, with a legend underneath ([[wiki-flow-view]]).

## How it does it
The Markdown text is rendered with elm-markdown after the `[[id]]` links are rewritten to `/p/<id>` (requirement MP-3); links to other websites open in a new tab (MP-8). It shows a notice when a page has no translation yet or may be stale.

## Where it sits in the pipeline
Inside the [[wiki-frontend]], at `/p/<id>`.

## Who receives its output
The [[wiki-frontend]].

## Notes

On skill pages, the Steps section displays only the styled interactive steps box. The repeated plain-text list underneath is omitted. Previous and Next still expose every numbered step, and the full original skill files remain in Notes. This applies on desktop and in expanded phone sections, in all three languages. Other kinds of page retain their existing display.
