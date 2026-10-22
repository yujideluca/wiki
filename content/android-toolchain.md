---
id: android-toolchain
title: Android toolchain (env.sh)
aliases: [env.sh, Android SDK, JDK 21, Gradle]
kind: program
project: laptop-setup
status: active
location: home:dev/env.sh
fed_by: []
feeds: [quizapp-quality-gate, skill-adb-android-control]
sources: [home:dev/env.sh]
---

## What it is
What builds [[quizapp]] on the laptop: JDK 21, Gradle 9.8 and the Android SDK, all unpacked in `~/dev`, plus `~/dev/env.sh`, which puts them on the path.

## What it does
`source ~/dev/env.sh` sets `JAVA_HOME`, `ANDROID_HOME`/`ANDROID_SDK_ROOT` and `PATH` (SDK command-line tools, platform-tools with adb, Gradle).

## How it does it
User-space installs, no sudo; the quality gate sources the file itself.

## Where it sits in the pipeline
Under every QuizApp build and every adb command.

## Who receives its output
[[quizapp-quality-gate]], Gradle builds and [[skill-adb-android-control]].
