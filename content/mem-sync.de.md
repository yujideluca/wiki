---
id: mem-sync
lang: de
source_hash: 951134bb249e
title: mem sync (Pull und Push)
---

## What it is
`mem sync` hält die Kopie des Gedächtnis-Repositorys auf dem Laptop mit GitHub im Gleichstand. Die Kopie heißt Klon; das Original liegt bei GitHub.

## What it does
`pull` lädt die neueste Version herunter, bevor das Gedächtnis gelesen wird (zu Beginn einer Sitzung). `push` lädt neue Ereignisse hoch, nachdem sie geschrieben wurden (am Stop-Hook), mit Wiederholungen. Es führt abgeleitete Dateien (die erzeugten Ansichten) nie zusammen, weil sie jederzeit neu erzeugt werden können.

## How it does it
Es nutzt schlichtes Git mit Zeitlimits. Hat ein anderer Schreiber im selben Moment hochgeladen und wurde der Upload abgelehnt, beginnt es erneut vom neuesten `main` (der Hauptlinie der Geschichte). Es erzwingt nie einen Push.

## Where it sits in the pipeline
Zwischen dem lokalen Klon und [[github]].

## Who receives its output
[[github]] und [[hook-session-start]].
