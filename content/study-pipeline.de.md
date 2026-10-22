---
id: study-pipeline
lang: de
source_hash: f8d6f1dc37f0
title: StudyPipeline (Warteschlange)
---

## What it is
Baut die Kartenwarteschlange für eine Lernsitzung in [[quizapp]].

## What it does
`buildQueue` = `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. Lernkarten zuerst, sobald ihre Wartezeit vorbei ist; Wiederholungen nach Überfälligkeit, höchstens 100; neue Karten ohne Tageslimit, eine nach je 3 Wiederholungen.

## How it does it
Eine Kette kleiner, einzeln getesteter reiner Schritte; pausierte und entfernte Karten fallen in `excludeUnavailable` heraus.

## Where it sits in the pipeline
Zu Beginn jeder Sitzung, zwischen den Karten ([[card-factory]]) mit ihrem gespeicherten Fortschritt ([[progress-store]]) und der laufenden Sitzung ([[study-session]]).

## Who receives its output
[[study-controller]], der die Warteschlange an [[study-session]] gibt.
