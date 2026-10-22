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
Where [[quizapp]] keeps each card's scheduling state (`CardProgress`: phase, step, ease, interval, due time, lapses, suspension/removal): one JSON file on the phone.

## What it does
Saves after every answer and loads at start. A corrupt file is logged on the STORAGE channel and treated as empty instead of crashing.

## How it does it
`FileProgressStore` rewrites the file atomically (temp file + rename), so a crash never leaves it half-written. It sits behind the `ProgressStore` interface; tests use `InMemoryProgressStore`; `replaceAll` applies a backup import in one write.

## Where it sits in the pipeline
Under [[study-controller]]: written after [[spaced-repetition-scheduler]], read by [[study-pipeline]].

## Who receives its output
[[study-pipeline]] (next session) and [[progress-backup]] (export).
