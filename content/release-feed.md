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
The "update feed" is the public GitHub repository `yujideluca/german-quiz-releases` (local clone `~/dev/german-quiz-releases`). It holds only the newest APK (Android Package, the installable app file) and its description file `latest.json` (versionCode, versionName, sha256 fingerprint, commit). Since 2026-10-22 it also has a `content/` folder with the newest [[question-pack]].

## What it does
It is what the apps read when they check for updates. There are two branches: `main` is the stable channel (what users get) and `bleeding-edge` is the beta channel ([[release-channels]]).

## How it does it
It is written only by [[publish-apk]] (the APK) and [[publish-content]] (the question pack), so nothing else can change what the apps download.

## Where it sits in the pipeline
Between [[publish-apk]] on the laptop and the [[update-client]] on the phone.

## Who receives its output
The [[update-client]] in every installed copy, and the [[question-pool-updater]].
