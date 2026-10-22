---
id: activity-calendar
lang: de
source_hash: bc3abc227a7e
title: Serienkalender
aliases: [Serie]
---

## What it is
Der kompakte Monatskalender oben auf dem Startbildschirm, der zeigt, an welchen Tagen Giovanni geübt hat.

## What it does
Ein Tag mit mindestens einer Antwort zählt als geübt. Zeigt die aktuelle Serie (ein leerer heutiger Tag bricht eine Serie bis gestern nicht), die längste Serie und die Tage dieses Monats; jeder geübte Tag ist hellgelb → orange → orangerot ab 100 Antworten gefärbt (`HeatColor`).

## How it does it
Reine Logik in `ActivityCalendar.kt` über den Verlauf in [[training-store]]; gezeichnet von `ui/CalendarCard.kt`. Pfeile für vorigen/nächsten Monat, Montag zuerst, keine künftigen Monate.

## Where it sits in the pipeline
Liest [[training-store]], angezeigt von [[study-view-model]] auf dem Startbildschirm.

## Who receives its output
[[study-view-model]].
