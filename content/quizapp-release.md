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
reviewed: 2026-10-25T08:22Z
---

## What it is
This page describes the path that a change to [[quizapp]] takes from an idea to Giovanni's phone. The path is built so that nothing reaches the player unspecified, untested or untried.

## Flow
trigger t1: Giovanni states a behaviour the app should have | [[giovanni]]
step s1: It becomes a row in the requirements | [[quizapp-requirements]]
step s2: Claude writes the test tagged with the requirement, then the code | [[quizapp-core]], [[quizapp-app]]
step s3: Debug pass: tests, install on the phone, exercise the flow, read logcat | [[phone]], [[skill-adb-android-control]]
step s4: The quality gate passes locally; push; the automatic checks must pass | [[quizapp-quality-gate]], [[quizapp-ci]]
step s5: A beta is published to the bleeding-edge branch of the release feed | [[publish-apk]], [[release-feed]]
step s6: The beta app offers the update; Giovanni tries it | [[update-client]]
decide d1: Does Giovanni say promote?
step s7: The promote gate, with mutation and tests-updated checks, publishes the stable app | [[mutation-check]], [[check-tests-updated]]
step s8: The waiting QuizWeb port is merged to main | [[quizweb]]
trigger t2: Only new questions are added | [[question-pool-updater]]
step s9: Edits the question data files and runs build-vocab | [[build-vocab]]
step s10: Publishes beta, then promotes once the automated pipeline passes | [[publish-content]]
product p1: The stable app on Giovanni's phone | [[quizapp]]
product p2: The version stays beta and waits
product p3: New questions delivered without a new app file

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> d1
d1 -yes-> s7
d1 -no-> p2
s7 -> s8
s7 -> p1
s8 -> p1
t2 -> s9
s9 -> s10
s10 -> p3

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
9. New questions alone need no APK: edit the TSV files (tab-separated values), run [[build-vocab]], commit, then [[publish-content]] `beta` and `promote` once the automated pipeline (the gate and the [[mutation-check]]) has passed: since 25 October 2026 Giovanni's standing permission covers question-pool updates, so no separate go-ahead is needed. App releases still wait for Giovanni.
