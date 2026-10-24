---
id: build-vocab
lang: de
source_hash: b59116847dc2
title: build_vocab.py
---

## What it is
`build_vocab.py` ist das Skript, das die Vokabeltabellen ([[vocab-tsv]]) prüft und in die [JSON](https://en.wikipedia.org/wiki/JSON)-Dateien (JavaScript Object Notation, ein Klartext-Datenformat) verwandelt, die die App in sich trägt.

## What it does
Es prüft Struktur, Duplikate, erlaubte Artikel und Fälle, Hinweise für mehrdeutige Präpositionen und die Regel, dass jeder Fehlersatz genau einen falschen Teil hat. Es schreibt `assets/vocab/*.json` und aktualisiert das Manifest des Fragenpools über [[content-manifest]]. Bei jedem Problem endet es mit einem Wert ungleich null, sodass schlechte Daten die App nicht erreichen können. Die Option `--verify-nouns` gleicht Geschlechter und Plurale mit dem deutschen Wiktionary (de.wiktionary.org) ab.

## How it does it
Es ist ein [Python](https://www.python.org/)-Skript. Es liest [[vocab-tsv]]; die korrigierten Fehlersätze werden zusätzlich von [[check-errors-languagetool]] geprüft.

## Where it sits in the pipeline
Zwischen [[vocab-tsv]] und [[vocab-assets]]; sein JSON wird auch nach [[quizweb]] kopiert.

## Who receives its output
[[vocab-assets]] (die App) und [[quizweb-content]] (der Ordner `vocab/` des Web-Zwillings).
