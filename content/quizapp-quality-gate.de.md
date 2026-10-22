---
id: quizapp-quality-gate
lang: de
source_hash: ec7973de999f
title: QuizApp-Qualitätstor
aliases: [Tor]
---

## What it is
`tools/quality_gate.sh`: die einzige Definition von „bestanden“ für [[quizapp]]. Ein Release führt es aus, und die CI führt genau dasselbe Skript aus.

## What it does
Sieben Schritte: Unit-, Eigenschafts-, Konformitäts- und Integrationstests von core und app mit Abdeckung; Abdeckungsgrenzen; die Tests des Web-Zwillings; identische Konformitätsvektoren in App und Web ([[quizweb-conformance]]); Rückverfolgbarkeit der Anforderungen ([[check-traceability]]); Android-Lint; Fitnessfunktionen ([[fitness-check]]). Mit `--mutation` zusätzlich [[mutation-check]]. Es schlägt fehl, wenn es länger als 1200 s dauert.

## How it does it
Bash, `set -euo pipefail`, lädt auf dem Laptop `~/dev/env.sh` ([[android-toolchain]]); jeder Schritt ist ein Befehl, der bei Fehlern mit Fehlercode endet.

## Where it sits in the pipeline
Vor jeder Veröffentlichung ([[publish-apk]]) und bei jedem Push ([[quizapp-ci]]); abgeleitet von [[template-quality-gate]].

## Who receives its output
[[publish-apk]] (los / nicht los) und [[quizapp-ci]].

## Functions
- `check_coverage.py`: logic packages at 90 % line coverage, no file below 80 %
- `check_traceability.py`: every requirement has a tagged test
- `fitness_check.py`: architecture limits
- `mutation_check.py`: planted faults must be caught (`--mutation` only)
- `metrics.py`: DORA-style delivery metrics for the monthly review (not part of the gate)
