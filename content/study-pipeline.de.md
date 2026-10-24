---
id: study-pipeline
lang: de
source_hash: efa4c9fdee50
title: StudyPipeline (Warteschlangenbauer)
---

## What it is
Vor jeder Lernsitzung muss [[quizapp]] entscheiden, welche Karten in welcher Reihenfolge gefragt werden. Die StudyPipeline baut diese Kartenwarteschlange. Eine Pipeline ist hier eine Kette kleiner Schritte, in der jeder Schritt das Ergebnis des vorigen übernimmt.

## What it does
`buildQueue` ist die Kette `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. In Worten: den gespeicherten Fortschritt jeder Karte anhängen; pausierte oder entfernte Karten verwerfen; Lernkarten zuerst nehmen, sobald ihre Wartezeit vorbei ist; dann Wiederholungen, die am längsten überfälligen zuerst, höchstens 100; dann neue Karten (ohne Tageslimit), nach je 3 Wiederholungen eine eingemischt.

## How it does it
Sie ist eine Kette kleiner reiner Schritte, jeder einzeln getestet (eine Funktion ist „rein“, wenn dieselbe Eingabe immer dieselbe Ausgabe ergibt und sich sonst nichts ändert).

## Where it sits in the pipeline
Zu Beginn jeder Sitzung, zwischen den Karten ([[card-factory]]) mit ihrem gespeicherten Fortschritt ([[progress-store]]) und der laufenden Sitzung ([[study-session]]).

## Who receives its output
Der [[study-controller]], der die Warteschlange an die [[study-session]] übergibt.
