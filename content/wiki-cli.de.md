---
id: wiki-cli
lang: de
source_hash: 604a82d9280c
title: wiki (Befehl)
---

## What it is
Der Befehl, mit dem Claude das Wiki aktuell hält: ein Elixir-Escript, installiert als `~/.local/bin/wiki`.

## What it does
`wiki publish` ist der Schritt am Aufgabenende: Er führt [[wiki-check]] im lokalen Modus und [[wiki-build]] aus, committet nur `content/` (fremde Arbeit im Repo wird nie mitgenommen), pusht ins private Repo auf [[github]] und hält die Veröffentlichungszeit für [[wiki-hook-stop]] fest. Bei jedem Fehler lehnt er ab.

## How it does it
Mit `mix escript.build` aus dem Serverprojekt gebaut; `WIKI_ROOT` zeigt aufs Repo (Standard `~/dev/wiki`). Nie Force-Push.

## Where it sits in the pipeline
Aufgerufen bei [[end-of-task]], vor `mem use`.

## Who receives its output
[[github]] (der Commit) und die laufende Seite (über [[wiki-site]]).

## Functions
- `wiki check [--local]`: validate the content
- `wiki build`: content → site/data, Elm → site/assets
- `wiki stale`: pages whose sources changed after the page
- `wiki publish -m "msg"`: check --local, build, commit only content/, push
- `wiki hook-stop`: the Claude Code Stop hook
