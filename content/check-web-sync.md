---
id: check-web-sync
title: check_web_sync.sh
aliases: [web sync check]
kind: script
project: quizapp
status: active
location: QuizApp:tools/check_web_sync.sh
fed_by: [quizweb]
feeds: [publish-apk]
sources: [QuizApp:tools/check_web_sync.sh]
---

## What it is
The check that the web version always matches the user version of the Android app (ADR-0006).

## What it does
Exits 2 and says what is behind when: a vocabulary file or translation file differs between [[vocab-assets]] and the web's `vocab/` and `i18n/`; the set of modes differs (`GameMode` storage ids vs `MODES` in [[quizweb-domain]]); or the web clone has uncommitted or unpushed work.

## How it does it
Bash comparing files in `~/dev/QuizApp` and `~/dev/QuizWeb`. The fix is to port the change into QuizWeb, bump `VERSION` in `sw.js`, run `npm test`, commit and push.

## Where it sits in the pipeline
At the end of [[publish-apk]] `promote`.

## Who receives its output
[[publish-apk]] and Claude (what to port).
