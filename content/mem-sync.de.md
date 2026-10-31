---
id: mem-sync
lang: de
source_hash: c28cf962daf0
title: mem sync (Pull und Push)
---

## What it is
`mem sync` hält die Kopie des Gedächtnis-Repositorys auf dem Laptop mit GitHub im Gleichstand. Die Kopie heißt Klon; das Original liegt bei GitHub.

## What it does
`pull` lädt die neueste Version herunter, bevor das Gedächtnis gelesen wird (zu Beginn einer Sitzung). `push` lädt neue Ereignisse hoch, nachdem sie geschrieben wurden (am Stop-Hook), mit Wiederholungen. Es führt abgeleitete Dateien (die erzeugten Ansichten) nie zusammen, weil sie jederzeit neu erzeugt werden können.

## How it does it
Es nutzt Git mit Zeitlimits. Vor dem Hochladen lädt es entfernte Änderungen herunter und spielt lokale Commits darauf erneut ab (Rebase). Bei einem Konflikt in einem Ereignis meldet es `conflict after pull, nothing pushed:` und stoppt vor jedem Uploadversuch. Die betroffenen Dateien bleiben zur Prüfung erhalten. Es erzwingt nie einen Push.

Der Integrationstest verwendet echte lokale Git-Repositorys. Er legt ein gemeinsames Ereignis mit Datum 2001 vor einem neuen Ereignis mit Datum 2000 an und wählt das neue Ereignis über den von `mem add` ausgegebenen Pfad aus. Diese festen Daten erkennen eine Auswahl nach Dateireihenfolge unabhängig von der Uhr. Der Test verlangt die Konfliktmeldung, einen unveränderten Verweis auf den entfernten Verlauf, keinen Uploadversuch und eine ungelöste Ereignisdatei. Git-Aufrufe werden aufgezeichnet und an das echte Git weitergegeben; ihre Ergebnisse werden nicht simuliert.

## Where it sits in the pipeline
Zwischen dem lokalen Klon und [[github]].

## Who receives its output
[[github]] und [[hook-session-start]].
