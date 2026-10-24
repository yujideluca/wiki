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
The `UpdateClient` is how [[quizapp]] updates itself without an app store (decision ADR-0004; an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## What it does
Every time the app comes to the foreground (at most once per 30 seconds; if the phone's clock was set back, so that "now" is earlier than the last check, the check runs anyway instead of waiting for the clock to catch up) it reads `latest.json` from the [[release-feed]]. A higher `versionCode` opens a popup on the home screen (never during a study session). Tapping "Update" downloads the APK (Android Package, the installable app file), checks its SHA-256 (Secure Hash Algorithm 256) fingerprint and hands it to the [[apk-installer]]. The same check also asks the [[question-pool-updater]] for a newer question pack.

## How it does it
It reads through the GitHub contents API (application programming interface: a web interface for reading repository files) with the header `Accept: application/vnd.github.raw+json`, because the address `raw.githubusercontent.com` cached files for 5 minutes. An error 403 is reported as the hourly limit (60 requests per IP address). The beta flavor follows the `bleeding-edge` branch, the stable one follows `main` ([[release-channels]]).

## Where it sits in the pipeline
Between the [[release-feed]] on GitHub and the [[apk-installer]] on the phone.

## Who receives its output
The [[apk-installer]].
