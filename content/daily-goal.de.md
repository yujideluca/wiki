---
id: daily-goal
lang: de
source_hash: 6ee10e16e92e
title: Tagesziel
---

## What it is
Ein reines Motivationsziel: heute N Fragen beantworten (Schieberegler in den Einstellungen 10–100 in Zehnerschritten, Standard 20).

## What it does
Jede Antwort in jedem Quiz zählt zu einem gemeinsamen Zähler pro Kalendertag; der Startbildschirm zeigt `beantwortet / Ziel` als Balken zwischen 0 und 1. Erreichen ändert nur die Anzeige („Tagesziel erreicht ✓“); nichts hält den Spieler auf.

## How it does it
Der heutige Stand ist der heutige Eintrag in [[training-store]]; `MainActivity` aktualisiert den Startbildschirm bei jedem Fortsetzen, was einen veralteten Balken nach Mitternacht behob (20.10.2026, Anforderungen DG-2..DG-5, geprüft durch Eigenschaftstests und gemeinsame Vektoren mit [[quizweb]]).

## Where it sits in the pipeline
Gelesen aus [[training-store]], angezeigt von [[study-view-model]].

## Who receives its output
[[study-view-model]] (Startkarte und Lernkopf).
