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
sources: [QuizApp:tools/publish_content.sh]
---

## What it is
Publishes a new question pool without a new APK (ADR-0012).

## What it does
`publish_content.sh beta` checks the committed pool and puts it in the `content/` folder of [[release-feed]] on `bleeding-edge`, where the beta app finds it. `publish_content.sh promote` (Giovanni's call, like an APK) copies exactly that pack to `main` for the stable app and puts the same files on the web version ([[quizweb]]).

## How it does it
Bash; the web step works in a temporary worktree of the web repo's `origin/main`, so a web port waiting on a `web-<version>` branch is not disturbed.

## Where it sits in the pipeline
The content-only path of [[quizapp-release]]: edit TSV → [[build-vocab]] → commit → this script.

## Who receives its output
[[release-feed]] (both branches) and [[quizweb-content]].
