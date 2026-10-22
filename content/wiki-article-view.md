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
---

## What it is
The full page of one concept, Wikipedia-style (option A of the design mockups).

## What it does
Title and kind, the lead paragraph, an infobox (kind, project, status, location, since/until, sources, memory entries) with the pipeline strip (what feeds it → it → who receives its output) and a small map of connected pages, then the sections with translated headings, and the page's history from git. Process pages get a step-through diagram: numbered dots, the current step lit, its text and the pages it involves, with Previous/Next.

## How it does it
Markdown rendered with elm-markdown after `[[id]]` links are rewritten to `/p/<id>` (MP-3). Shows a notice when a page has no translation yet or may be stale.

## Where it sits in the pipeline
Inside [[wiki-frontend]], at `/p/<id>`.

## Who receives its output
[[wiki-frontend]].
