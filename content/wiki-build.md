---
id: wiki-build
title: wiki build (content → data)
aliases: [Build, graph.json]
kind: function
project: wiki
status: active
location: wiki:server/lib/wiki/content/build.ex
fed_by: [wiki-content]
feeds: [wiki-cli, wiki-site]
sources: [wiki:server/lib/wiki/content/build.ex, wiki:server/lib/wiki/content/git.ex]
---

## What it is
Turns the content into the data the Elm front end reads (Elixir module `Wiki.Content.Build`), then compiles the front end.

## What it does
Writes `site/data/graph.json` (nodes with their text in all three languages, `feeds` edges and `mentions` edges from links, kinds) and one `site/data/pages/<id>.<lang>.json` per page and language (sections, infobox fields, history). Fills `since` from the first commit of a page's sources, marks off-laptop pages "may be stale" 30 days after review, then runs `elm make --optimize` and copies the static files.

## How it does it
Read-only git calls for dates and history; JSON via Elixir 1.18's built-in `JSON` module.

## Where it sits in the pipeline
Second step of `wiki publish`, after [[wiki-check]].

## Who receives its output
[[wiki-site]].
