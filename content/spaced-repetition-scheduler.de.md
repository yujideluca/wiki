---
id: spaced-repetition-scheduler
lang: de
source_hash: 2edefc4be95c
title: SpacedRepetitionScheduler
aliases: [Planer, Abstandsregeln]
---

## What it is
Das Herz von [[quizapp]]: eine reine Funktion `(Fortschritt, Note, jetzt, Konfiguration) → Fortschritt`, die entscheidet, wann eine Karte wiederkommt. Eine SM-2-Variante mit Ankis Standardwerten.

## What it does
Führt eine Karte durch die Phasen NEW → LEARNING → REVIEW (RELEARNING nach einem Fehler). Die erste richtige Antwort schickt eine Karte auf 3 Tage; jede weitere multipliziert den Abstand mit dem Leichtigkeitsfaktor (3 → 8 → 20 → 50 → 125 Tage). Eine falsche Antwort auf eine neue Karte kommt nach 10 Minuten wieder, nie früher (ADR-0007, die Abstandsregeln).

## How it does it
Liest nie selbst die Uhr und hat keine Zufallsstreuung, ist also vollständig deterministisch (ADR-0003). Start-Leichtigkeit 2,5, Minimum 1,3, Easy-Bonus 1,3, Hard-Faktor 1,2 (`SchedulerConfig`). Festgenagelt durch `SpacingRulesTest`, `PeriodizationSimulationTest`, gemeinsame Konformitätsvektoren mit [[quizweb-domain]] und [[mutation-check]].

## Where it sits in the pipeline
Direkt nach [[answer-grader]] in der Antwort-Pipeline; sein Ergebnis ist der neue `CardProgress`, den [[study-controller]] speichert.

## Who receives its output
[[study-controller]] (und darüber [[progress-store]]).
