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
reviewed: 2026-10-22T16:33Z
---

## What it is
Before every study session, [[quizapp]] has to decide which cards to ask and in which order. The StudyPipeline builds that queue of cards. A pipeline here is a chain of small steps where each step takes the result of the previous one.

## What it does
`buildQueue` is the chain `attachProgress → excludeUnavailable → selectLearningDue → selectReviewsDue → selectNewCards → interleave`. In words: attach each card's saved progress; drop cards that are suspended or removed; take learning cards first once their waiting time is over; then reviews, most overdue first, at most 100; then new cards (with no daily cap), mixed in one after every 3 reviews.

## How it does it
It is a chain of small pure steps, each tested separately (a function is "pure" when the same input always gives the same output and nothing else changes).

## Where it sits in the pipeline
At the start of each session, between the cards ([[card-factory]]) with their saved progress ([[progress-store]]) and the running session ([[study-session]]).

## Who receives its output
The [[study-controller]], which hands the queue to the [[study-session]].
