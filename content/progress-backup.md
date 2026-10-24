---
id: progress-backup
title: Progress backup
aliases: [ProgressBackup, backup]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/ProgressBackup.kt
fed_by: [progress-store, training-store]
feeds: [quiz-backups]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/ProgressBackup.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/BackupSection.kt]
reviewed: 2026-10-22T16:33Z
---

## What it is
Settings > Backup in [[quizapp]] exports Giovanni's learning progress as one [JSON](https://en.wikipedia.org/wiki/JSON) file (JavaScript Object Notation, a plain-text data format) and can restore it (decision ADR-0010; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). It is the safety net against a phone reset or a risky release.

## What it does
It exports and imports the format version, the state of each card, the answer history, the daily goal and the theme. An import replaces the current progress in a single write, so it either works completely or not at all.

## How it does it
The code that converts progress to and from the file (the codec) lives in [[quizapp-core]]. Files go through Android's document picker (`CreateDocument` and `OpenDocument`), so the user chooses phone storage or Google Drive and the app needs no storage permission.

## Where it sits in the pipeline
It reads the [[progress-store]] and the [[training-store]]; its files end up on the phone, in Google Drive or in [[quiz-backups]].

## Who receives its output
Giovanni (the file) and [[quiz-backups]] on the laptop.
