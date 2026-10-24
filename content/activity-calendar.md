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
reviewed: 2026-10-22T16:33Z
---

## What it is
The streak calendar is the compact month calendar at the top of the home screen of [[quizapp]]. It shows which days Giovanni trained. A "streak" is the number of days in a row on which something was done.

## What it does
A day with at least one answer counts as trained. The calendar shows the current streak (an empty today does not break a streak that ran through yesterday), the longest streak and the days trained this month. Each trained day is coloured from light yellow to orange to orange-red at 100 or more answers (`HeatColor`).

## How it does it
The logic is pure code in `ActivityCalendar.kt` working on the history in the [[training-store]]; the drawing is done by `ui/CalendarCard.kt`. There are arrows for the previous and next month, the week starts on Monday, and future months cannot be shown.

## Where it sits in the pipeline
Reads the [[training-store]]; displayed by the [[study-view-model]] on the home screen.

## Who receives its output
The [[study-view-model]].
