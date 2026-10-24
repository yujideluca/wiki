---
id: training-store
lang: de
source_hash: 8473e3cc6421
title: TrainingStore (Antwortverlauf)
---

## What it is
Der `TrainingStore` hält fest, wie viele Fragen Giovanni an jedem lokalen Kalendertag beantwortet hat, samt der Einstellung für das Tagesziel. Er ist die Datengrundlage des Serienkalenders und des Tagesfortschrittsbalkens.

## What it does
Er speichert den `AnswerHistory` (eine Zuordnung von Tagesnummer zu Anzahl, als Text wie `day:count;...` in den Android-Einstellungen namens `training` abgelegt) und das Ziel (10 bis 100). Die Aktion „Gesamten Fortschritt zurücksetzen“ berührt ihn nicht, sodass der Verlauf der Anstrengung ein Zurücksetzen übersteht.

## How it does it
Er nutzt Android SharedPreferences (ein kleiner Schlüssel-Wert-Speicher, der in Android eingebaut ist, siehe [die Dokumentation](https://developer.android.com/training/data-storage/shared-preferences)). Ältere Installationen übernehmen ihre einzelne Tageszahl in den Verlauf.

## Where it sits in the pipeline
Vom [[study-controller]] nach jeder Antwort in jedem Modus geschrieben.

## Who receives its output
Das [[daily-goal]] (der heutige Balken), der [[activity-calendar]] (Serien) und die [[progress-backup]].
