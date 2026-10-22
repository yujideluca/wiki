---
id: spaced-repetition-scheduler
title: SpacedRepetitionScheduler
aliases: [scheduler, SM-2, spacing rules]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/SpacedRepetitionScheduler.kt
fed_by: [answer-grader]
feeds: [study-controller]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/SpacedRepetitionScheduler.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/SchedulerConfig.kt]
---

## What it is
The heart of [[quizapp]]: a pure function `(progress, grade, now, config) → progress` that decides when a card comes back. An SM-2 variant with Anki's default parameters.

## What it does
Moves a card through the phases NEW → LEARNING → REVIEW (RELEARNING after a lapse). The first correct answer sends a card to 3 days; each later correct answer multiplies the interval by the ease (3 → 8 → 20 → 50 → 125 days). A wrong answer on a new card repeats after 10 minutes, never earlier (ADR-0007, the spacing rules).

## How it does it
Never reads the clock itself and has no interval fuzz, so it is fully deterministic (ADR-0003). Starting ease 2.5, minimum 1.3, easy bonus 1.3, hard factor 1.2 (`SchedulerConfig`). Pinned by `SpacingRulesTest`, `PeriodizationSimulationTest`, shared conformance vectors with [[quizweb-domain]], and [[mutation-check]].

## Where it sits in the pipeline
Right after [[answer-grader]] in the answer pipeline; its output is the new `CardProgress` that [[study-controller]] saves.

## Who receives its output
[[study-controller]] (and through it [[progress-store]]).
