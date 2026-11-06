---
id: publish-content
title: publish_content.sh
aliases: [publish questions, pool release]
kind: script
project: quizapp
status: active
location: QuizApp:tools/publish_content.sh
fed_by: []
feeds: [quizweb-content, release-feed]
sources: [QuizApp:tools/publish_content.sh, QuizApp:app/src/main/assets/content.json]
reviewed: 2026-11-06T23:20Z
---

## What it is
`publish_content.sh` publishes a new question pool without building a new APK (Android Package, the installable app file). This is possible because of decision ADR-0012 (an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## What it does
`publish_content.sh beta` checks the committed pool and puts it in the `content/` folder of the [[release-feed]], on the `bleeding-edge` branch, where the beta app finds it. `publish_content.sh promote` (Giovanni's decision, just like for an APK) copies exactly that pack to the `main` branch for the stable app and puts the same files on the web version ([[quizweb]]).

## How it does it
[Bash](https://www.gnu.org/software/bash/). The files it publishes are the ones listed in the manifest `app/src/main/assets/content.json` (read with a short Python command), so a new pool file can never be left out ([[content-manifest]]). Until 2026-11-06 the list was written into the script, and the new file of simulated exam cases `vocab/fsp_cases.json` was missing from it ([[fsp-case]]); commit `de3651c` changed that. The web step works in a temporary worktree (a second checked-out copy) of the web repository's `origin/main`, so a web port that is waiting on a `web-<version>` branch is not disturbed.

## Where it sits in the pipeline
The content-only path of the [[quizapp-release]]: edit the TSV (tab-separated values) files → [[build-vocab]] → commit → this script.

## Who receives its output
The [[release-feed]] (both branches) and [[quizweb-content]].
