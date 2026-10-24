---
id: quizapp-core
title: QuizApp :core module
aliases: [core module, :core]
kind: module
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz
fed_by: []
feeds: [quizapp-app]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz]
---

## What it is
The `:core` module is the "pure Kotlin" half of [[quizapp]]: all the study logic, with no part of Android in it. "Pure" is enforced by the build: an `import android.*` in this module simply does not compile (decision ADR-0009; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). A Gradle module is a part of the project that is built on its own.

## What it does
It holds the domain (the rules of studying: cards, progress, the [[spaced-repetition-scheduler]], the [[answer-grader]], the [[study-pipeline]], the [[study-session]], the [[daily-goal]], the [[activity-calendar]] and the codec of the [[progress-backup]]), the content layer ([[card-factory]], [[distractor-factory]] and the parsers) and the debug channels ([[study-debug-log]]).

## How it does it
Small pure functions are chained into pipelines (a function is "pure" when the same input always gives the same output and nothing else changes), data is immutable, and time is passed in through a `Clock` so tests can control it. It is covered by plain JVM unit tests (they run on the Java Virtual Machine, without an emulator or phone) in `core/src/test`, which the [[quizapp-quality-gate]] runs; the [[fitness-check]] also asserts that the module stays free of Android.

## Where it sits in the pipeline
The inner layer: `ui → StudyController → domain/content/data`. Nothing in `:core` depends on the app module.

## Who receives its output
[[quizapp-app]], above all the [[study-controller]].

## Functions
- `Clock`: injected time source, so tests control time
- `CardAvailability` / `foldForSearch`: which cards are suspended or removed; accent-free search ("stuhle" finds "Stühle", and the sharp s counts as "ss": "strasse" finds "Straße")
- `HeatColor`: colour ramp of the streak calendar
- `AppUpdate` / `shouldCheckForUpdate`: update rules (at most once per 30 s)
- `SchedulerConfig`, `GraderConfig`: the tunable numbers
- `ContentTranslations`: English explanation text to de/pt/es
- `VocabularyParsers`, `VocabularyModels`: JSON (JavaScript Object Notation) vocabulary to Kotlin objects
