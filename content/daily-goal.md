---
id: daily-goal
title: Daily goal
aliases: [DailyGoal, progress bar]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/DailyGoal.kt
fed_by: [training-store]
feeds: [study-view-model]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/DailyGoal.kt]
---

## What it is
The daily goal is a purely motivational target: "answer N questions today". N is set with a slider in Settings, from 10 to 100 in steps of 10 (default 20).

## What it does
Every answer in any quiz counts toward one shared count per local day. The home screen shows `answered / goal` as a progress bar held between 0 and 1. Reaching the goal only changes the display ("Daily goal reached ✓"); nothing stops the player from continuing.

## How it does it
Today's count is today's entry in the [[training-store]]. `MainActivity` refreshes the home screen every time the app is resumed, which fixed a bar that stayed stale after midnight (2026-10-20; requirements DG-2 to DG-5, checked by property tests, which try many random inputs, and by shared test vectors with [[quizweb]]).

## Where it sits in the pipeline
Read from the [[training-store]], shown by the [[study-view-model]].

## Who receives its output
The [[study-view-model]] (the home card and the study header).
