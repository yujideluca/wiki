---
id: wiki-map-view
title: Map view and info boxes
aliases: [MapView, system map]
kind: function
project: wiki
status: active
location: wiki:frontend/src/MapView.elm
fed_by: []
feeds: [wiki-frontend]
sources: [wiki:frontend/src/MapView.elm, wiki:frontend/src/Layout.elm, wiki:frontend/src/Filter.elm]
---

## What it is
The home screen's map: every page as a dot coloured by kind, lines for feeds (arrows) and mentions (dashed), and the four boxes below it.

## What it does
Hovering a dot lights it and its neighbours in gold and dims the rest; the boxes show What it is, What it does, Fed by and Who receives its output (and keep the last dot when the mouse leaves). Clicking a dot opens its article. Drag to pan, wheel or pinch to zoom; the project filter and timeline hide what does not belong.

## How it does it
Positions are computed once with a force simulation (elm-visualization): connected pages pull together, all pages push apart, projects start in clusters. Filters are pure functions (`Filter.visible`).

## Where it sits in the pipeline
Inside [[wiki-frontend]], at `/`.

## Who receives its output
[[wiki-frontend]] (and through it Giovanni).
