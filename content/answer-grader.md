---
id: answer-grader
title: AnswerGrader
aliases: [grader]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/AnswerGrader.kt
fed_by: []
feeds: [spaced-repetition-scheduler]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/AnswerGrader.kt]
reviewed: 2026-10-22T16:33Z
---

## What it is
Anki-style spaced repetition needs a "grade" for every answer (Again, Hard, Good, Easy). In a flashcard app the player grades themselves; in a quiz they cannot, because the app already knows if the answer was right. The `AnswerGrader` therefore turns a multiple-choice answer into a grade automatically.

## What it does
- A wrong answer → AGAIN.
- On a card already in the REVIEW phase: correct in 10 s or more → HARD; correct in 2.5 s or less → EASY.
- Otherwise → GOOD.
HARD and EASY are never given to cards still in (re)learning. Reason: a lucky guess (one in three) must not let a card skip learning, and a slow correct answer there always passes (requirement GR-1).

## How it does it
It is a pure function (the same input always gives the same output) of three things: whether the answer was correct, the response time and the card's phase. The time thresholds are kept in `GraderConfig`.

## Where it sits in the pipeline
The first step after the player answers, before the [[spaced-repetition-scheduler]].

## Who receives its output
The [[spaced-repetition-scheduler]].
