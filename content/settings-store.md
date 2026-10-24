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
reviewed: 2026-10-22T16:33Z
---

## What it is
A tiny store for two of QuizApp's settings: the theme (follow the system, light or night) and the language (system default, English, Deutsch, Português (Brasil), Español).

## What it does
It remembers both choices. The default language follows the phone's language and falls back to English when the phone's language is not offered (`AppLanguage.effective`).

## How it does it
It uses SharedPreferences (a small key-value store built into Android). `MainActivity.attachBaseContext` wraps the app's context with the stored language, and the screen recreates itself when the language changes. The learning content stays German in every interface language.

## Where it sits in the pipeline
Read at start by the [[quizapp-app]] module; changed from the settings screen.

## Who receives its output
The [[study-view-model]] and every screen.
