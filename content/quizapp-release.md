---
id: quizapp-release
title: QuizApp release (beta → stable)
aliases: [release process]
kind: process
project: quizapp
status: active
fed_by: []
feeds: []
sources: [QuizApp:tools/publish_apk.sh, QuizApp:CLAUDE.md]
---

## What it is
The path a change to [[quizapp]] takes from an idea to Giovanni's phone.

## What it does
Makes sure every change is specified, tested, tried in beta and promoted only when Giovanni says so.

## How it does it
Requirement first ([[quizapp-requirements]]), then test, then code; the gate decides; beta before stable ([[release-channels]]).

## Where it sits in the pipeline
Spans [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]], [[update-client]].

## Who receives its output
Giovanni, on the [[phone]].

## Steps
1. Giovanni states a behaviour; it becomes a row in [[quizapp-requirements]].
2. Claude writes the test tagged `REQ <ID>`, then the code, in [[quizapp-core]] or [[quizapp-app]].
3. The first-line debug pass: tests, install on the [[phone]], exercise the flow, read logcat ([[skill-adb-android-control]]).
4. [[quizapp-quality-gate]] passes locally; push; [[quizapp-ci]] must be green.
5. [[publish-apk]] publishes a beta to the `bleeding-edge` branch of [[release-feed]].
6. The beta app's [[update-client]] offers the update; Giovanni tries it.
7. `publish_apk.sh promote` (gate with [[mutation-check]] and [[check-tests-updated]]) moves it to stable `main` when Giovanni decides.
8. The [[quizweb]] port waiting on `web-<version>` is merged to `main`.
