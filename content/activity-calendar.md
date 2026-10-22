---
id: activity-calendar
title: Streak calendar
aliases: [ActivityCalendar, streak, HeatColor]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/ActivityCalendar.kt
fed_by: [training-store]
feeds: [study-view-model]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/ActivityCalendar.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/HeatColor.kt]
---

## What it is
The compact month calendar at the top of the home screen that shows which days Giovanni trained.

## What it does
A day with at least one answer counts as trained. Shows the current streak (an empty today does not break a streak that ran through yesterday), the longest streak and the days this month; each trained day is coloured light yellow → orange → orange-red at 100+ answers (`HeatColor`).

## How it does it
Pure logic in `ActivityCalendar.kt` over the history in [[training-store]]; drawn by `ui/CalendarCard.kt`. Previous/next month arrows, Monday first, no future months.

## Where it sits in the pipeline
Reads [[training-store]], displayed by [[study-view-model]] on the home screen.

## Who receives its output
[[study-view-model]].
