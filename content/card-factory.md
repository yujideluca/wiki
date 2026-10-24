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
reviewed: 2026-10-22T16:33Z
---

## What it is
A "card" is the unit of study in [[quizapp]]: one question with its answer options. The `CardFactory` turns vocabulary entries into cards. A card has an `id`, a `mode`, a `prompt` (the question), an optional `context`, the `choices`, the `correctChoice` and an `explanation`.

## What it does
There is one function per mode ([[game-modes]]): article, preposition, plural, Präteritum (`preteriteCard`) and Fehler finden (`errorCard`, whose choices are the chunks of the sentence). Every mode produces the same shape, which keeps the rest of the study engine independent of the mode.

## How it does it
It reads the parsed entries from [[vocab-assets]] and asks the [[distractor-factory]] for the wrong options (a "distractor" is a plausible but wrong answer).

## Where it sits in the pipeline
The first step of the content pipeline: vocabulary → cards → queue.

## Who receives its output
The [[study-pipeline]], through the [[study-controller]].
