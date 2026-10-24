---
id: training-store
title: TrainingStore (answer history)
aliases: [AnswerHistory]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/data/TrainingStore.kt
fed_by: [study-controller]
feeds: [activity-calendar, daily-goal, progress-backup, study-controller]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/data/TrainingStore.kt]
reviewed: 2026-10-22T16:33Z
---

## What it is
The `TrainingStore` keeps how many questions Giovanni answered on each local calendar day, together with the setting for the daily goal. It is the data behind the streak calendar and the daily progress bar.

## What it does
It stores the `AnswerHistory` (a map from day number to count, saved as text like `day:count;...` in the Android preferences called `training`) and the goal (10 to 100). It is not touched by the "Reset all progress" action, so the history of effort survives a reset.

## How it does it
It uses Android SharedPreferences (a small key-value store built into Android, see [the documentation](https://developer.android.com/training/data-storage/shared-preferences)). Older installs migrate their single day count into the history.

## Where it sits in the pipeline
Written by the [[study-controller]] after every answer in any mode.

## Who receives its output
The [[daily-goal]] (today's bar), the [[activity-calendar]] (streaks) and the [[progress-backup]].
