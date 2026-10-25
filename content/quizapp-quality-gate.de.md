---
id: quizapp-quality-gate
lang: de
source_hash: 9847300c045c
title: QuizApp Quality Gate
---

## What it is
`tools/quality_gate.sh` ist die eine Definition von „bestanden“ für [[quizapp]]. Ein Release führt es aus, und die CI (Continuous Integration, die automatischen Prüfungen auf GitHub) führt genau dasselbe Skript aus. Schlägt es fehl, wird nichts veröffentlicht.

## What it does
Es hat sieben Schritte. (1) Unit-, Property-, Konformitäts- und Integrationstests der Module `:core` und `:app`, mit gemessener Abdeckung (Property-Tests probieren viele zufällige Eingaben; Konformitätstests prüfen, dass App und Web-Zwilling übereinstimmen). (2) Abdeckungsschwellen. (3) Die eigenen Tests des Web-Zwillings. (4) Die gemeinsamen Konformitätsvektoren sind in App und Web identisch ([[quizweb-conformance]]). (5) Anforderungsrückverfolgung: Jede Anforderung hat einen Test ([[check-traceability]]). (6) Android Lint (ein automatischer Code-Qualitätsprüfer). (7) `pipeline-check --measure-only` ([[pipeline-check]], mit den in [[fitness-check]] beschriebenen Grenzen) und die Prüfung, dass das Manifest des Fragenpakets zu seinen Dateien passt ([[content-manifest]] mit `--check`). Mit der Option `--mutation` läuft zusätzlich der [[mutation-check]]. Es schlägt fehl, wenn es länger als 1200 Sekunden dauert.

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript mit `set -euo pipefail` (beim ersten Fehler anhalten); auf dem Laptop lädt es `~/dev/env.sh` ([[android-toolchain]]), und jeder Schritt ist ein Befehl, der bei einem Fehler mit einem Wert ungleich null endet.

## Where it sits in the pipeline
Vor jeder Veröffentlichung ([[publish-apk]]) und bei jedem Push ([[quizapp-ci]]); es ist aus dem [[template-quality-gate]] abgeleitet.

## Who receives its output
[[publish-apk]] (Go oder No-Go) und [[quizapp-ci]].

## Functions
- `check_coverage.py`: Logikpakete mit 90 % Zeilenabdeckung, keine Datei unter 80 %
- `pipeline-check --traceability`: jede Anforderung hat einen getaggten Test
- `mutation_check.py`: eingebaute Fehler müssen gefangen werden (nur mit `--mutation`)
- `metrics.py`: Lieferkennzahlen im Stil von DORA (DevOps Research and Assessment) für den Monats-Review (nicht Teil des Gates)
