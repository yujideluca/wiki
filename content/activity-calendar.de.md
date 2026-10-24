---
id: activity-calendar
lang: de
source_hash: f2516fd8fc66
title: Serienkalender
---

## What it is
Der Serienkalender ist der kompakte Monatskalender oben auf dem Startbildschirm von [[quizapp]]. Er zeigt, an welchen Tagen Giovanni gelernt hat. Eine „Serie“ (Streak) ist die Zahl der Tage in Folge, an denen etwas getan wurde.

## What it does
Ein Tag mit mindestens einer Antwort gilt als gelernt. Der Kalender zeigt die aktuelle Serie (ein leeres Heute unterbricht keine Serie, die bis gestern lief), die längste Serie und die gelernten Tage dieses Monats. Jeder gelernte Tag wird von hellgelb über orange bis orangerot bei 100 oder mehr Antworten gefärbt (`HeatColor`).

## How it does it
Die Logik ist reiner Code in `ActivityCalendar.kt`, der auf dem Verlauf im [[training-store]] arbeitet; gezeichnet wird von `ui/CalendarCard.kt`. Es gibt Pfeile für den vorigen und nächsten Monat, die Woche beginnt am Montag, und künftige Monate lassen sich nicht anzeigen.

## Where it sits in the pipeline
Liest den [[training-store]]; vom [[study-view-model]] auf dem Startbildschirm angezeigt.

## Who receives its output
Das [[study-view-model]].
