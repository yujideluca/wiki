---
id: template-quality-gate
lang: de
source_hash: e7b52f9b0ce2
title: Quality Gate der Vorlage
---

## What it is
Ein Quality Gate ist ein Skript, das entscheidet, ob ein Projekt „besteht“. Dies ist das Gerüst der `tools/quality_gate.sh` jedes Projekts: die eine Definition von „bestanden“, die vor einem Release und von der CI (Continuous Integration, automatische Prüfungen bei jedem Push) benutzt wird. Eine einzige Definition bedeutet, dass die Prüfungen auf dem Laptop und auf GitHub nie voneinander abweichen können.

## What it does
Es hat drei Schritte, die jedes Projekt ausfüllt: Build und Tests; Anforderungsrückverfolgung, das heißt, jede Anforderung hat einen Test und jeder Test verweist auf eine Anforderung ([[check-traceability]]); und Fitnessfunktionen, also automatische Prüfungen, dass der Entwurf nicht abgedriftet ist. Es schlägt außerdem fehl, wenn das Gate länger als 1200 Sekunden braucht, weil ein langsames Gate übersprungen wird und ein übersprungenes Gate nichts schützt.

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript mit `set -euo pipefail` (beim ersten Fehler anhalten), in dem jeder Schritt ein Befehl ist, der bei einem Fehler mit einem Wert ungleich null endet (die Zahl, mit der ein Programm meldet, dass etwas schiefging). Der CI-Workflow (`.github/workflows/quality-gate.yml`) führt genau dieses Skript aus. Die Schritte 2 und 3 rufen das Startskript `tools/pipeline-check.sh` von [[pipeline-check]] auf: `--traceability` für die Anforderungsprüfung, die auch fehlschlägt, wenn die neu erzeugte `docs/TRACEABILITY.md` von der eingecheckten abweicht, und `--measure-only` für die Fitness-Grenzen aus `pipeline-check.toml`.

## Where it sits in the pipeline
In jedes neue Projekt kopiert ([[new-project]]).

## Who receives its output
[[quizapp-quality-gate]] und [[wiki-quality-gate]], seine ausgefüllten Fassungen.
