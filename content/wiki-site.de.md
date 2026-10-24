---
id: wiki-site
lang: de
source_hash: ccfb383e550a
title: site/ (gebautes Wiki)
---

## What it is
Der Ordner `site/` ist das gebaute Wiki, fertig zur Anzeige: `index.html`, `assets/` (die kompilierte Elm-App `app.js`, `boot.js` und `style.css`) und `data/` (die Graph- und Seitendateien in [JSON](https://en.wikipedia.org/wiki/JSON), JavaScript Object Notation, einem Klartext-Datenformat).

## What it does
Er ist alles, was der Browser nach der Anmeldung braucht. Nichts davon wird je vor der Anmeldung gesendet.

## How it does it
Er wird von [[wiki-build]] erzeugt und nicht in Git committet (er ist abgeleitet und lässt sich jederzeit neu erzeugen). Der [[wiki-router]] liefert ihn von der Festplatte aus, sodass eine Veröffentlichung ohne Neustart des Servers sichtbar wird.

## Where it sits in the pipeline
Zwischen [[wiki-build]] und dem [[wiki-router]].

## Who receives its output
Der [[wiki-router]].
