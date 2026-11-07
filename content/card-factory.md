---
id: card-factory
title: CardFactory
aliases: [cards, Card]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/content/CardFactory.kt
fed_by: [distractor-factory, fsp-case, game-modes, vocab-assets]
feeds: [study-controller, study-pipeline]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/CardFactory.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/Card.kt, QuizApp:core/src/main/java/dev/yuji/quiz/content/ContentPack.kt]
reviewed: 2026-11-07T13:23Z
---

## What it is
A "card" is the unit of study in [[quizapp]]: one question with its answer options. The `CardFactory` turns vocabulary entries into cards. A card has an `id`, a `mode`, a `prompt` (the question), an optional `context`, the `choices`, the `correctChoice` and an `explanation`.

## What it does
There is one function per mode ([[game-modes]]): article, preposition, plural, Präteritum (`preteriteCard`), Fehler finden (`errorCard`, whose choices are the chunks of the sentence) and FSP-Fälle (`fspCaseCard`, since 2026-11-06). `fspCaseCard` makes one card for a whole simulated FSP case (FSP: Fachsprachprüfung, the German medical-language exam; [[fsp-case]]): id `fsp:<case id>`, the complaint as prompt (never the diagnosis), the patient as context, the area of medicine as hint, the diagnosis as explanation, and the two unshuffled choices `bestanden` (passed, the correct one) and `nicht bestanden`. Every mode produces the same shape, which keeps the rest of the study engine independent of the mode.

`buildDeck` builds the deck of all modes at once. The Fehler finden sentences are shuffled once with a fixed seed so they do not arrive grouped by error type; the FSP cases keep the file order, which is ordered by area of medicine.

## How it does it
It reads the parsed entries from [[vocab-assets]] (the cases through [[fsp-case]]) and asks the [[distractor-factory]] for the wrong options (a "distractor" is a plausible but wrong answer).

## Where it sits in the pipeline
The first step of the content pipeline: vocabulary → cards → queue.

## Who receives its output
The [[study-pipeline]], through the [[study-controller]].
