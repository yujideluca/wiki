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
These are copies of Giovanni's own QuizApp progress, kept on the laptop in `~/dev/quiz-backups` (for example `20261019-0847/progress.json` and exported backup files).

## What it does
They make it possible to undo a phone reset or a risky release: the progress can be put back.

## How it does it
Each copy is a folder named with a timestamp (pulled from the phone over adb, the Android Debug Bridge), plus an `exported/` folder for files made with the [[progress-backup]] function. The file `LATEST` names the newest copy.

## Where it sits in the pipeline
At the end of the backup path: [[progress-backup]] or adb → here.

## Who receives its output
Giovanni or Claude, when progress must be restored.
