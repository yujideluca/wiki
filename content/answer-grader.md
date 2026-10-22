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
---

## What it is
Turns a multiple-choice answer into an Anki grade, because a quiz cannot ask the player to grade themselves.

## What it does
Wrong → AGAIN. On a card already in REVIEW: correct in 10 s or more → HARD, correct in 2.5 s or less → EASY. Otherwise GOOD. HARD and EASY are never given to cards still in (re)learning, so a lucky one-in-three guess cannot skip learning and a slow correct answer there always passes (requirement GR-1).

## How it does it
A pure function of correctness, response time and phase; thresholds in `GraderConfig`.

## Where it sits in the pipeline
First step after the player answers, before [[spaced-repetition-scheduler]].

## Who receives its output
[[spaced-repetition-scheduler]].
