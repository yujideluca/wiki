---
id: apk-installer
title: ApkInstaller
aliases: [installer]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/android/ApkInstaller.kt
fed_by: [update-client]
feeds: [phone]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/android/ApkInstaller.kt]
---

## What it is
The thin Android adapter that opens the system installer for a downloaded, verified APK.

## What it does
Hands the file to Android's package installer; progress survives because the new APK is signed with the same key ([[signing-key]]).

## How it does it
Called only after [[update-client]] has checked the SHA-256.

## Where it sits in the pipeline
The last step of an in-app update.

## Who receives its output
Android on the [[phone]].
