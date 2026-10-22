---
id: signing-key
title: QuizApp signing key
aliases: [release keystore]
kind: data
project: quizapp
status: active
location: home:.android
fed_by: []
feeds: [publish-apk]
sources: [home:.android]
---

## What it is
The project's own Android signing key, kept outside the repo in `~/.android` (the keystore and a properties file with its credentials). Its contents are never written anywhere else.

## What it does
Signs both debug and release builds, so updates install over each other and progress survives; stable and beta can be installed side by side.

## How it does it
The Gradle build reads the properties file; if it is missing it falls back to the default debug key.

## Where it sits in the pipeline
Used by [[publish-apk]] and every local build.

## Who receives its output
[[publish-apk]].
