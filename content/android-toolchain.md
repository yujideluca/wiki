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
reviewed: 2026-10-27T01:45Z
---

## What it is
The "toolchain" is the set of programs needed to turn the source code of [[quizapp]] into an installable Android app. Here it consists of the [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, the Java compiler and runtime), [Gradle](https://gradle.org/) 9.8 (the build tool that runs the compile and test steps), and the Android SDK (software development kit: the official Android libraries and command-line tools). All of them are unpacked in `~/dev`, plus one small script, `~/dev/env.sh`, that tells the shell where to find them.

## Architecture
### Context
person g: Giovanni — loads it when building by hand | [[giovanni]]
system t: Android toolchain — Java, Gradle and the Android tools in ~/dev
external q: QuizApp quality gate — loads it by itself | [[quizapp-quality-gate]]
external a: QuizApp — the source it turns into an app | [[quizapp]]
external p: The phone — reached with adb | [[phone]]

g -loads env.sh of-> t
q -loads-> t
t -builds the app from-> a
t -talks to-> p

### Containers
person g: Giovanni or the quality gate
container en: env.sh — sets the variables and the search path
container jd: Java Development Kit 21 — the Java compiler and runtime
container gr: Gradle 9.8 — runs the compile and test steps
container sd: Android software development kit — libraries and command-line tools
container ad: adb — the Android Debug Bridge
external p: The phone | [[phone]]

g -loads-> en
en -points to-> jd
en -adds to the search path-> gr
en -points to-> sd
en -adds to the search path-> ad
ad -talks to-> p

## What it does
Running `source ~/dev/env.sh` sets the environment variables `JAVA_HOME`, `ANDROID_HOME` and `ANDROID_SDK_ROOT` (they say where Java and the SDK are) and extends `PATH` (the list of folders the shell searches for programs) with the SDK command-line tools, the platform tools (which include [adb](https://developer.android.com/tools/adb), the Android Debug Bridge for talking to a phone) and Gradle.

## How it does it
Everything is installed without administrator rights. The quality gate ([[quizapp-quality-gate]]) loads the file by itself, so nobody has to remember it. If it is not loaded, commands such as `adb` or `gradle` are simply "not found".

## Where it sits in the pipeline
Underneath every QuizApp build and every adb command.

## Who receives its output
The [[quizapp-quality-gate]], Gradle builds, and the skill [[skill-adb-android-control]].

## Notes
The file is a sourced Bash fragment, marked with `# shellcheck shell=bash`. It assigns values before exporting them so `export` does not hide a failed command. Home paths are quoted. The same file is captured by [[machine-bootstrap]] for restoration. Shell analysis and a test with spaces in the home path passed on 2026-10-26.
