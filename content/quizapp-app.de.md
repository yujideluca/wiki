---
id: quizapp-app
lang: de
source_hash: 0fb1ee33cb85
title: QuizApp-Modul :app
---

## What it is
Die Android-Hälfte von [[quizapp]] (Gradle-Modul `:app`, hängt von [[quizapp-core]] ab): Bildschirme, Speicher und Android-Adapter.

## What it does
Zeigt die Lernbildschirme ([[study-view-model]]), speichert Fortschritt und Einstellungen ([[progress-store]], [[training-store]], [[settings-store]]), liest die mitgelieferten Vokabeln ([[vocab-assets]]), sucht und installiert Updates ([[update-client]], [[apk-installer]]).

## How it does it
Jetpack Compose + Material 3 (ADR-0002). `MainActivity` trägt alles, setzt die gewählte Sprache, aktualisiert den Startbildschirm bei jedem Fortsetzen und startet die Update-Prüfung; [[study-controller]] ist die einzige Fassade, die die Oberfläche aufruft. Zwei Build-Varianten, `stable` und `beta` ([[release-channels]]), signiert mit dem projekteigenen Schlüssel ([[signing-key]]).

## Where it sits in the pipeline
Die äußere Schicht, zwischen Spieler und [[quizapp-core]].

## Who receives its output
Giovanni auf dem [[phone]]: Die APK wird installiert.

## Functions
- `MainActivity`: hosts the UI, Back button, language, resume refresh, update check on start
- `ui/Screens.kt`: home, question, finished screens
- `ui/SettingsScreen.kt`, `ui/BackupSection.kt`: settings and backup
- `ui/CalendarCard.kt`: the streak calendar card
- `ui/UpdatePrompt.kt`, `ui/UpdateReducer.kt`: the update popup and its state
- `ui/ScreenScale.kt`: scales layout with screen height
- `android/LocaleContext.kt`, `data/AppLanguage.kt`: language choice
- `data/VocabularySource.kt`, `data/ContentTranslationSource.kt`: read assets
