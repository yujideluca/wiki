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
The "toolchain" is the set of programs needed to turn the source code of [[quizapp]] into an installable Android app. Here it consists of the [JDK 21](https://en.wikipedia.org/wiki/Java_Development_Kit) (Java Development Kit, the Java compiler and runtime), [Gradle](https://gradle.org/) 9.8 (the build tool that runs the compile and test steps), and the Android SDK (software development kit: the official Android libraries and command-line tools). All of them are unpacked in `~/dev`, plus one small script, `~/dev/env.sh`, that tells the shell where to find them.

## What it does
Running `source ~/dev/env.sh` sets the environment variables `JAVA_HOME`, `ANDROID_HOME` and `ANDROID_SDK_ROOT` (they say where Java and the SDK are) and extends `PATH` (the list of folders the shell searches for programs) with the SDK command-line tools, the platform tools (which include [adb](https://developer.android.com/tools/adb), the Android Debug Bridge for talking to a phone) and Gradle.

## How it does it
Everything is installed without administrator rights. The quality gate ([[quizapp-quality-gate]]) loads the file by itself, so nobody has to remember it. If it is not loaded, commands such as `adb` or `gradle` are simply "not found".

## Where it sits in the pipeline
Underneath every QuizApp build and every adb command.

## Who receives its output
The [[quizapp-quality-gate]], Gradle builds, and the skill [[skill-adb-android-control]].
