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
reviewed: 2026-10-25T02:02Z
---

## What it is
`publish_apk.sh` is the release script of [[quizapp]]. It builds a signed release APK (Android Package, the installable app file) and publishes it to the [[release-feed]].

## What it does
It runs the [[quizapp-quality-gate]] first. It then publishes a beta to the `bleeding-edge` branch. The command `publish_apk.sh promote` builds the stable app and publishes it to the stable `main` branch, but only if `bleeding-edge` holds exactly this commit (so what was tested is what ships), after the gate with the mutation check and [[check-tests-updated]] have passed (decision ADR-0011; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). Promoting is Giovanni's decision, with no minimum time in beta.

## How it does it
A Gradle release build signed with the [[signing-key]]. It writes the versionCode and the SHA-256 (Secure Hash Algorithm 256) fingerprint into `latest.json` and pushes the feed repository.

## Where it sits in the pipeline
The last step of the [[quizapp-release]].

## Who receives its output
The [[release-feed]].
