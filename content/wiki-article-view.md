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
sources: [wiki:frontend/src/ArticleView.elm, wiki:frontend/src/WikiText.elm]
reviewed: 2026-10-22T16:33Z
---

## What it is
The article view is the full page of one concept, laid out like Wikipedia (option A of the design mockups).

## What it does
It shows the title and kind, the lead paragraph, an infobox (kind, project, status, location, since and until dates, sources, memory entries) with the pipeline strip (what feeds it → it → who receives its output) and a small map of the connected pages, then the sections with translated headings, and the history of the page from git. A process page (one with a Steps section, such as a skill or a procedure) also gets a step-through diagram: numbered dots, the current step lit, its text and the pages it involves, with Previous and Next buttons.

## How it does it
The Markdown text is rendered with elm-markdown after the `[[id]]` links are rewritten to `/p/<id>` (requirement MP-3); links to other websites open in a new tab (MP-8). It shows a notice when a page has no translation yet or may be stale.

## Where it sits in the pipeline
Inside the [[wiki-frontend]], at `/p/<id>`.

## Who receives its output
The [[wiki-frontend]].
