---
id: wiki-build
lang: de
source_hash: 095b1a19c418
title: wiki build (Inhalt → Daten)
---

## What it is
Verwandelt die Inhalte in die Daten, die das Elm-Frontend liest (Elixir-Modul `Wiki.Content.Build`), und kompiliert dann das Frontend.

## What it does
Schreibt `site/data/graph.json` (Knoten mit Texten in allen drei Sprachen, `feeds`-Kanten und `mentions`-Kanten aus Links, Arten) und pro Seite und Sprache eine `site/data/pages/<id>.<lang>.json` (Abschnitte, Infobox-Felder, Verlauf). Füllt `since` aus dem ersten Commit der Quellen einer Seite, markiert Seiten außerhalb des Laptops 30 Tage nach der Prüfung als „evtl. veraltet“, führt dann `elm make --optimize` aus und kopiert die statischen Dateien.

## How it does it
Nur lesende git-Aufrufe für Daten und Verlauf; JSON über das eingebaute Modul `JSON` von Elixir 1.18.

## Where it sits in the pipeline
Zweiter Schritt von `wiki publish`, nach [[wiki-check]].

## Who receives its output
[[wiki-site]].
