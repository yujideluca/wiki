---
id: card-factory
title: CardFactory
aliases: [cards, Card]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/content/CardFactory.kt
fed_by: [distractor-factory, game-modes, vocab-assets]
feeds: [study-controller, study-pipeline]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/CardFactory.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/Card.kt]
---

## What it is
Turns vocabulary entries into `Card`s, the unit of study: `id`, `mode`, `prompt`, optional `context`, `choices`, `correctChoice`, `explanation`.

## What it does
One function per mode ([[game-modes]]): article, preposition, plural, Präteritum (`preteriteCard`) and Fehler finden (`errorCard`, whose choices are the sentence's chunks). Every mode produces the same shape, which keeps the engine mode-agnostic.

## How it does it
Reads parsed entries from [[vocab-assets]] and asks [[distractor-factory]] for the wrong options.

## Where it sits in the pipeline
First step of the content pipeline: vocabulary → cards → queue.

## Who receives its output
[[study-pipeline]] (through [[study-controller]]).
