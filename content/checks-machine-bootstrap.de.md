---
id: checks-machine-bootstrap
lang: de
source_hash: 81d05f534430
title: machine-bootstrap: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[machine-bootstrap]], dem Werkzeug, das Giovannis Laptop-Einrichtung aufzeichnet und auf einer neuen Maschine wiederherstellt. Ein Fehler hier kann Geheimnisse preisgeben oder eine Wiederherstellung zerstören, daher hat es die strengsten Datenschutzregeln.

## What it does
Das Gate führt aus: die Unit-Tests (Erfassung, Konfiguration, Plan, Scan, Geheimnisse, Zustand, Benachrichtigung, Datensicherung, Bootstrap, VM-Beweis); ShellCheck für `bootstrap.sh`; `python3 -m mb scan`, das jede Datei unter `state/` auf Geheimnisse scannt; Anforderungs-Rückverfolgbarkeit (MB-1 bis MB-16); und die Fitness-Limits (keine Python-Datei über 300 Zeilen in `mb`, das Gate höchstens 1200 Sekunden). Regeln: Die Planung ist rein, und nur `execute` mit einem Runner ändert das System; nichts Geheimes kommt in git (Allow-List plus Scanner, ADR-0004, Architecture Decision Record); Geheimnisse wandern nur durch das verschlüsselte Archiv (ADR-0005); nach einer Änderung an einem Rezept, an `plan.py` oder `bootstrap.sh` wird die ganze Wiederherstellung auf einer sauberen virtuellen Maschine mit `tools/vm-test.sh` bewiesen (etwa eine Stunde) und das Ergebnis im Entscheidungslog festgehalten (MB-15). Unit-Tests beweisen Logik; nur die VM beweist eine Wiederherstellung.

## How it does it
CI (Continuous Integration) führt `pipeline-check --mode ci` aus (höchstens 60 Minuten). Das Repository ist öffentlich, und das Entscheidungslog hält fest, dass der CI-Job `gate` auf `main` verlangt wird, Administratoren eingeschlossen, und dass Force-Pushes und das Löschen von Branches abgelehnt werden (2026-10-26). Fünf ADRs existieren.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
