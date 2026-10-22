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
---

## What it is
Settings > Backup in [[quizapp]]: one JSON file with everything needed to restore Giovanni's progress (ADR-0010).

## What it does
Exports and imports: format version, card states, answer history, daily goal and theme. Import replaces the current progress in a single write.

## How it does it
The codec lives in [[quizapp-core]]; files go through Android's document picker (`CreateDocument` / `OpenDocument`), so the user picks phone storage or Google Drive and the app needs no storage permission.

## Where it sits in the pipeline
Reads [[progress-store]] and [[training-store]]; its files end up on the phone, in Google Drive or in [[quiz-backups]].

## Who receives its output
Giovanni (the file) and [[quiz-backups]] on the laptop.
