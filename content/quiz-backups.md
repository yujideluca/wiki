---
id: quiz-backups
title: quiz-backups (laptop copies)
aliases: [backups]
kind: data
project: quizapp
status: active
location: quiz-backups:
fed_by: [progress-backup]
feeds: []
sources: [quiz-backups:LATEST]
---

## What it is
Copies of Giovanni's own QuizApp progress kept on the laptop in `~/dev/quiz-backups` (for example `20261019-0847/progress.json` and exported backup files).

## What it does
Lets a phone reset or a risky release be undone: the progress can be put back.

## How it does it
A timestamped folder per copy (pulled from the phone over adb) plus `exported/` for files made with [[progress-backup]]; `LATEST` names the newest.

## Where it sits in the pipeline
At the end of the backup path: [[progress-backup]] / adb → here.

## Who receives its output
Giovanni or Claude, when progress must be restored.
