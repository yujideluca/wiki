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
reviewed: 2026-11-07T00:37Z
---

## What it is
`check_web_sync.sh` checks that the web version ([[quizweb]]) always matches the user (stable) version of the Android app (decision ADR-0006; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). Without it the two "twins" could slowly drift apart.

## What it does
It exits with code 2 and says what is behind when: a vocabulary file (`nouns`, `prepositions`, `verbs`, `errors` and, since 2026-11-06, `fsp_cases`, the simulated FSP exam cases of [[fsp-case]]; FSP is the Fachsprachprüfung, the German medical-language exam) or translation file differs between [[vocab-assets]] and the web's `vocab/` and `i18n/` folders; the set of modes differs (the `GameMode` storage ids against `MODES` in [[quizweb-domain]]); or the web clone has uncommitted work or commits that are not on GitHub's `main` yet.On 2026-11-06, after the FSP-Fälle port reached GitHub's `main`, it printed `web version in sync with the app` and exited with 0.

## How it does it
A [Bash](https://www.gnu.org/software/bash/) script that compares files in `~/dev/QuizApp` and `~/dev/QuizWeb`. The fix is to port the change into QuizWeb, bump `VERSION` in `sw.js` (see [[quizweb-service-worker]]), run `npm test`, commit and push.

## Where it sits in the pipeline
At the end of `promote` in [[publish-apk]].

## Who receives its output
[[publish-apk]] and Claude (which learns what to port).
