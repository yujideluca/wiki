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
A purely motivational target: answer N questions today (Settings slider 10–100 in steps of 10, default 20).

## What it does
Every answer in any quiz counts toward one shared count per local day; the home screen shows `answered / goal` as a bar held between 0 and 1. Reaching it only changes the display ("Daily goal reached ✓"); nothing stops the player.

## How it does it
Today's count is today's entry in [[training-store]]; `MainActivity` refreshes the home screen on every resume, which fixed a stale bar after midnight (2026-10-20, requirements DG-2..DG-5, checked by property tests and shared vectors with [[quizweb]]).

## Where it sits in the pipeline
Read from [[training-store]], shown by [[study-view-model]].

## Who receives its output
[[study-view-model]] (the home card and study header).
