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
---

## What it is
Keeps how many questions Giovanni answered on each local calendar day, and the daily goal setting.

## What it does
Stores `AnswerHistory` (epoch day → answers, saved as `day:count;...` in the `training` preferences) and the goal (10–100). Not touched by "Reset all progress".

## How it does it
Android SharedPreferences; older installs migrate their single day count into the history.

## Where it sits in the pipeline
Written by [[study-controller]] after every answer in any mode.

## Who receives its output
[[daily-goal]] (today's bar), [[activity-calendar]] (streaks) and [[progress-backup]].
