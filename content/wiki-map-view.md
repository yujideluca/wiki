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
sources: [wiki:frontend/src/MapView.elm, wiki:frontend/src/Layout.elm, wiki:frontend/src/MapSize.elm, wiki:frontend/src/Filter.elm]
---

## What it is
The home screen's map: every page as a dot coloured by kind, lines for feeds (arrows) and mentions (dashed), and the four boxes below it.

## What it does
Hovering a dot lights it and its neighbours in gold and dims the rest; the boxes show What it is, What it does, Fed by and Who receives its output (and keep the last dot when the mouse leaves). Clicking a dot opens its article. Drag to pan, wheel or pinch to zoom; the project filter and timeline hide what does not belong. The highlight is quick (every fade lasts 0.07 s). On a large window the map takes all the height the four boxes do not need, so the page never scrolls when a dot is hovered; a text longer than its box scrolls inside it.

## How it does it
Positions are computed once with a force simulation (elm-visualization): connected pages pull together, all pages push apart and keep a minimum gap, projects start in clusters, and a pull towards a horizontal line makes the cloud settle wide and flat. `Layout.matchAspect` then reshapes it to the shape of the map area (stretching only, at most 3 times, so no two dots get closer), so the dots use the full width. `MapSize` decides the heights: on a wide, tall enough window the boxes get the height their text needs (about 226 px at 1920 px wide) and the map the rest; on a shorter or narrower window the map keeps its 58 % share and the boxes size themselves. Filters are pure functions (`Filter.visible`). Zoom and pan come from elm-visualization's `Zoom`; the SVG declares a viewBox equal to its size and starts at the window's top-left (the search bar floats over it), so the mouse wheel, dragging and two-finger pinch all zoom around the pointer.

## Where it sits in the pipeline
Inside [[wiki-frontend]], at `/`.

## Who receives its output
[[wiki-frontend]] (and through it Giovanni).
