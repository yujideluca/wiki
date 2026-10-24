---
id: settings-store
lang: de
source_hash: ea2eef65a238
title: SettingsStore (Thema und Sprache)
---

## What it is
Ein winziger Speicher für zwei Einstellungen von QuizApp: das Thema (System folgen, hell oder Nacht) und die Sprache (Systemstandard, English, Deutsch, Português (Brasil), Español).

## What it does
Er merkt sich beide Wahlen. Die Standardsprache folgt der Sprache des Handys und fällt auf Englisch zurück, wenn die Sprache des Handys nicht angeboten wird (`AppLanguage.effective`).

## How it does it
Er nutzt SharedPreferences (ein kleiner Schlüssel-Wert-Speicher, der in Android eingebaut ist). `MainActivity.attachBaseContext` umhüllt den Kontext der App mit der gespeicherten Sprache, und der Bildschirm erzeugt sich bei einem Sprachwechsel neu. Der Lerninhalt bleibt in jeder Oberflächensprache deutsch.

## Where it sits in the pipeline
Beim Start vom Modul [[quizapp-app]] gelesen; im Einstellungsbildschirm geändert.

## Who receives its output
Das [[study-view-model]] und jeder Bildschirm.
