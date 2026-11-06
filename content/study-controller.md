---
id: study-controller
title: StudyController
aliases: [controller facade]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/StudyController.kt
fed_by: [card-factory, fsp-case, progress-store, spaced-repetition-scheduler, study-pipeline, study-session, training-store]
feeds: [progress-store, study-view-model, training-store]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/StudyController.kt, QuizApp:app/src/test/java/dev/yuji/quiz/FspCaseControllerTest.kt]
reviewed: 2026-11-06T23:20Z
---

## What it is
The `StudyController` is the single entry point (a "facade": one simple front door in front of many parts) that the screens of [[quizapp]] talk to. It connects the storage, the clock, the card queue and the session engine.

## What it does
It starts study sessions, records each answer (grade → schedule → save), reports today's count toward the [[daily-goal]], and handles suspending and removing cards, resetting progress, and importing and exporting a backup. For the FSP-Fälle mode (simulated cases of the FSP, Fachsprachprüfung, the German medical-language exam; [[fsp-case]]) it also plays cases: `startCase` returns a new run of the case behind the current card (or nothing when the card is not a case), seeded with the current time, and `finishCase` answers a finished run's card with `bestanden` or `nicht bestanden` and the grade from its score and the card's phase, never from the time it took.

## How it does it
It calls the [[card-factory]] for the cards, the [[study-pipeline]] for the queue, the [[study-session]] for the running session, the [[answer-grader]] and the [[spaced-repetition-scheduler]] for every answer, and writes through the [[progress-store]] and the [[training-store]]. The cases come in as a map from case id to case, given when the controller is built. It is tested end to end, including that progress survives from one session to the next; `FspCaseControllerTest` covers the cases (order of new cases, three days after a pass, ten minutes after a fail, no effect of time, review grading).

## Where it sits in the pipeline
The middle of the layers `ui → StudyController → domain/content/data`.

## Who receives its output
The [[study-view-model]], which turns its results into what the screen shows.
