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
reviewed: 2026-10-22T16:33Z
---

## What it is
This is QuizApp's built-in diagnostics: one master switch (`DebugFlags`) and typed log channels (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE, and UI for the user interface). A log is a running record of what the program did, written so that a developer can find out what went wrong.

## What it does
Debug builds switch everything on, release builds switch everything off. In debug builds an overlay under each question shows the card id, the grade, the response time, the phase change, the ease, the interval, the lapses and the due time.

## How it does it
The logging calls are "lazy": the text is only built if its channel is on, so disabled channels cost nothing. `AndroidStudyLog` writes the messages to logcat, Android's system log, which can be read from the laptop with adb (Android Debug Bridge).

## Where it sits in the pipeline
Used by every layer of [[quizapp-core]]; read during the debug pass after coding.

## Who receives its output
logcat, read with [[skill-adb-android-control]].
