---
id: memory-fold
lang: de
source_hash: b6b1c1d081e3
title: Die Faltung (core.py)
aliases: [Faltung]
---

## What it is
Die eine reine Funktion von [[workflow-memory]]: Sie faltet das Ereignisprotokoll zum aktuellen Zustand.

## What it does
Die neueste Regel pro (scope, key) gewinnt; dieselbe Regel erneut ist zusätzlicher Beleg; eine Verneinung ist eine Änderung; `forget` und `done` schließen ihr Ziel; Feedback ändert die Wichtigkeit (`wrong` nimmt einen Eintrag aus dem Briefing und listet ihn zur Prüfung); ein Ereignis des Harvesters überschreibt nie Giovannis eigene Worte; zwei Schreibende mit verschiedenen Texten zu einem Schlüssel innerhalb von 24 h ergeben einen Konflikt, keine Verschmelzung. Dann ordnet sie die Einträge fürs Briefing: Vorlieben verfallen nie, andere Typen verblassen mit Halbwertszeiten (Entscheidung und Fakt 180 Tage, Notiz 7 Tage), verlängert durch jede Nutzung.

## How it does it
Unabhängig von der Reihenfolge und idempotent (getestet): Ereignisse werden nach Zeit, dann ID sortiert, Duplikate zählen einmal. `brief()` passt das Ergebnis in ein Budget von etwa 2.900 Zeichen (2,5 % einer typischen ersten Runde, kalibriert mit `scripts/calibrate.py`).

## Where it sits in the pipeline
Zwischen [[events-log]] und allem, was Gedächtnis anzeigt.

## Who receives its output
[[session-brief]] (über [[hook-session-start]]) und [[memory-views]] (über [[mem-action]]).
