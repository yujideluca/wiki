---
id: fitness-check
lang: de
source_hash: 61038242b2e1
title: Fitnessfunktionen
---

## What it is
Eine „Fitnessfunktion“ ist eine automatische Prüfung, dass eine Eigenschaft des Entwurfs im Lauf der Zeit nicht abgedriftet ist. Die Idee stammt aus der „evolutionären Architektur“ ([Building Evolutionary Architectures](https://www.thoughtworks.com/insights/books/building-evolutionary-architectures); siehe auch [Fitnessfunktion](https://en.wikipedia.org/wiki/Fitness_function)) und ist in Entscheidung ADR-0009 von QuizApp festgehalten (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). Die Konfiguration steht in der Datei `pipeline-check.toml` von [[quizapp]].

## What it does
Sie prüft vier Grenzen: (1) Das Modul `:core` bleibt reines Kotlin, ohne Android-Plugin oder -Abhängigkeit; (2) keine Kotlin-Datei wächst über 400 Zeilen; (3) die Release-APK (das installierbare Android-Paket) bleibt unter 3 MB (die Prüfung entfällt, wenn keine Release-APK gebaut wurde); (4) das Gate braucht höchstens 1200 Sekunden. Das Programm lässt außerdem `shellcheck`, einen Prüfer für Shell-Skripte, über die Skripte des Projekts laufen ([[pipeline-check]]).

## How it does it
Seit 2026-10-24 stehen die Grenzen in `pipeline-check.toml`, und [[pipeline-check]] misst sie (es ersetzte das Skript `fitness_check.py`), mit einer Warnung ab 80 % einer Grenze. Eine Grenze wird nur absichtlich angehoben, im selben Commit wie ein ADR oder eine Zeile im Entscheidungsprotokoll, die das begründet. So kann sich eine Zahl nicht unbemerkt nach oben schleichen.

## Where it sits in the pipeline
Schritt 7 von [[quizapp-quality-gate]] (`pipeline-check --measure-only`) und des Auftrags der Continuous Integration (CI); geprüft im [[monthly-architecture-review]].

## Who receives its output
[[quizapp-quality-gate]].
