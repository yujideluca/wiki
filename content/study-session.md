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
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/StudySession.kt]
---

## What it is
The running study session of [[quizapp]], held as immutable state with pure transitions.

## What it does
Knows the current card, the answer feedback and what comes next; a re-shown learning card counts again toward the [[daily-goal]].

## How it does it
Each event (answer, next, suspend) returns a new session value; the button order is shuffled per repetition but frozen while feedback shows.

## Where it sits in the pipeline
Between [[study-pipeline]] (the queue) and [[study-controller]] (which applies grading and saving).

## Who receives its output
[[study-controller]] and through it [[study-view-model]].
