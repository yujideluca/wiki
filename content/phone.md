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
This is Giovanni's Android phone, a Motorola edge 50 fusion. It is where [[quizapp]] is used, and the device on which every change to the app's screens is tried.

## What it does
It runs the stable and the beta version of QuizApp side by side, receives updates from the [[release-feed]], and is driven over adb (the Android Debug Bridge, a tool that lets a computer control a phone) during the debug pass after coding ([[skill-adb-android-control]]). It also runs the [[claude-app]], which reaches the [[remote-assistant]].

## How it does it
It is connected to the laptop by a USB cable (for adb) and reaches the internet for updates and for this wiki.

## Where it sits in the pipeline
The end of the QuizApp pipeline: the point where what was built is finally used.

## Who receives its output
Giovanni.
