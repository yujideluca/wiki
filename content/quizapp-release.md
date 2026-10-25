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
reviewed: 2026-10-25T02:04Z
---

## What it is
This page describes the path that a change to [[quizapp]] takes from an idea to Giovanni's phone. The path is built so that nothing reaches the player unspecified, untested or untried.

## What it does
It makes sure that every change is specified, tested, tried in a beta version and promoted to the stable version only when Giovanni says so.

## How it does it
The requirement comes first ([[quizapp-requirements]]), then the test, then the code; the quality gate decides; the beta version comes before the stable one ([[release-channels]]).

## Where it sits in the pipeline
It spans [[quizapp-requirements]], [[quizapp-quality-gate]], [[publish-apk]], [[release-feed]] and [[update-client]].

## Who receives its output
Giovanni, on the [[phone]].

## Steps
1. Giovanni states a behaviour; it becomes a row in [[quizapp-requirements]].
2. Claude writes the test tagged `REQ <ID>`, then the code, in [[quizapp-core]] or [[quizapp-app]].
3. The first-line debug pass: tests, install on the [[phone]], exercise the flow, read logcat ([[skill-adb-android-control]]).
4. The [[quizapp-quality-gate]] passes locally; push; [[quizapp-ci]] must be green.
5. [[publish-apk]] publishes a beta to the `bleeding-edge` branch of the [[release-feed]] (an APK, Android Package, is the installable app file).
6. The beta app's [[update-client]] offers the update; Giovanni tries it.
7. `publish_apk.sh promote` (the gate with the [[mutation-check]] and [[check-tests-updated]]) publishes the stable app to `main` when Giovanni decides, and only if `bleeding-edge` holds exactly this commit.
8. The [[quizweb]] port waiting on the branch `web-<version>` is merged to `main`.
9. New questions alone need no APK: edit the TSV files (tab-separated values), run [[build-vocab]], commit, then [[publish-content]] `beta` and, when Giovanni says so, `promote`.
