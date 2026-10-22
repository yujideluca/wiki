---
id: wiki-search
title: Search with autocomplete
aliases: [Search.elm, autocomplete]
kind: function
project: wiki
status: active
location: wiki:frontend/src/Search.elm
fed_by: []
feeds: [wiki-frontend]
sources: [wiki:frontend/src/Search.elm]
---

## What it is
The search bar at the top of every screen and its list of suggestions.

## What it does
As Giovanni types, up to 8 pages are suggested, best first: exact name, then prefix, then the start of a word, then contained anywhere, then letters in order. Titles and aliases are matched in the chosen language and in English, ignoring case and accents. ↑↓ choose, Enter centres the map on the page (or opens it from an article), Esc closes.

## How it does it
A pure ranking function, tested (MP-1).

## Where it sits in the pipeline
In the top bar of [[wiki-frontend]].

## Who receives its output
[[wiki-frontend]].
