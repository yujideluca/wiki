---
id: study-debug-log
title: DebugFlags and StudyLog
aliases: [StudyLog, debug overlay]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/debug
fed_by: []
feeds: [skill-adb-android-control]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/debug, QuizApp:app/src/main/java/dev/yuji/quiz/android/AndroidStudyLog.kt]
---

## What it is
QuizApp's diagnostics: one switch (`DebugFlags`) and typed log channels (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE, UI).

## What it does
Debug builds enable everything, release builds nothing. A debug overlay under each question shows card id, grade, response time, phase change, ease, interval, lapses and due time.

## How it does it
Logging lambdas are lazy, so disabled channels cost nothing; `AndroidStudyLog` writes to logcat.

## Where it sits in the pipeline
Used by every layer of [[quizapp-core]]; read during the debug pass after coding.

## Who receives its output
logcat, read with [[skill-adb-android-control]].
