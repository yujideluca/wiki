---
id: publish-apk
title: publish_apk.sh
aliases: [publish, promote]
kind: script
project: quizapp
status: active
location: QuizApp:tools/publish_apk.sh
fed_by: [check-tests-updated, check-web-sync, quizapp-quality-gate, signing-key]
feeds: [release-feed]
sources: [QuizApp:tools/publish_apk.sh]
---

## What it is
The release script of [[quizapp]]: builds a signed release APK and publishes it to [[release-feed]].

## What it does
Runs [[quizapp-quality-gate]] first; publishes a beta to `bleeding-edge`; `publish_apk.sh promote` moves a beta to stable `main` after the gate with mutation and [[check-tests-updated]] pass (ADR-0011). Promoting is Giovanni's decision, with no minimum time in beta.

## How it does it
Gradle release build signed with [[signing-key]]; writes versionCode and SHA-256 into `latest.json` and pushes the feed repo.

## Where it sits in the pipeline
The last step of [[quizapp-release]].

## Who receives its output
[[release-feed]].
