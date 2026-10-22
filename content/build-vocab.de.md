---
id: build-vocab
lang: de
source_hash: abd65fc92bca
title: build_vocab.py
aliases: [Vokabel-Build]
---

## What it is
Das Skript, das die TSV-Vokabeln prüft und das JSON schreibt, das die App mitliefert.

## What it does
Prüft Struktur, Duplikate, erlaubte Artikel und Fälle, Hinweise bei mehrdeutigen Präpositionen und die Regel „genau ein falscher Teil“ der Fehlersätze; schreibt `assets/vocab/*.json`. Bricht bei jedem Problem mit Fehlercode ab, damit falsche Daten die App nie erreichen. `--verify-nouns` gleicht Genus und Plural mit de.wiktionary.org ab.

## How it does it
Python; liest [[vocab-tsv]]; die korrigierten Fehlersätze prüft zusätzlich [[check-errors-languagetool]].

## Where it sits in the pipeline
Zwischen [[vocab-tsv]] und [[vocab-assets]]; sein JSON wird auch in [[quizweb]] kopiert.

## Who receives its output
[[vocab-assets]] (App) und [[quizweb-content]] (`vocab/` des Web-Zwillings).
