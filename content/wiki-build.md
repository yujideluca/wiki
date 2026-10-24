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
`wiki build` turns the content into the data that the Elm front end reads (Elixir module `Wiki.Content.Build`), and then compiles the front end. Think of it as the step that prepares the wiki for display.

## What it does
It writes `site/data/graph.json` (the nodes with their text in all three languages, the `feeds` edges, the `mentions` edges drawn from links, and the kinds) and one file `site/data/pages/<id>.<lang>.json` per page and language (sections, infobox fields, history). A page of kind reference (the glossary) can link to any page without drawing edges on the map. It fills in `since` from the first git commit of a page's sources, marks off-laptop pages "may be stale" 30 days after their review date, then runs `elm make --optimize` and copies the static files.

## How it does it
It uses read-only git calls for dates and history, and writes [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, a plain-text data format) with the `JSON` module built into Elixir 1.18.

## Where it sits in the pipeline
The second step of `wiki publish`, after [[wiki-check]].

## Who receives its output
The [[wiki-site]].
