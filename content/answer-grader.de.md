---
id: answer-grader
lang: de
source_hash: 8db6708f5c54
title: AnswerGrader
---

## What it is
Spaced Repetition im Anki-Stil braucht für jede Antwort eine „Note“ (Again, Hard, Good, Easy). In einer Karteikarten-App bewertet der Spieler sich selbst; in einem Quiz geht das nicht, denn die App weiß schon, ob die Antwort richtig war. Der `AnswerGrader` macht deshalb aus einer Multiple-Choice-Antwort automatisch eine Note.

## What it does
- Falsche Antwort → AGAIN.
- Bei einer Karte, die schon in der Phase REVIEW ist: richtig in 10 s oder mehr → HARD; richtig in 2,5 s oder weniger → EASY.
- Sonst → GOOD.
HARD und EASY werden nie an Karten vergeben, die noch (neu) gelernt werden. Grund: Ein Glückstreffer (eins zu drei) soll eine Karte nicht das Lernen überspringen lassen, und eine langsame richtige Antwort besteht dort immer (Anforderung GR-1).

## How it does it
Es ist eine reine Funktion (dieselbe Eingabe ergibt immer dieselbe Ausgabe) aus drei Dingen: ob die Antwort richtig war, der Antwortzeit und der Phase der Karte. Die Zeitschwellen stehen in `GraderConfig`.

## Where it sits in the pipeline
Der erste Schritt nach der Antwort des Spielers, vor dem [[spaced-repetition-scheduler]].

## Who receives its output
Der [[spaced-repetition-scheduler]].
