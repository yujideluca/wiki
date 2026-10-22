---
id: update-client
title: UpdateClient (in-app update)
aliases: [update check, AppUpdate]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/data/UpdateClient.kt
fed_by: [release-channels, release-feed]
feeds: [apk-installer, question-pool-updater]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/data/UpdateClient.kt, QuizApp:core/src/main/java/dev/yuji/quiz/domain/AppUpdate.kt, QuizApp:app/src/main/java/dev/yuji/quiz/ui/UpdatePrompt.kt]
---

## What it is
How [[quizapp]] updates itself without an app store (ADR-0004).

## What it does
Every time the app comes to the foreground (at most once per 30 s) it reads `latest.json` from [[release-feed]]; a higher versionCode opens a popup on the home screen (never during a session). Update downloads the APK, checks its SHA-256 and hands it to [[apk-installer]]. The same check also asks [[question-pool-updater]] for a newer question pack.

## How it does it
Reads through the GitHub contents API (`Accept: application/vnd.github.raw+json`), because raw.githubusercontent.com cached for 5 minutes; a 403 is reported as the hourly limit (60 requests per IP). The beta flavor follows the `bleeding-edge` branch, stable follows `main` ([[release-channels]]).

## Where it sits in the pipeline
Between [[release-feed]] on GitHub and [[apk-installer]] on the phone.

## Who receives its output
[[apk-installer]].
