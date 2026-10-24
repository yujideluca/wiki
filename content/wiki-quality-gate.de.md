---
id: wiki-quality-gate
lang: de
source_hash: 845e5e02101d
title: Wiki Quality Gate
---

## What it is
Das Quality Gate ist die eine Definition von „bestanden“ des Wikis, abgeleitet aus dem [[template-quality-gate]]. Die CI (Continuous Integration, die automatischen Prüfungen auf GitHub) führt dasselbe Skript aus.

## What it does
Es führt aus: die Elixir-Tests (`mix test`: Prüfer, Build, Hook, Veröffentlichen, Anmelde-Tor, Köder), die Elm-Tests (`elm-test`), einen Elm-Build, die Anforderungsrückverfolgung ([[check-traceability]]), `wiki check` auf dem echten Inhalt und Fitnessprüfungen (der Köder enthält keinen echten Inhalt; die gebaute App bleibt klein).

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript. Auf GitHub führt es `wiki check` ohne `--local` aus, weil die anderen privaten Repositories dort nicht sichtbar sind.

## Where it sits in the pipeline
Vor dem Veröffentlichen von Codeänderungen und bei jedem Push.

## Who receives its output
[[github]] (das CI-Ergebnis).
