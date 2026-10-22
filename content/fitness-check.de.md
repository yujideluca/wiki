---
id: fitness-check
lang: de
source_hash: ce82cafe66ed
title: Fitnessfunktionen
aliases: [Architekturprüfungen]
---

## What it is
Automatische Prüfungen, dass die Architektur nicht abgedriftet ist („Fitnessfunktionen“ aus der evolutionären Architektur; ADR-0009).

## What it does
1. Das Modul `:core` bleibt reines Kotlin (kein Android-Plugin, keine Android-Abhängigkeit). 2. Keine Kotlin-Datei wächst über 400 Zeilen. 3. Mit `--apk` bleibt die Release-APK unter 3 MB.

## How it does it
Python; eine Grenze wird nur absichtlich angehoben, im selben Commit wie ein ADR oder eine Zeile im Entscheidungslog mit Begründung.

## Where it sits in the pipeline
Schritt 7 von [[quizapp-quality-gate]]; überprüft in der [[monthly-architecture-review]].

## Who receives its output
[[quizapp-quality-gate]].
