---
id: wiki-frontend
title: Wiki front end (Elm)
aliases: [Elm app, Main.elm]
kind: program
project: wiki
status: active
location: wiki:frontend
fed_by: [wiki-article-view, wiki-flow-view, wiki-map-view, wiki-router, wiki-search]
feeds: [giovanni]
sources: [wiki:frontend/src/Main.elm, wiki:frontend/src/TopBar.elm, wiki:frontend/src/Lens.elm, wiki:frontend/src/Motion.elm, wiki:frontend/static/style.css, wiki:frontend/static/index.html]
reviewed: 2026-10-27T02:29Z
---

## What it is
The front end is the part of the wiki you see and click. It is written in [Elm](https://elm-lang.org/) (Giovanni's choice), a language for web pages that refuses to compile many kinds of mistakes, so errors are caught before the page ever runs.

## Architecture
### Context
person g: Giovanni — browses the map and the articles | [[giovanni]]
system f: Wiki front end — the part you see and click
external s: Wiki server — sends the data files | [[wiki-server]]
external b: Browser storage — remembers the language

g -uses-> f
s -sends data files to-> f
f -remembers the language in-> b

### Containers
person g: Giovanni | [[giovanni]]
container ma: Main — state, messages and routes
container mp: Map — the dots, the lens and the filter | [[wiki-map-view]]
container ar: Article — the page with infobox and sections | [[wiki-article-view]]
container fl: Flow chart — draws flowcharts and C4 diagrams | [[wiki-flow-view]]
container sr: Search — ranks suggestions | [[wiki-search]]
container bo: boot.js — the one doorway to JavaScript
store da: Data files — the graph and one file per page and language | [[wiki-site]]
store ls: Browser storage — the chosen language

g -uses-> ma
ma -shows-> mp
ma -shows-> ar
ma -asks-> sr
ar -draws diagrams with-> fl
ma -loads-> da
ma -talks to JavaScript through-> bo
bo -writes the language to-> ls

## What it does
The home screen is the system map ([[wiki-map-view]]) with search and suggestions ([[wiki-search]]), a project filter, a timeline slider and a legend of kinds. Hovering over a dot fills four boxes with its description; clicking a dot opens its article ([[wiki-article-view]]). A "Glossary" link in the top bar leads to the glossary page, and links to other websites open in a new tab. The interface is in English, German or Brazilian Portuguese, remembered in the browser. On a phone (a window 760 pixels wide or less) the map fills the whole screen with a search bar shaped like a pill on top, a tap on a dot opens a balloon, and article pages follow the layout of Wikipedia's mobile site; on a desktop the map is seen through a lens and its dots are elastic (both described in [[wiki-map-view]] and [[wiki-article-view]]).

## How it does it
It is a `Browser.application` (an Elm program that controls the whole page and its address) with the routes `/` and `/p/<id>`. It loads `data/graph.json` once and each article in the chosen language on demand; the language is kept in localStorage (the browser's small key-value storage) through a port (Elm's controlled doorway to JavaScript, in `boot.js`). The map is dark and cinematic (inspired by "Dark explorer" visualisations) and the articles are light with serif letters, like Wikipedia. The code is split into modules: `Main` (state and messages), `TopBar` (the top bar and the search field, in a desktop and a phone form), `MapView`, `MapSize`, `Layout`, `Filter`, `MapCamera` (fitting the map into the window, centring on a dot, the lens, the springs' starting points), `Touch` (one finger pans, two fingers pinch), `Lens` (the globe lens) and `Motion` (the elastic movement), `ArticleView`, `WikiText`, `Search`, `I18n` and `Data`. `index.html` marks the page as not translatable, because Chrome's own translation would cover the search bar and rewrite the text the app controls. It is tested with elm-test (requirements MP-1 to MP-9, LG-2, MB-1 to MB-8, LN-1 to LN-4, DY-1 to DY-6, LY-1 and TC-1 to TC-3). Pages with a flow chart are drawn by [[wiki-flow-view]].

## Where it sits in the pipeline
The top of the wiki, served by the [[wiki-router]] after login.

## Who receives its output
[[giovanni]], on the laptop or the phone.


Connected pages in the article infobox use an alphabetical list with full titles, colored kind markers and page links. Titles wrap to keep pages with many connections readable.
