---
id: phone
title: Giovanni's phone (Motorola edge 50 fusion)
aliases: [phone, Android phone, Motorola]
kind: external
project: none
status: active
fed_by: [apk-installer, quizapp-app, study-view-model]
feeds: []
reviewed: 2026-10-22
---

## What it is
Giovanni's Android phone, a Motorola edge 50 fusion: where [[quizapp]] is used, and the device every UI change is tried on.

## What it does
Runs the stable and beta QuizApp side by side, receives updates from [[release-feed]], and is driven over adb during the debug pass after coding ([[skill-adb-android-control]]). Also runs the Claude app ([[claude-app]]), which reaches the [[remote-assistant]].

## How it does it
Connected to the laptop by USB (adb); reaches the internet for updates and this wiki.

## Where it sits in the pipeline
The end of the QuizApp pipeline.

## Who receives its output
Giovanni.
