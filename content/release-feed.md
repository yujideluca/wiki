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
sources: [german-quiz-releases:latest.json, german-quiz-releases:content/content.json, QuizApp:tools/check_feed.py, QuizApp:tools/test_check_feed.py]
reviewed: 2026-11-18T06:24Z
---

## What it is
The "update feed" is the public GitHub repository `yujideluca/german-quiz-releases` (local clone `~/dev/german-quiz-releases`). It holds only the newest APK (Android Package, the installable app file) and its description file `latest.json` (versionCode, versionName, sha256 fingerprint, commit). Since 2026-10-22 it also has a `content/` folder with the newest [[question-pack]]. On 2026-11-06 both branches carried app version 2.8.0 (version code 20, the release with the FSP-Fälle mode of simulated FSP (Fachsprachprüfung, the German medical-language exam) cases, [[fsp-case]]) and pool 8 with schema 2; `main` got them with the commit "promote 2.8.0 (versionCode 20, 3cabb51)".

## What it does
It is what the apps read when they check for updates. There are two branches: `main` is the stable channel (what users get) and `bleeding-edge` is the beta channel ([[release-channels]]).

## How it does it
It is written only by [[publish-apk]] (the APK) and [[publish-content]] (the question pack), so nothing else can change what the apps download.

A push to the feed is checked before it leaves the laptop (since 2026-11-18). The publish scripts always ran the gate first, but a push made any other way was unchecked. `tools/check_feed.py` in the QuizApp repository reads the commit being pushed and refuses it when a file that is not a release file is in it, when the sha256 (a fingerprint of a file's content) in `latest.json` is not that of the APK in the same commit, when a question-pool file differs from the fingerprint that `content/content.json` states, or when `versionCode` or `contentVersion` would be lower than on the remote branch. It is installed as `.git/hooks/pre-push` in the laptop's clone of the feed and not committed there, because the feed's branches hold release files only; a fresh clone needs the three-line hook again (the script's first lines say how). Six tests (`tools/test_check_feed.py`, run by step 7 of [[quizapp-quality-gate]]) build small invented feeds.

## Where it sits in the pipeline
Between [[publish-apk]] on the laptop and the [[update-client]] on the phone.

## Who receives its output
The [[update-client]] in every installed copy, and the [[question-pool-updater]].
