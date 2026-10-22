---
id: vocab-assets
lang: de
source_hash: 3da281ba0589
title: Mitgelieferte Vokabel-JSON (assets)
---

## What it is
Die JSON-Dateien in der APK: `assets/vocab/*.json` (von [[build-vocab]] gebaut) und `assets/i18n/<de|pt|es>.json` (Übersetzungen der englischen Erklärungstexte).

## What it does
Geben der App den gesamten Fragenbestand offline und übersetzen Hinweise, Fehlertypen und Regeln in die App-Sprache.

## How it does it
Beim Start von `VocabularySource` und `ContentTranslationSource` gelesen, in [[quizapp-core]] geparst; `ContentTranslationsTest` schlägt fehl, wenn eine Übersetzung fehlt.

## Where it sits in the pipeline
Zwischen [[build-vocab]] und [[card-factory]].

## Who receives its output
[[card-factory]]; die i18n-Dateien werden nach [[quizweb]] kopiert.
