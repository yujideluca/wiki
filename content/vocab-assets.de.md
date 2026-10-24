---
id: vocab-assets
lang: de
source_hash: df99b7d0297a
title: Mitgeliefertes Vokabel-JSON (Assets)
---

## What it is
Das sind die [JSON](https://en.wikipedia.org/wiki/JSON)-Dateien (JavaScript Object Notation, ein Klartext-Datenformat) in der APK (Android Package, der installierbaren Datei der App): `assets/vocab/*.json`, gebaut von [[build-vocab]], und `assets/i18n/<de|pt|es>.json`, die Übersetzungen der englischen Erklärtexte. „Assets“ sind mit einer App verpackte Dateien, die kein Code sind.

## What it does
Sie geben der App ihren gesamten Fragenpool offline und übersetzen Hinweise, Fehlertypen und Regeln in die Sprache der App.

## How it does it
Sie werden beim Start von `VocabularySource` und `ContentTranslationSource` gelesen und in [[quizapp-core]] geparst. Der Test `ContentTranslationsTest` schlägt fehl, wenn eine Übersetzung fehlt.

## Where it sits in the pipeline
Zwischen [[build-vocab]] und der [[card-factory]].

## Who receives its output
Die [[card-factory]]; die i18n-Dateien (i18n steht für „Internationalisierung“, i, dann 18 Buchstaben, dann n: Text in mehreren Sprachen) werden auch nach [[quizweb]] kopiert.
