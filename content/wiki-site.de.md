---
id: wiki-site
lang: de
source_hash: 2c57f1f81e0e
title: site/ (gebautes Wiki)
---

## What it is
Die gebaute Ausgabe: `index.html`, `assets/` (die kompilierte Elm-App `app.js`, `boot.js`, `style.css`) und `data/` (Graph- und Seiten-JSON).

## What it does
Alles, was der Browser nach der Anmeldung braucht; nichts davon wird je vor der Anmeldung gesendet.

## How it does it
Von [[wiki-build]] erzeugt, nicht committet (abgeleitet); von [[wiki-router]] von der Platte ausgeliefert, sodass eine Veröffentlichung ohne Serverneustart sichtbar ist.

## Where it sits in the pipeline
Zwischen [[wiki-build]] und [[wiki-router]].

## Who receives its output
[[wiki-router]].
