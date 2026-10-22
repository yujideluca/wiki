---
id: settings-store
title: SettingsStore (theme and language)
aliases: [AppLanguage, language setting]
kind: function
project: quizapp
status: active
location: QuizApp:app/src/main/java/dev/yuji/quiz/data/SettingsStore.kt
fed_by: []
feeds: [study-view-model]
sources: [QuizApp:app/src/main/java/dev/yuji/quiz/data/SettingsStore.kt, QuizApp:app/src/main/java/dev/yuji/quiz/data/AppLanguage.kt]
---

## What it is
The tiny store of QuizApp's theme (system / light / night) and language (system default, English, Deutsch, Português (Brasil), Español).

## What it does
Remembers both; the language default follows the phone and falls back to English (`AppLanguage.effective`).

## How it does it
SharedPreferences. `MainActivity.attachBaseContext` wraps the context with the stored language and the activity recreates itself when it changes. Learning content stays German in every language.

## Where it sits in the pipeline
Read at start by [[quizapp-app]], changed from Settings.

## Who receives its output
[[study-view-model]] and every screen.
