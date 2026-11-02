---
id: checks-processing-sketches
lang: de
source_hash: d9932bb76a73
title: processing-sketches: Prüfer und Regeln
---

## What it is
Dies sind die Prüfer von [[processing-sketches]], einem Ordner mit Zeichnungen für die Processing-Umgebung ([[drachenkurve]] und [[drachenfraktal]]). Es ist das kleinste Projekt.

## What it does
Das Gate tut zwei Dinge: Jeder Skizzenordner `name/` muss `name/name.pde` enthalten (die Datei, die Processing erwartet), und keine Datei unter einem Ordner `build/` darf von git verfolgt werden. Limits: das Gate höchstens 300 Sekunden. Es gibt keine Testsuite, keine Anforderungsliste und keine Mutationsprüfung.

## How it does it
CI (Continuous Integration) führt `pipeline-check --mode ci` aus (höchstens 20 Minuten); `pipeline-check.toml` nennt das Repository und den Pflichtjob `gate`, und das Wiki hält den Schutz als aktiv fest ([[maintenance-pipeline]]).

## Where it sits in the pipeline
Es ist eine Seite der Schicht 3 von [[code-security-pipeline]]: Die gemeinsamen Ideen stehen in [[quality-gate-explained]], die ganze Liste in [[checker-catalog]].

## Who receives its output
Leser, die wissen müssen, was dieses Projekt schützt, und die Sitzung, die es ändert.
