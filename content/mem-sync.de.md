---
id: mem-sync
lang: de
source_hash: e17f788cfb6a
title: mem sync (holen und pushen)
---

## What it is
Hält den Klon des Gedächtnis-Repos auf dem Laptop mit GitHub im Gleichschritt.

## What it does
`pull` vor dem Lesen (Sitzungsstart); `push` nach dem Schreiben (Stop-Hook), mit Wiederholungen; verschmilzt nie abgeleitete Dateien.

## How it does it
Einfaches git mit Zeitlimits; bei einem verlorenen Wettlauf beginnt es neu vom neuesten `main`. Nie Force-Push.

## Where it sits in the pipeline
Zwischen lokalem Klon und [[github]].

## Who receives its output
[[github]] und [[hook-session-start]].
