---
id: progress-backup
lang: de
source_hash: f138e16fe7ce
title: Fortschrittssicherung
aliases: [Sicherung]
---

## What it is
Einstellungen > Sicherung in [[quizapp]]: eine JSON-Datei mit allem, was nötig ist, um Giovannis Fortschritt wiederherzustellen (ADR-0010).

## What it does
Exportiert und importiert: Formatversion, Kartenzustände, Antwortverlauf, Tagesziel und Design. Der Import ersetzt den aktuellen Fortschritt in einem Schreibvorgang.

## How it does it
Der Codec liegt in [[quizapp-core]]; Dateien laufen über die Dokumentauswahl von Android (`CreateDocument` / `OpenDocument`), sodass man Handyspeicher oder Google Drive wählt und die App keine Speicherberechtigung braucht.

## Where it sits in the pipeline
Liest [[progress-store]] und [[training-store]]; die Dateien landen auf dem Handy, in Google Drive oder in [[quiz-backups]].

## Who receives its output
Giovanni (die Datei) und [[quiz-backups]] auf dem Laptop.
