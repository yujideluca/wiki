---
id: study-session
lang: de
source_hash: 99fe926c4491
title: StudyEngine / StudySession
---

## What it is
Die laufende Lernsitzung von [[quizapp]], als unveränderlicher Zustand mit reinen Übergängen.

## What it does
Kennt die aktuelle Karte, die Rückmeldung zur Antwort und was als Nächstes kommt; eine wieder gezeigte Lernkarte zählt erneut für das [[daily-goal]].

## How it does it
Jedes Ereignis (Antwort, weiter, pausieren) liefert einen neuen Sitzungswert; die Reihenfolge der Knöpfe wird pro Wiederholung gemischt, bleibt aber während der Rückmeldung fest.

## Where it sits in the pipeline
Zwischen [[study-pipeline]] (Warteschlange) und [[study-controller]] (bewertet und speichert).

## Who receives its output
[[study-controller]] und darüber [[study-view-model]].
