---
id: wiki-build
lang: de
source_hash: 34c4b2daf7e4
title: wiki build (Inhalt → Daten)
---

## What it is
`wiki build` verwandelt den Inhalt in die Daten, die das Elm-Front-End liest (Elixir-Modul `Wiki.Content.Build`), und kompiliert dann das Front End. Man kann es sich als den Schritt vorstellen, der das Wiki für die Anzeige vorbereitet.

## What it does
Es schreibt `site/data/graph.json` (die Knoten mit ihrem Text in allen drei Sprachen, die `feeds`-Kanten, die aus Links gezogenen `mentions`-Kanten und die Arten) und pro Seite und Sprache eine Datei `site/data/pages/<id>.<lang>.json` (Abschnitte, Infobox-Felder, Verlauf). Eine Seite der Art reference (das Glossar) darf auf jede Seite verlinken, ohne Kanten auf der Karte zu zeichnen. Es füllt `since` aus dem ersten Git-Commit der Quellen einer Seite, markiert Seiten außerhalb des Laptops 30 Tage nach ihrem Prüfdatum als „möglicherweise veraltet“, führt dann `elm make --optimize` aus und kopiert die statischen Dateien.

## How it does it
Es nutzt nur lesende Git-Aufrufe für Daten und Verlauf und schreibt [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, ein Klartext-Datenformat) mit dem in Elixir 1.18 eingebauten Modul `JSON`.

## Where it sits in the pipeline
Der zweite Schritt von `wiki publish`, nach [[wiki-check]].

## Who receives its output
Die [[wiki-site]].
