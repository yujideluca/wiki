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
sources: [home:.android/german-quiz-release.jks, home:.android/german-quiz-signing.properties]
reviewed: 2026-10-25T02:07Z
---

## What it is
Android only installs an app update if it is signed with the same cryptographic key as the installed version. QuizApp has its own signing key, kept outside the repository in `~/.android`: the keystore (the key file) and a properties file with its credentials. The contents are never written anywhere else.

## What it does
It signs both debug and release builds, so updates install over each other and progress survives; stable and beta can be installed side by side.

## How it does it
The Gradle build reads the properties file. If the file is missing, it falls back to the default debug key, which is fine for tests but would not match the real app.

## Where it sits in the pipeline
Used by [[publish-apk]] and by every local build.

## Who receives its output
[[publish-apk]].
