---
id: progress-store
title: ProgressStore (progress.json)
aliases: [FileProgressStore, progress.json]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/data/ProgressStore.kt
fed_by: [study-controller]
feeds: [progress-backup, study-controller, study-pipeline]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/data/ProgressStore.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/CardProgress.kt]
---

## What it is
This is where [[quizapp]] keeps the scheduling state of every card (`CardProgress`: phase, step, ease, interval, due time, lapses, and whether the card is suspended or removed). It is one [JSON](https://en.wikipedia.org/wiki/JSON) (JavaScript Object Notation, a plain-text data format) file, `progress.json`, on the phone.

## What it does
It saves after every answer and loads at start. If the file is corrupt, the problem is logged on the STORAGE channel and the file is treated as empty instead of crashing the app.

## How it does it
`FileProgressStore` rewrites the file atomically: it first writes a temporary file and then renames it, so a crash can never leave a half-written file. It sits behind the `ProgressStore` interface (a promise of what a store can do), so tests use a simple `InMemoryProgressStore` instead; `replaceAll` applies a backup import in one write.

## Where it sits in the pipeline
Under the [[study-controller]]: written after the [[spaced-repetition-scheduler]], read by the [[study-pipeline]].

## Who receives its output
The [[study-pipeline]] (next session) and the [[progress-backup]] (export).
