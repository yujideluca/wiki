---
id: ci-explained
lang: de
source_hash: 60c4899b6e84
title: CI (Continuous Integration) erklärt
---

## What it is
CI (Continuous Integration, kontinuierliche Integration) bedeutet: Bei jedem Push einer Änderung führt ein Computer, der nicht der des Autors ist, die Prüfungen von einem sauberen Zustand aus erneut aus ([Continuous Integration](https://de.wikipedia.org/wiki/Kontinuierliche_Integration)). So wird der Fall „bei mir läuft es“ abgefangen, und die Änderung bekommt ein grünes oder rotes Zeichen. Giovannis Projekte nutzen [GitHub Actions](https://docs.github.com/en/actions), das Jobs aus Dateien unter `.github/workflows/` auf GitHubs Rechnern ausführt.

## What it does
In fast jedem Projekt hat der Workflow `quality-gate.yml` einen Job namens `gate`. Er läuft bei jedem Push und Pull Request (einem Vorschlag, eine Änderung zu übernehmen) und kann auch von Hand gestartet werden (`workflow_dispatch`). Der Job installiert die Werkzeuge des Projekts und führt dann `tools/pipeline-check.sh --mode ci` aus, das das Gate des Projekts einmal ausführt und die gemeinsamen Prüfungen von [[pipeline-check]] ergänzt; er lädt `report.json` als Artefakt (eine mit dem Lauf gespeicherte Datei) hoch. Die Zeitlimits der Jobs unterscheiden sich: 20 Minuten in [[checks-remote-terminal]] und [[checks-processing-sketches]], 30 in [[checks-wiki]] und [[checks-pipeline-check]], 60 in [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]] und [[checks-status-quo]], 120 in [[checks-quizapp]].

Vier Projekte weichen ab. [[checks-pipeline-check]] kann sich nicht mit einer festgelegten Kopie seiner selbst prüfen, deshalb führt sein Job `tools/quality_gate.sh` direkt aus. [[checks-quizweb]] nennt seinen Job `test` und führt die reine Testsuite aus. [[checks-quizapp]] läuft außerdem wöchentlich (montags) mit der langsamen Mutationsprüfung. [[checks-workflow-memory]] hat zwei Workflows: `quality-gate.yml` für den Code der Gedächtniswerkzeuge und `mem.yml`, der Gedächtnisereignisse verarbeitet und einen zusätzlichen Job namens `append-only` hat.

## How it does it
GitHub liest die Workflow-Datei aus dem Repository; das Gate-Skript ist dasselbe wie auf dem Laptop, sodass CI und ein Laptop-Lauf nie verschiedener Meinung darüber sein können, was „bestanden“ heißt. Ein CI-Lauf allein stoppt keinen Merge; [[branch-protection-explained]] erklärt, was den Job verbindlich macht.

## Where it sits in the pipeline
Schritt 2 von [[code-security-pipeline]], nach der lokalen Pre-Push-Prüfung und vor der Annahme der Änderung. Projektdetails stehen in [[quizapp-ci]] und [[quizweb-ci]].

## Who receives its output
[[github]] (das Zeichen am Commit) und die Claude-Sitzung, die prüfen muss, dass der Lauf auf ihrem genauen Commit grün ist.
