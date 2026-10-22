---
id: quizapp-core
lang: de
source_hash: 188f62b22781
title: QuizApp-Modul :core
---

## What it is
Die reine Kotlin-Hälfte von [[quizapp]] (Gradle-Modul `:core`): die gesamte Lernlogik, ohne Android im Klassenpfad, sodass ein `import android.*` dort nicht kompiliert (ADR-0009).

## What it does
Enthält die Domäne (Karten, Fortschritt, [[spaced-repetition-scheduler]], [[answer-grader]], [[study-pipeline]], [[study-session]], [[daily-goal]], [[activity-calendar]], Codec für [[progress-backup]]), die Inhaltsschicht ([[card-factory]], [[distractor-factory]], Parser) und die Debug-Kanäle ([[study-debug-log]]).

## How it does it
Kleine reine Funktionen, zu Pipelines verkettet; unveränderliche Daten; die Zeit kommt über `Clock` herein. Abgedeckt durch einfache JVM-Unit-Tests in `core/src/test`, ohne Emulator von [[quizapp-quality-gate]] ausgeführt; [[fitness-check]] prüft zusätzlich, dass es Android-frei bleibt.

## Where it sits in the pipeline
Die innere Schicht: `ui → StudyController → domain/content/data`. Nichts darin hängt vom App-Modul ab.

## Who receives its output
[[quizapp-app]], vor allem [[study-controller]].

## Functions
- `Clock`: eingespeiste Zeitquelle, damit Tests die Zeit steuern
- `CardAvailability` / `foldForSearch`: welche Karten pausiert oder entfernt sind; Suche ohne Akzente
- `HeatColor`: Farbskala des Serienkalenders
- `AppUpdate` / `shouldCheckForUpdate`: Update-Regeln (höchstens alle 30 s)
- `SchedulerConfig`, `GraderConfig`: die einstellbaren Zahlen
- `ContentTranslations`: englische Erklärungstexte nach de/pt/es
- `VocabularyParsers`, `VocabularyModels`: JSON-Vokabeln zu Kotlin-Objekten
