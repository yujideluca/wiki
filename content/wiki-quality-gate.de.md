---
id: wiki-quality-gate
lang: de
source_hash: e96e70cff52d
title: Wiki-Qualitätstor
---

## What it is
Die einzige Definition von „bestanden“ für das Wiki, aus [[template-quality-gate]]; die CI führt dasselbe Skript aus.

## What it does
Elixir-Tests (`mix test`: Prüfer, Build, Hook, Veröffentlichung, Anmeldetor, Attrappe), Elm-Tests (`elm-test`), ein Elm-Build, Rückverfolgbarkeit der Anforderungen ([[check-traceability]]), `wiki check` auf den echten Inhalten und Fitnessprüfungen (die Attrappe enthält nichts Echtes; die gebaute App bleibt klein).

## How it does it
Bash; auf GitHub läuft `wiki check` ohne `--local`, weil die anderen privaten Repos dort nicht sichtbar sind.

## Where it sits in the pipeline
Vor dem Veröffentlichen von Codeänderungen und bei jedem Push.

## Who receives its output
[[github]] (CI-Ergebnis).
