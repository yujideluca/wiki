---
id: checks-codex-skills
lang: de
source_hash: da0b91ce2243
title: codex-skills: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[codex-skills]], dem Repository mit den Skills, die Codex nutzt, samt Quellen und Manifest. Sein Werkzeug `skillsctl` prüft und installiert sie ([[codex-skillsctl]]).

## What it does
Das Gate führt aus: `skillsctl.py check` (prüft das Manifest und die Dateifingerabdrücke der Skills; der Hash wird über Namen und Bytes berechnet und folgt nie symbolischen Links); die Unit-Tests in `tests/test_skillsctl.py`; eine Mutationsprüfung (`tools/mutation_check.py`); Anforderungs-Rückverfolgbarkeit (die CS-Anforderungen); und die Fitness-Limits. Die Regel dahinter (ADR-0002, Architecture Decision Record): Von Codex verantwortete Anpassungen aktualisieren nie die Claude-Quellen.

## How it does it
CI (Continuous Integration) führt `pipeline-check --mode ci` aus (höchstens 60 Minuten). Die `pipeline-check.toml` ist die der Vorlage: kein GitHub-Abschnitt, daher wird Branch-Schutz nicht gelesen. Drei ADRs existieren.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
