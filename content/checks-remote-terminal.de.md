---
id: checks-remote-terminal
lang: de
source_hash: 24603f845d5d
title: remote-terminal: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[remote-terminal]], einer kleinen Sammlung von Shell-Skripten (vor allem `setup-sudo.sh`), um das Terminal des Laptops aus der Ferne zu erreichen. Es hat das schlankste Gate der Projekte mit CI (Continuous Integration).

## What it does
Das Gate tut drei Dinge: `bash -n` (eine Syntaxprüfung ohne Ausführung) für jedes verfolgte Shell-Skript und den Pre-Push-Hook; ShellCheck auf Warnstufe für `setup-sudo.sh` und seinen Test (übersprungen mit einer Meldung, wenn ShellCheck nicht installiert ist); und einen Sandbox-Test, `tests/setup-sudo-sandbox.sh`, der die sudo-Einrichtung in einem isolierten Ordner ausführt. Limits: das Gate höchstens 300 Sekunden. Es gibt keine Anforderungsliste und keinen Rückverfolgbarkeitsschritt.

## How it does it
CI führt `pipeline-check --mode ci` aus (höchstens 20 Minuten). `pipeline-check.toml` nennt das Repository und den Pflichtjob `gate`. ADRs: keine in `docs/adr`; der Ordner `docs` enthält nur die Aufzeichnung der Fehlersuch-Tests.

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
