---
id: study-controller
lang: de
source_hash: 72fccc743498
title: StudyController
aliases: [Controller-Fassade]
---

## What it is
Die einzige Fassade, mit der die Oberfläche von [[quizapp]] spricht: Sie verbindet Speicher, Uhr, Pipeline und Engine.

## What it does
Startet Sitzungen, verbucht jede Antwort (bewerten → planen → speichern), meldet den heutigen Stand für das [[daily-goal]] und erledigt Pausieren/Entfernen, Zurücksetzen, Import/Export der Sicherung.

## How it does it
Ruft [[card-factory]] für die Karten, [[study-pipeline]] für die Warteschlange, [[study-session]] für die laufende Sitzung, [[answer-grader]] und [[spaced-repetition-scheduler]] für jede Antwort auf und schreibt über [[progress-store]] und [[training-store]]. Durchgehend getestet, einschließlich Speichern über Sitzungen hinweg.

## Where it sits in the pipeline
Die Mitte von `ui → StudyController → domain/content/data`.

## Who receives its output
[[study-view-model]], das die Ergebnisse in Bildschirmzustand übersetzt.
