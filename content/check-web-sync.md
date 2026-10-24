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
reviewed: 2026-10-22T16:33Z
---

## What it is
`check_web_sync.sh` checks that the web version ([[quizweb]]) always matches the user (stable) version of the Android app (decision ADR-0006; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). Without it the two "twins" could slowly drift apart.

## What it does
It exits with code 2 and says what is behind when: a vocabulary file or translation file differs between [[vocab-assets]] and the web's `vocab/` and `i18n/` folders; the set of modes differs (the `GameMode` storage ids against `MODES` in [[quizweb-domain]]); or the web clone has uncommitted or unpushed work.

## How it does it
A [Bash](https://www.gnu.org/software/bash/) script that compares files in `~/dev/QuizApp` and `~/dev/QuizWeb`. The fix is to port the change into QuizWeb, bump `VERSION` in `sw.js` (see [[quizweb-service-worker]]), run `npm test`, commit and push.

## Where it sits in the pipeline
At the end of `promote` in [[publish-apk]].

## Who receives its output
[[publish-apk]] and Claude (which learns what to port).
