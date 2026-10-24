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
The map is the home screen of the wiki: every page is a dot coloured by its kind, with lines for the "feeds" relation (arrows: what feeds what) and the "mentions" relation (dashed: one page links to another), and four information boxes below it.

## What it does
Hovering over a dot lights it and its neighbours in gold and dims the rest; the boxes show What it is, What it does, Fed by and Who receives its output (and keep the last dot when the mouse leaves). Clicking a dot opens its article. You drag to pan, and use the wheel or a two-finger pinch to zoom; the project filter and the timeline hide what does not belong. The highlight is quick (every fade lasts 0.07 seconds). On a large window the map takes all the height that the four boxes do not need, so the page never scrolls when a dot is hovered; a text longer than its box scrolls inside it.

## How it does it
Positions are computed once with a force simulation ([force-directed layout](https://en.wikipedia.org/wiki/Force-directed_graph_drawing), done with the library elm-visualization): connected pages pull together, all pages push apart and keep a minimum gap, projects start in clusters, and a pull towards a horizontal line makes the cloud settle wide and flat. `Layout.matchAspect` then reshapes it to the shape of the map area (stretching only, at most 3 times, so no two dots get closer), so the dots use the full width. `MapSize` decides the heights: on a wide, tall enough window the boxes get the height their text needs (about 226 pixels at 1920 pixels wide) and the map gets the rest; on a shorter or narrower window the map keeps its 58 % share and the boxes size themselves. Filters are pure functions (`Filter.visible`). Zoom and pan come from the `Zoom` module of elm-visualization; the SVG (Scalable Vector Graphics, a format for drawings made of shapes) declares a `viewBox` equal to its size and starts at the top-left of the window (the search bar floats over it), so the mouse wheel, dragging and pinching all zoom around the pointer.

## Where it sits in the pipeline
Inside the [[wiki-frontend]], at the address `/`.

## Who receives its output
The [[wiki-frontend]] (and through it Giovanni).
