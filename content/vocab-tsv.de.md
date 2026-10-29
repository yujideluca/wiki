---
id: vocab-tsv
lang: de
source_hash: 1b16226fa2d8
title: Vokabel-Quelldateien (TSV)
---

## What it is
Das sind die von Menschen bearbeitbaren Quelldateien des gesamten Quiz-Inhalts als Klartexttabellen. Trotz der Dateiendung `.tsv` werden ihre Spalten durch einen senkrechten Strich (`|`) getrennt. Es sind `nouns.tsv` (484 Nomen), `prepositions.tsv` (309 Einträge), `verbs.tsv` (253 Verben) und `errors.tsv` (155 Sätze für den Modus „Fehler finden“).

## What it does
Sie enthalten jedes Wort mit Geschlecht, Plural, Präposition und Hinweis sowie jeden Fehlersatz mit seiner Korrektur, der dahinterstehenden Regel und dem Ausdruck, den er übt. Alles, was die App fragt, stammt von hier.

## How it does it
Die Dateien werden von Hand bearbeitet (von Claude, nach Giovannis Wortlisten und korrigierten Prüfungen). Eine Zeile mit mehreren möglichen Präpositionen braucht eine Hinweisspalte. Ein Fehlersatz markiert genau einen falschen Teil mit `{{ }}`. Ein Skript, [[build-vocab]], prüft all das, bevor die Daten die App erreichen können.

## Where it sits in the pipeline
Der allererste Anfang der Inhaltspipeline: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
[[build-vocab]].
