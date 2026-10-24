---
id: daily-goal
lang: de
source_hash: 42007fd5f9d7
title: Tagesziel
---

## What it is
Das Tagesziel ist ein rein motivierendes Ziel: „Beantworte heute N Fragen“. N wird in den Einstellungen mit einem Schieberegler von 10 bis 100 in Zehnerschritten eingestellt (Standard 20).

## What it does
Jede Antwort in jedem Quiz zählt für eine gemeinsame Zahl pro lokalem Tag. Der Startbildschirm zeigt `beantwortet / Ziel` als Fortschrittsbalken, der zwischen 0 und 1 gehalten wird. Das Erreichen des Ziels ändert nur die Anzeige („Tagesziel erreicht ✓“); nichts hindert den Spieler daran weiterzumachen.

## How it does it
Die heutige Zahl ist der heutige Eintrag im [[training-store]]. `MainActivity` aktualisiert den Startbildschirm bei jeder Rückkehr in die App, was einen nach Mitternacht veralteten Balken behob (2026-10-20; Anforderungen DG-2 bis DG-5, geprüft durch Property-Tests, die viele zufällige Eingaben ausprobieren, und durch gemeinsame Testvektoren mit [[quizweb]]).

## Where it sits in the pipeline
Aus dem [[training-store]] gelesen, vom [[study-view-model]] angezeigt.

## Who receives its output
Das [[study-view-model]] (die Startkarte und der Lernkopf).
