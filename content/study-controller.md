---
id: study-controller
title: StudyController
aliases: [controller facade]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/StudyController.kt
fed_by: [card-factory, progress-store, spaced-repetition-scheduler, study-pipeline, study-session, training-store]
feeds: [progress-store, study-view-model, training-store]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/StudyController.kt]
---

## What it is
The single facade the [[quizapp]] UI talks to: it wires store, clock, pipeline and engine together.

## What it does
Starts sessions, records each answer (grade → schedule → save), reports today's count toward the [[daily-goal]], and handles suspend/remove, reset, backup import/export.

## How it does it
Calls [[card-factory]] for the cards, [[study-pipeline]] for the queue, [[study-session]] for the running session, [[answer-grader]] and [[spaced-repetition-scheduler]] for each answer, and writes through [[progress-store]] and [[training-store]]. Tested end to end, including persistence across sessions.

## Where it sits in the pipeline
The middle of `ui → StudyController → domain/content/data`.

## Who receives its output
[[study-view-model]], which turns its results into screen state.
