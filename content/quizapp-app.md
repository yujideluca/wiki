---
id: quizapp-app
title: QuizApp :app module
aliases: [:app, Android module]
kind: module
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz
fed_by: [drachenkurve, quizapp-core]
feeds: [phone]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz, QuizApp:app/src/debug]
---

## What it is
The Android half of [[quizapp]] (Gradle module `:app`, depends on [[quizapp-core]]): screens, storage and the Android adapters.

## What it does
Shows the study screens ([[study-view-model]]), stores progress and settings ([[progress-store]], [[training-store]], [[settings-store]]), reads the bundled vocabulary ([[vocab-assets]]), checks for and installs updates ([[update-client]], [[apk-installer]]).

## How it does it
Jetpack Compose + Material 3 (ADR-0002). `MainActivity` hosts everything, applies the chosen language, refreshes the home screen on every resume and starts the update check; [[study-controller]] is the single facade the UI calls. Two build flavors, `stable` and `beta` ([[release-channels]]), signed with the project's own key ([[signing-key]]).

## Where it sits in the pipeline
The outer layer, between the player and [[quizapp-core]].

## Who receives its output
Giovanni on the [[phone]]: the APK is what gets installed.

## Functions
- `MainActivity`: hosts the UI, Back button, language, resume refresh, update check on start
- `ui/Screens.kt`: home, question, finished screens
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: settings and backup
- `ui/CalendarCard.kt`: the streak calendar card
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: the update popup and its state
- `ui/ScreenScale.kt`: scales layout with screen height
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: language choice
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: read assets
