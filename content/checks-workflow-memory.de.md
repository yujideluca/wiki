---
id: checks-workflow-memory
lang: de
source_hash: 3932c2c4cf41
title: workflow-memory: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[workflow-memory]], dem gemeinsamen Gedächtnis von Giovannis Assistenten. Es speichert Ereignisse (Aufzeichnungen, dass etwas entschieden oder gelernt wurde) als Dateien und leitet daraus Ansichten ab.

## What it does
Das Gate hat zwei Schritte: die Unit-Tests (`python3 -m unittest discover`, sieben Testdateien) und `pipeline-check --measure-only`. Limits: keine Python-Datei über 400 Zeilen in `mem`, `bin` und `scripts`, das Gate höchstens 300 Sekunden. Die Inhaltsregeln stecken im Code: Jedes neue Ereignis durchläuft den Validator in `mem/validate.py`, der das Schema prüft, Zeitstempel in der Zukunft zurechtstutzt und die gemeinsamen Datenschutzmuster anwendet; ein durchgefallenes Ereignis wird mit einer `.reason`-Notiz nach `quarantine/` verschoben ([[mem-validator]]). Die Invariante „eine Ereignisdatei wird nie an Ort und Stelle geändert“ (ADR-0002, Architecture Decision Record) ist ein CI-Job namens `append-only`. `tests/test_tags.py` prüft die Regel-Tags, darunter dass die Startausgabe des echten Gedächtnisses unter 1.900 Zeichen bleibt und dass keine von Giovanni geschriebene Regel ohne Tag ist.

## How it does it
Es gibt zwei Workflows: `mem.yml` (bei jeder Änderung an Ereignissen und täglich) testet, stellt unter Quarantäne, befördert, baut die Ansichten neu und pusht sie nach `main`; `quality-gate.yml` läuft bei Änderungen an Werkzeugen und Tests. Branch-Schutz ist hier nicht möglich, weil der `mem`-Job mit GitHubs eingebautem Token pusht; `protection_exception` hält das fest, und die lokale Pre-Push-Prüfung springt ein, bewacht von den Pfaden `mem/`, `bin/`, `scripts/`, `tests/`, `tools/`, `docs/` ([[branch-protection-explained]]). Sechs ADRs stehen in [[memory-adrs]].

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
