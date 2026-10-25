---
id: wiki-cli
lang: de
source_hash: e301ad30ede8
title: wiki (Befehl)
---

## What it is
`wiki` ist der Befehl, mit dem Claude das Wiki aktuell hält: ein Elixir-Escript (ein Programm, das in eine einzige ausführbare Datei gepackt ist), installiert als `~/.local/bin/wiki`.

## What it does
`wiki publish` ist der Schritt am Ende einer Aufgabe. Er führt [[wiki-check]] im lokalen Modus aus, dann [[wiki-build]], committet nur den Ordner `content/` (sodass unabhängige Arbeit im Repository nie mitgenommen wird) und pusht ihn ins private Repository auf [[github]], und hält schließlich den Zeitpunkt der Veröffentlichung für den [[wiki-hook-stop]] fest. Bei jedem Fehler verweigert er sich.

## How it does it
Er wird mit `mix escript.build` aus dem Serverprojekt gebaut; die Variable `WIKI_ROOT` zeigt auf das Repository (Standard `~/dev/wiki`). Er erzwingt nie einen Push.

## Where it sits in the pipeline
Aufgerufen bei [[end-of-task]], vor `mem use`.

## Who receives its output
[[github]] (der Commit) und die Live-Seite (über die [[wiki-site]]).

## Functions
- `wiki check [--local]`: den Inhalt validieren
- `wiki build`: Inhalt → site/data, Elm → site/assets
- `wiki stale` ([[wiki-stale]]): Seiten mit einer Quelle, die sich nach ihrem `reviewed`-Zeitpunkt geändert hat; endet mit 1, wenn es welche auflistet
- `wiki publish -m "msg"`: check --local, build, nur content/ committen, pushen
- `wiki hook-stop`: der Stop-Hook von Claude Code
