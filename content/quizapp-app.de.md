---
id: quizapp-app
lang: de
source_hash: ccb5f8b02f0c
title: QuizApp-Modul :app
---

## What it is
Das Modul `:app` ist die Android-Hälfte von [[quizapp]]. Es hängt von [[quizapp-core]] ab und enthält, was nur auf einem Handy existiert: die Bildschirme, den Speicher und die Adapter (dünne Codestücke, die die reine Logik mit Android verbinden).

## What it does
Es zeigt die Lernbildschirme ([[study-view-model]]), speichert Fortschritt und Einstellungen ([[progress-store]], [[training-store]], [[settings-store]]), liest den Fragenpool, den eingebauten ([[vocab-assets]]) oder einen neueren, aus dem Update-Feed geladenen ([[question-pool-updater]]) und prüft auf Updates und installiert sie ([[update-client]], [[apk-installer]]).

## How it does it
Die Bildschirme nutzen [Jetpack Compose](https://developer.android.com/compose) und [Material 3](https://m3.material.io/) (Googles Designsystem), gewählt in Entscheidung ADR-0002 (ein ADR ist ein Architecture Decision Record, eine kurze Notiz, die die Gründe einer Entscheidung festhält). `MainActivity` (eine [Activity](https://developer.android.com/guide/components/activities/intro-activities) ist eine bildschirmtragende Komponente einer Android-App) trägt alles, wendet die gewählte Sprache an, aktualisiert den Startbildschirm bei jeder Rückkehr in die App und startet die Update-Prüfung. Der [[study-controller]] ist der einzige Einstiegspunkt, den die Bildschirme aufrufen. Es gibt zwei Build-Varianten, `stable` und `beta` ([[release-channels]]), beide mit dem eigenen Schlüssel des Projekts signiert ([[signing-key]]).

## Where it sits in the pipeline
Die äußere Schicht, zwischen dem Lernenden und [[quizapp-core]].

## Who receives its output
Giovanni auf dem [[phone]]: Die aus diesem Modul gebaute APK (Android Package, die installierbare Datei) wird installiert.

## Functions
- `MainActivity`: trägt die Benutzeroberfläche (UI), Zurück-Taste, Sprache, Auffrischung bei Rückkehr, Update-Prüfung beim Start
- `ui/Screens.kt`: Start-, Frage- und Abschlussbildschirm
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: Einstellungen und Sicherung
- `ui/CalendarCard.kt`: die Karte des Serienkalenders
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: das Update-Popup und sein Zustand
- `ui/UiState.kt`, `ui/AppUpdater.kt`: die Bildschirmzustände und der Update-Ablauf (den Feed fragen, das Popup, die APK laden), aus dem ViewModel herausgelöst
- `ui/QuestionPool.kt`, `data/ContentStore.kt`, `data/ContentUpdater.kt`: der benutzte Fragenpool, das in `files/content` gehaltene geladene Paket und die Prüfung, die ein neueres Paket nur installiert, wenn es gültig ist
- `ui/ScreenScale.kt`: skaliert das Layout mit der Bildschirmhöhe
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: Sprachwahl
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: Assets lesen
