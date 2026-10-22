---
id: wiki-frontend
title: Wiki front end (Elm)
aliases: [Elm app, Main.elm]
kind: program
project: wiki
status: active
location: wiki:frontend
fed_by: [wiki-article-view, wiki-map-view, wiki-router, wiki-search]
feeds: [giovanni]
sources: [wiki:frontend/src/Main.elm, wiki:frontend/static/style.css]
---

## What it is
The part of the wiki you see and click, written in Elm (Giovanni's choice): a language for web pages that refuses to compile many kinds of mistakes.

## What it does
Home is the system map ([[wiki-map-view]]) with search and autocomplete ([[wiki-search]]), a project filter, a timeline slider and a kind legend; hovering a dot fills four boxes; clicking opens the article ([[wiki-article-view]]). Interface in English, German or Brazilian Portuguese, remembered in the browser.

## How it does it
`Browser.application` with routes `/` and `/p/<id>`; loads `data/graph.json` once and each article in the chosen language on demand; the language is kept in localStorage through a port (`boot.js`). Dark, cinematic map (Dark explorer) and light, serif articles (Wikipedia). Tested with elm-test (MP-1…MP-4, LG-2).

## Where it sits in the pipeline
The top of the wiki, served by [[wiki-router]] after login.

## Who receives its output
[[giovanni]], on the laptop or the phone.
