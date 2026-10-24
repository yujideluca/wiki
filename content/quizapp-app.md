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
reviewed: 2026-10-22T16:33Z
---

## What it is
The `:app` module is the Android half of [[quizapp]]. It depends on [[quizapp-core]] and contains what only exists on a phone: the screens, the storage and the adapters (thin pieces of code that connect the pure logic to Android).

## What it does
It shows the study screens ([[study-view-model]]), stores progress and settings ([[progress-store]], [[training-store]], [[settings-store]]), reads the bundled vocabulary ([[vocab-assets]]), and checks for and installs updates ([[update-client]], [[apk-installer]]).

## How it does it
The screens use [Jetpack Compose](https://developer.android.com/compose) and [Material 3](https://m3.material.io/) (Google's design system), chosen in decision ADR-0002 (an ADR is an architecture decision record, a short note that keeps the reasons for a decision). `MainActivity` (an [Activity](https://developer.android.com/guide/components/activities/intro-activities) is one screen-hosting component of an Android app) hosts everything, applies the chosen language, refreshes the home screen every time the app is resumed and starts the update check. The [[study-controller]] is the single entry point the screens call. There are two build flavors, `stable` and `beta` ([[release-channels]]), both signed with the project's own key ([[signing-key]]).

## Where it sits in the pipeline
The outer layer, between the player and [[quizapp-core]].

## Who receives its output
Giovanni on the [[phone]]: the APK (Android Package, the installable file) built from this module is what gets installed.

## Functions
- `MainActivity`: hosts the user interface (UI), Back button, language, resume refresh, update check on start
- `ui/Screens.kt`: home, question, finished screens
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: settings and backup
- `ui/CalendarCard.kt`: the streak calendar card
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: the update popup and its state
- `ui/ScreenScale.kt`: scales layout with screen height
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: language choice
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: read assets
