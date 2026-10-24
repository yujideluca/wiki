---
id: card-factory
lang: de
source_hash: 03a61cd67d2d
title: CardFactory
---

## What it is
Eine „Karte“ ist die Lerneinheit in [[quizapp]]: eine Frage mit ihren Antwortoptionen. Die `CardFactory` verwandelt Vokabeleinträge in Karten. Eine Karte hat eine `id`, einen `mode`, einen `prompt` (die Frage), einen optionalen `context`, die `choices`, die `correctChoice` und eine `explanation`.

## What it does
Es gibt eine Funktion pro Modus ([[game-modes]]): Artikel, Präposition, Plural, Präteritum (`preteriteCard`) und Fehler finden (`errorCard`, dessen Optionen die Satzteile sind). Jeder Modus erzeugt dieselbe Form, wodurch der Rest der Lernmaschine vom Modus unabhängig bleibt.

## How it does it
Sie liest die geparsten Einträge aus [[vocab-assets]] und fragt die [[distractor-factory]] nach den falschen Optionen (ein „Distraktor“ ist eine plausible, aber falsche Antwort).

## Where it sits in the pipeline
Der erste Schritt der Inhaltspipeline: Vokabeln → Karten → Warteschlange.

## Who receives its output
Die [[study-pipeline]], über den [[study-controller]].
