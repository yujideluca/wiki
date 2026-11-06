---
id: study-session
title: StudyEngine / StudySession
aliases: [session engine]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/StudySession.kt
fed_by: []
feeds: [study-controller]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/StudySession.kt, QuizApp:tools/mutation_check.py]
reviewed: 2026-11-06T23:20Z
---

## What it is
The `StudySession` (the "session engine") is one running study session in [[quizapp]]. It is held as immutable state (a value that is never changed in place) with pure transitions (every event produces a new value instead of altering the old one).

## What it does
It knows the current card, the feedback on the last answer and what comes next. A learning card that is shown again counts again toward the [[daily-goal]].

## How it does it
Each event (an answer, "next", a suspend) returns a new session value. `StudyEngine.answer` normally takes the grade from the [[answer-grader]] (right or wrong, and how fast). Since 2026-11-06 it also takes an optional `gradeOverride`, set by a mode that grades from a score instead of the time: the FSP-Fälle mode (FSP: Fachsprachprüfung, the German medical-language exam), where a whole simulated exam case is one card ([[fsp-case]]). It refuses (throws an error on) any grade that contradicts the answer: `AGAIN` exactly when the answer is wrong. A planted fault in the [[mutation-check]] removes the override and must be caught. The order of the answer buttons is shuffled for every repetition but frozen while the feedback is on screen, so a button never moves under the player's finger.

## Where it sits in the pipeline
Between the [[study-pipeline]] (which gives the queue) and the [[study-controller]] (which applies grading and saving).

## Who receives its output
The [[study-controller]] and, through it, the [[study-view-model]].
