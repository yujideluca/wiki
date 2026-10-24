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
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the search bar at the top of every screen and its list of suggestions (autocomplete: the list that appears while you type).

## What it does
As Giovanni types, up to 8 pages are suggested, best first: exact name, then prefix, then the start of a word, then contained anywhere, then letters in order. Titles and aliases (other names a page is known by) are matched in the chosen language and in English, ignoring case and accents. The arrow keys ↑ and ↓ choose, Enter centres the map on the page (or opens it from an article), and Esc closes the list.

## How it does it
It is a pure ranking function, and it is tested (requirement MP-1).

## Where it sits in the pipeline
In the top bar of the [[wiki-frontend]].

## Who receives its output
The [[wiki-frontend]].
