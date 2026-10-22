---
id: answer-grader
lang: de
source_hash: 797aab00faa1
title: AnswerGrader
aliases: [Bewerter]
---

## What it is
Macht aus einer Multiple-Choice-Antwort eine Anki-Note, weil ein Quiz den Spieler nicht selbst bewerten lassen kann.

## What it does
Falsch → AGAIN. Bei einer Karte, die schon in REVIEW ist: richtig in 10 s oder mehr → HARD, richtig in höchstens 2,5 s → EASY. Sonst GOOD. HARD und EASY gibt es nie für Karten im (Neu-)Lernen, damit ein glücklicher Treffer (eins zu drei) das Lernen nicht überspringt und eine langsame richtige Antwort dort immer besteht (Anforderung GR-1).

## How it does it
Eine reine Funktion aus Richtigkeit, Antwortzeit und Phase; Schwellen in `GraderConfig`.

## Where it sits in the pipeline
Erster Schritt nach der Antwort, vor [[spaced-repetition-scheduler]].

## Who receives its output
[[spaced-repetition-scheduler]].
