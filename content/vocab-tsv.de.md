---
id: vocab-tsv
lang: de
source_hash: 9de6b1547255
title: Vokabel-Quelldateien (TSV)
---

## What it is
Die von Hand bearbeitbare Quelle der Quizinhalte: `nouns.tsv` (484 Nomen), `prepositions.tsv` (309 Einträge), `verbs.tsv` (253 Verben) und `errors.tsv` (121 Sätze für Fehler finden).

## What it does
Enthalten jedes Wort mit Genus, Plural, Präposition und Hinweis sowie jeden Fehlersatz mit Korrektur, Regel und geübtem Ausdruck.

## How it does it
Von Hand bearbeitet (von Claude, aus Giovannis Listen und korrigierten Prüfungen); eine Zeile mit mehreren Präpositionen braucht eine Hinweis-Spalte; ein Fehlersatz markiert genau einen falschen Teil mit `{{ }}`.

## Where it sits in the pipeline
Ganz am Anfang der Inhaltspipeline: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
[[build-vocab]].
