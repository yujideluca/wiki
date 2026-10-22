---
id: quiz-backups
lang: de
source_hash: 5661c1f709be
title: quiz-backups (Kopien auf dem Laptop)
---

## What it is
Kopien von Giovannis eigenem QuizApp-Fortschritt auf dem Laptop in `~/dev/quiz-backups` (zum Beispiel `20261019-0847/progress.json` und exportierte Sicherungsdateien).

## What it does
Macht ein Zurücksetzen des Handys oder eine riskante Version umkehrbar: Der Fortschritt kann zurückgespielt werden.

## How it does it
Ein Ordner mit Zeitstempel pro Kopie (per adb vom Handy geholt) plus `exported/` für Dateien aus [[progress-backup]]; `LATEST` nennt die neueste.

## Where it sits in the pipeline
Am Ende des Sicherungswegs: [[progress-backup]] / adb → hierher.

## Who receives its output
Giovanni oder Claude, wenn Fortschritt wiederhergestellt werden muss.
