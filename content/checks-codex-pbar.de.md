---
id: checks-codex-pbar
lang: de
source_hash: c09b03d3d9fd
title: codex-pbar: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[codex-pbar]], einem Python-Programm, das für Codex im Terminal eine dauerhafte Fortschrittsleiste zeigt.

## What it does
Das Gate führt aus: die Unit-Tests unter `coverage` mit Zweigmessung der Module core und reader, die unter 85 % scheitern (`--fail-under=85`); eine projektspezifische Mutationsprüfung (`tools/mutation_check.py`), die Fehler wie geänderte Terminal-Farbcodes oder die Maus-Einstellung in temporäre Kopien des Quellcodes einspeist; einen Rauchtest, der das Anwendungsfenster ohne Display startet und `build/window.png` speichert, mit einem Wegwerf-Codex-Ordner, damit echte Daten unberührt bleiben; Anforderungs-Rückverfolgbarkeit (die PB-Anforderungen); und die Fitness-Limits. Architekturregel: `src/codex_pbar` darf `requests`, `urllib` oder `socket` nicht importieren (kein Netzwerkcode). Das Gate darf 1200 Sekunden dauern.

## How it does it
CI (Continuous Integration) installiert die Test-Extras mit pip und führt `pipeline-check --mode ci` aus (höchstens 60 Minuten). Das Repository ist im kostenlosen Tarif privat, daher ist Branch-Schutz nicht verfügbar: `protection_exception` hält das fest, und die lokale Pre-Push-Prüfung springt ein ([[branch-protection-explained]]). Fünf ADRs beschreiben seine Entscheidungen.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
