---
id: template-quality-gate
lang: de
source_hash: b42f9c573414
title: Qualitätstor der Vorlage
---

## What it is
Das Gerüst von `tools/quality_gate.sh` jedes Projekts: die einzige Definition von „bestanden“, genutzt von Releases und CI.

## What it does
Drei Schritte, pro Projekt auszufüllen: Build und Tests; Rückverfolgbarkeit der Anforderungen ([[check-traceability]]); Fitnessfunktionen. Es schlägt fehl, wenn das Tor länger als 1200 s braucht, weil ein langsames Tor übersprungen wird.

## How it does it
Bash, `set -euo pipefail`; jeder Schritt ein Befehl, der bei Fehler mit Fehlercode endet. Die CI (`.github/workflows/quality-gate.yml`) führt genau dieses Skript aus.

## Where it sits in the pipeline
In jedes neue Projekt kopiert ([[new-project]]).

## Who receives its output
[[quizapp-quality-gate]] und [[wiki-quality-gate]].
