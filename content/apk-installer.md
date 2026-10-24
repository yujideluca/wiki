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
The `ApkInstaller` is a thin Android adapter (a small piece of code that connects the app to a part of Android). It opens Android's system installer for an APK (Android Package, the installable app file) that has been downloaded and verified.

## What it does
It hands the file to Android's package installer. Giovanni's progress survives the update because the new APK is signed with the same key as the old one ([[signing-key]]); Android only accepts an update signed by the same key.

## How it does it
It is called only after the [[update-client]] has checked the file's SHA-256 (SHA-256, Secure Hash Algorithm 256, a fingerprint of the file's content), so a damaged or tampered download is never offered for installation.

## Where it sits in the pipeline
The last step of an in-app update.

## Who receives its output
Android on the [[phone]].
