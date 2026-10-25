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
sources: [wiki:frontend/src/MapView.elm, wiki:frontend/src/Lens.elm, wiki:frontend/src/Motion.elm, wiki:frontend/src/Layout.elm, wiki:frontend/src/MapSize.elm, wiki:frontend/src/Filter.elm]
reviewed: 2026-10-25T09:04Z
---

## What it is
The map is the home screen of the wiki: every page is a dot coloured by its kind, with lines for the "feeds" relation (arrows: what feeds what) and the "mentions" relation (dashed: one page links to another), and four information boxes below it.

## What it does
Hovering over a dot lights it and its neighbours in gold and dims the rest; the boxes show What it is, What it does, Fed by and Who receives its output (and keep the last dot when the mouse leaves). Clicking a dot opens its article. You drag to pan, and use the wheel or a two-finger pinch to zoom; the project filter and the timeline hide what does not belong. The highlight is quick (every fade lasts 0.07 seconds). On a large window the map takes all the height that the four boxes do not need, so the page never scrolls when a dot is hovered; a text longer than its box scrolls inside it.

The map is alive. Each dot rests where the layout puts it but can be pushed away from that place and then springs back, with a little wobble, like a weight on elastic: pressing a dot and moving the mouse drags it, its neighbours stretch along behind it and contract back when you let go (a click without movement still opens the page, and a drag never does). Hovering a dot draws its neighbours a fifth of the way towards it. When the page first loads the dots spring open from the middle, and after the window is resized they glide from where they were to their new places instead of jumping.

On a desktop the map is also seen through a lens (a fisheye): dots in the middle of the area are bigger, further apart and labelled, and dots near the border are smaller, closer together and without labels, and the dashed "mentions" lines are left out there. Nothing leaves the window because of the lens, and panning or zooming moves the dots through it. The lens is off on a phone.

On a phone (a window 760 pixels wide or less) the map fills the whole screen, as in Google Maps: a search bar shaped like a pill floats on top with the menu button (map, glossary, language, log out) inside it, and a row of filter chips sits under it. Hovering does not exist on a touch screen, so tapping a dot opens a balloon at the bottom with the same four texts, buttons for the pages that feed it or receive its output (tapping one jumps to that dot), and a button that opens its article; the close button or another dot replaces it. A phone repaints slowly, so there the map has no fades and no dashed lines and moves as one block when you pan or pinch (measured on the phone: 17 to 19 milliseconds a frame, about 60 frames a second); the page also tells the browser not to offer its own translation, and choosing a search result closes the keyboard so that it does not hide the balloon.

## How it does it
Positions are computed once with a force simulation ([force-directed layout](https://en.wikipedia.org/wiki/Force-directed_graph_drawing), done with the library elm-visualization): connected pages pull together, all pages push apart and keep a minimum gap, projects start in clusters, and a pull towards a horizontal line makes the cloud settle wide and flat. `Layout.matchAspect` then reshapes it to the shape of the map area (stretching only, at most 3 times, so no two dots get closer), so the dots use the full width. `MapSize` decides the heights: on a wide, tall enough window the boxes get the height their text needs (about 226 pixels at 1920 pixels wide) and the map gets the rest; on a phone the map takes the whole screen height and the four boxes are replaced by the balloon (`MapView.sheet`); on a shorter or narrower window the map keeps its 58 % share and the boxes size themselves. Filters are pure functions (`Filter.visible`). The elastic layer (`Motion`) gives every dot a displacement with a spring back to its place, a spring towards the average displacement of its neighbours and friction, and asks the browser for animation frames only while something is still moving; the lens (`Lens`) moves a point at distance r from the centre of the area to r·(d+1)/(d·r+1), with d = 1.2 (the fisheye of Sarkar and Brown), and has an inverse so that a mouse position finds the dot under it. Zoom and pan come from the `Zoom` module of elm-visualization; the SVG (Scalable Vector Graphics, a format for drawings made of shapes) declares a `viewBox` equal to its size and starts at the top-left of the window (the search bar floats over it), so the mouse wheel, dragging and pinching all zoom around the pointer.

## Where it sits in the pipeline
Inside the [[wiki-frontend]], at the address `/`.

## Who receives its output
The [[wiki-frontend]] (and through it Giovanni).
