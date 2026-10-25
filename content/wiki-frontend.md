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
sources: [wiki:frontend/src/Main.elm, wiki:frontend/src/TopBar.elm, wiki:frontend/src/Lens.elm, wiki:frontend/src/Motion.elm, wiki:frontend/static/style.css, wiki:frontend/static/index.html]
reviewed: 2026-10-25T09:04Z
---

## What it is
The front end is the part of the wiki you see and click. It is written in [Elm](https://elm-lang.org/) (Giovanni's choice), a language for web pages that refuses to compile many kinds of mistakes, so errors are caught before the page ever runs.

## What it does
The home screen is the system map ([[wiki-map-view]]) with search and suggestions ([[wiki-search]]), a project filter, a timeline slider and a legend of kinds. Hovering over a dot fills four boxes with its description; clicking a dot opens its article ([[wiki-article-view]]). A "Glossary" link in the top bar leads to the glossary page, and links to other websites open in a new tab. The interface is in English, German or Brazilian Portuguese, remembered in the browser. On a phone (a window 760 pixels wide or less) the map fills the whole screen with a search bar shaped like a pill on top, a tap on a dot opens a balloon, and article pages follow the layout of Wikipedia's mobile site; on a desktop the map is seen through a lens and its dots are elastic (both described in [[wiki-map-view]] and [[wiki-article-view]]).

## How it does it
It is a `Browser.application` (an Elm program that controls the whole page and its address) with the routes `/` and `/p/<id>`. It loads `data/graph.json` once and each article in the chosen language on demand; the language is kept in localStorage (the browser's small key-value storage) through a port (Elm's controlled doorway to JavaScript, in `boot.js`). The map is dark and cinematic (inspired by "Dark explorer" visualisations) and the articles are light with serif letters, like Wikipedia. The code is split into modules: `Main` (state and messages), `TopBar` (the top bar and the search field, in a desktop and a phone form), `MapView`, `MapSize`, `Layout`, `Filter`, `Lens` (the fisheye) and `Motion` (the elastic movement), `ArticleView`, `WikiText`, `Search`, `I18n` and `Data`. `index.html` marks the page as not translatable, because Chrome's own translation would cover the search bar and rewrite the text the app controls. It is tested with elm-test (requirements MP-1 to MP-9, LG-2, MB-1 to MB-8, LN-1 to LN-3 and DY-1 to DY-4).

## Where it sits in the pipeline
The top of the wiki, served by the [[wiki-router]] after login.

## Who receives its output
[[giovanni]], on the laptop or the phone.
