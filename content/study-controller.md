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
reviewed: 2026-10-22T16:33Z
---

## What it is
The `StudyController` is the single entry point (a "facade": one simple front door in front of many parts) that the screens of [[quizapp]] talk to. It connects the storage, the clock, the card queue and the session engine.

## What it does
It starts study sessions, records each answer (grade → schedule → save), reports today's count toward the [[daily-goal]], and handles suspending and removing cards, resetting progress, and importing and exporting a backup.

## How it does it
It calls the [[card-factory]] for the cards, the [[study-pipeline]] for the queue, the [[study-session]] for the running session, the [[answer-grader]] and the [[spaced-repetition-scheduler]] for every answer, and writes through the [[progress-store]] and the [[training-store]]. It is tested end to end, including that progress survives from one session to the next.

## Where it sits in the pipeline
The middle of the layers `ui → StudyController → domain/content/data`.

## Who receives its output
The [[study-view-model]], which turns its results into what the screen shows.
