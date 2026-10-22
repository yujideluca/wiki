---
id: release-feed
title: german-quiz-releases (update feed)
aliases: [latest.json, release repo]
kind: data
project: quizapp
status: active
location: german-quiz-releases:
fed_by: [publish-apk, publish-content]
feeds: [question-pool-updater, update-client]
sources: [german-quiz-releases:latest.json]
---

## What it is
The public GitHub repo `yujideluca/german-quiz-releases` (local clone `~/dev/german-quiz-releases`) that holds only the newest APK and its manifest `latest.json` (versionCode, versionName, sha256, commit), and since 2026-10-22 a `content/` folder with the newest [[question-pack]].

## What it does
Is the auto-update feed the app reads. Two branches: `main` = stable (what users get) and `bleeding-edge` = beta ([[release-channels]]).

## How it does it
Written only by [[publish-apk]] (the APK) and [[publish-content]] (the question pack).

## Where it sits in the pipeline
Between [[publish-apk]] on the laptop and [[update-client]] on the phone.

## Who receives its output
[[update-client]] in every installed copy.
