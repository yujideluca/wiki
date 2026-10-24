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
The scheduler is the heart of [[quizapp]]: a pure function `(progress, grade, now, config) → progress` that decides when a card comes back. It is a variant of the SM-2 algorithm (SuperMemo 2, an early method of [spaced repetition](https://en.wikipedia.org/wiki/SuperMemo) used by many flashcard programs) with the default parameters of [Anki](https://apps.ankiweb.net/).

## What it does
It moves a card through phases: NEW → LEARNING → REVIEW (RELEARNING after a lapse, which is a wrong answer on a known card). The first correct answer sends a card to 3 days; each later correct answer multiplies the interval by the "ease" (so 3 → 8 → 20 → 50 → 125 days). A wrong answer on a new card repeats after 10 minutes, never earlier (decision ADR-0007, "the spacing rules"; an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## How it does it
It never reads the clock itself and has no random "fuzz" in the intervals, so it is fully deterministic (decision ADR-0003). The starting ease is 2.5, the minimum 1.3, the easy bonus 1.3 and the hard factor 1.2 (all in `SchedulerConfig`). The behaviour is pinned down by the tests `SpacingRulesTest` and `PeriodizationSimulationTest`, by shared conformance vectors with [[quizweb-domain]], and by the [[mutation-check]].

## Where it sits in the pipeline
Right after the [[answer-grader]] in the answer pipeline; its output is the new `CardProgress` that the [[study-controller]] saves.

## Who receives its output
The [[study-controller]] (and through it the [[progress-store]]).
