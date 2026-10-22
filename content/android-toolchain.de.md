---
id: android-toolchain
lang: de
source_hash: 26d1a062b2f1
title: Android-Werkzeugkette (env.sh)
---

## What it is
Was [[quizapp]] auf dem Laptop baut: JDK 21, Gradle 9.8 und das Android SDK, alle in `~/dev` entpackt, plus `~/dev/env.sh`, das sie in den Pfad legt.

## What it does
`source ~/dev/env.sh` setzt `JAVA_HOME`, `ANDROID_HOME`/`ANDROID_SDK_ROOT` und `PATH` (SDK-Kommandozeilenwerkzeuge, Platform-Tools mit adb, Gradle).

## How it does it
Installationen im Benutzerbereich, ohne sudo; das Qualitätstor lädt die Datei selbst.

## Where it sits in the pipeline
Unter jedem QuizApp-Build und jedem adb-Befehl.

## Who receives its output
[[quizapp-quality-gate]], Gradle-Builds und [[skill-adb-android-control]].
