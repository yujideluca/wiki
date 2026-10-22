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
The pure-Kotlin half of [[quizapp]] (Gradle module `:core`): all study logic, with no Android on its classpath, so an `import android.*` there does not compile (ADR-0009).

## What it does
Holds the domain (cards, progress, [[spaced-repetition-scheduler]], [[answer-grader]], [[study-pipeline]], [[study-session]], [[daily-goal]], [[activity-calendar]], [[progress-backup]] codec), the content layer ([[card-factory]], [[distractor-factory]], parsers) and the debug channels ([[study-debug-log]]).

## How it does it
Small pure functions chained into pipelines; immutable data; time is injected through `Clock`. Covered by plain JVM unit tests in `core/src/test`, run without an emulator by [[quizapp-quality-gate]]; [[fitness-check]] also asserts it stays Android-free.

## Where it sits in the pipeline
The inner layer: `ui → StudyController → domain/content/data`. Nothing in it depends on the app module.

## Who receives its output
[[quizapp-app]], above all [[study-controller]].

## Functions
- `Clock`: injected time source, so tests control time
- `CardAvailability` / `foldForSearch`: which cards are suspended or removed; accent-free search
- `HeatColor`: colour ramp of the streak calendar
- `AppUpdate` / `shouldCheckForUpdate`: update rules (at most once per 30 s)
- `SchedulerConfig`, `GraderConfig`: the tunable numbers
- `ContentTranslations`: English explanation text to de/pt/es
- `VocabularyParsers`, `VocabularyModels`: JSON vocabulary to Kotlin objects
