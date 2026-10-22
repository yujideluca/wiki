---
id: study-pipeline
title: StudyPipeline (queue builder)
aliases: [buildQueue, queue pipeline]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/StudyPipeline.kt
fed_by: [card-factory, progress-store]
feeds: [study-controller]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/StudyPipeline.kt]
---

## What it is
Builds the queue of cards for a study session in [[quizapp]].

## What it does
`buildQueue` = `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. Learning cards first once their wait is over; reviews most-overdue-first, capped at 100; new cards with no daily cap, one after every 3 reviews.

## How it does it
A chain of small, separately tested pure steps; suspended and removed cards are dropped by `excludeUnavailable`.

## Where it sits in the pipeline
At the start of each session, between the cards ([[card-factory]]) with their saved progress ([[progress-store]]) and the running session ([[study-session]]).

## Who receives its output
[[study-controller]], which hands the queue to [[study-session]].
