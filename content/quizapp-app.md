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
reviewed: 2026-10-25T02:03Z
---

## What it is
The `:app` module is the Android half of [[quizapp]]. It depends on [[quizapp-core]] and contains what only exists on a phone: the screens, the storage and the adapters (thin pieces of code that connect the pure logic to Android).

## What it does
It shows the study screens ([[study-view-model]]), stores progress and settings ([[progress-store]], [[training-store]], [[settings-store]]), reads the question pool, the built-in one ([[vocab-assets]]) or a newer one downloaded from the update feed ([[question-pool-updater]]), and checks for and installs updates ([[update-client]], [[apk-installer]]).

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
- `ui/UiState.kt`, `ui/AppUpdater.kt`: the screen states, and the update flow (asking the feed, the popup, downloading the APK) moved out of the view model
- `ui/QuestionPool.kt`, `data/ContentStore.kt`, `data/ContentUpdater.kt`: the question pool in use, the downloaded pack kept in `files/content`, and the check that installs a newer pack only when it is valid
- `ui/ScreenScale.kt`: scales layout with screen height
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: language choice
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: read assets
