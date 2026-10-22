---
id: wiki-frontend
lang: de
source_hash: 5689d2a9ebcf
title: Wiki-Frontend (Elm)
---

## What it is
Der Teil des Wikis, den man sieht und anklickt, in Elm geschrieben (Giovannis Wahl): eine Sprache für Webseiten, die viele Fehlerarten gar nicht erst kompiliert.

## What it does
Start ist die Systemkarte ([[wiki-map-view]]) mit Suche und Autovervollständigung ([[wiki-search]]), Projektfilter, Zeitleiste und Legende der Arten; über einem Punkt füllen sich vier Kästen; ein Klick öffnet den Artikel ([[wiki-article-view]]). Oberfläche auf Englisch, Deutsch oder brasilianischem Portugiesisch, im Browser gemerkt.

## How it does it
`Browser.application` mit den Routen `/` und `/p/<id>`; lädt `data/graph.json` einmal und jeden Artikel in der gewählten Sprache bei Bedarf; die Sprache bleibt über einen Port (`boot.js`) im localStorage. Dunkle, filmische Karte (Dark-Explorer) und helle Artikel mit Serifenschrift (Wikipedia). Getestet mit elm-test (MP-1…MP-4, LG-2).

## Where it sits in the pipeline
Die Spitze des Wikis, nach der Anmeldung von [[wiki-router]] ausgeliefert.

## Who receives its output
[[giovanni]], auf dem Laptop oder dem Handy.
