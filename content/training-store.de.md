---
id: training-store
lang: de
source_hash: 63938cac2f64
title: TrainingStore (Antwortverlauf)
---

## What it is
Speichert, wie viele Fragen Giovanni an jedem Kalendertag beantwortet hat, und die Einstellung des Tagesziels.

## What it does
Hält `AnswerHistory` (Epochentag → Antworten, gespeichert als `day:count;...` in den Einstellungen `training`) und das Ziel (10–100). „Gesamten Fortschritt zurücksetzen“ berührt es nicht.

## How it does it
Android SharedPreferences; ältere Installationen übernehmen ihren einzelnen Tageszähler in den Verlauf.

## Where it sits in the pipeline
Geschrieben von [[study-controller]] nach jeder Antwort in jedem Modus.

## Who receives its output
[[daily-goal]] (heutiger Balken), [[activity-calendar]] (Serien) und [[progress-backup]].
