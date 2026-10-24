---
id: quiz-backups
lang: de
source_hash: e59de2ecbef0
title: quiz-backups (Kopien auf dem Laptop)
---

## What it is
Das sind Kopien von Giovannis eigenem QuizApp-Fortschritt, auf dem Laptop in `~/dev/quiz-backups` aufbewahrt (zum Beispiel `20261019-0847/progress.json` und exportierte Sicherungsdateien).

## What it does
Sie machen es möglich, ein Zurücksetzen des Handys oder ein riskantes Release rückgängig zu machen: Der Fortschritt lässt sich zurückspielen.

## How it does it
Jede Kopie ist ein Ordner mit Zeitstempel im Namen (über adb, die Android Debug Bridge, vom Handy geholt), dazu ein Ordner `exported/` für Dateien aus der Funktion [[progress-backup]]. Die Datei `LATEST` nennt die neueste Kopie.

## Where it sits in the pipeline
Am Ende des Sicherungswegs: [[progress-backup]] oder adb → hierher.

## Who receives its output
Giovanni oder Claude, wenn Fortschritt wiederhergestellt werden muss.
