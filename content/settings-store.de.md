---
id: settings-store
lang: de
source_hash: 3a96c21f4463
title: SettingsStore (Design und Sprache)
aliases: [Spracheinstellung]
---

## What it is
Der kleine Speicher für Design (System / hell / Nacht) und Sprache (Systemstandard, English, Deutsch, Português (Brasil), Español) von QuizApp.

## What it does
Merkt sich beides; die Standardsprache folgt dem Handy und fällt auf Englisch zurück (`AppLanguage.effective`).

## How it does it
SharedPreferences. `MainActivity.attachBaseContext` versieht den Kontext mit der gespeicherten Sprache, und die Activity baut sich bei einer Änderung neu auf. Lerninhalte bleiben in jeder Sprache deutsch.

## Where it sits in the pipeline
Beim Start von [[quizapp-app]] gelesen, in den Einstellungen geändert.

## Who receives its output
[[study-view-model]] und alle Bildschirme.
