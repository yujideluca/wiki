---
id: vocab-assets
lang: de
source_hash: 5bc0bf4d7909
title: Mitgeliefertes Vokabel-JSON (Assets)
---

## What it is
Das sind die [JSON](https://en.wikipedia.org/wiki/JSON)-Dateien (JavaScript Object Notation, ein Klartext-Datenformat) in der APK (Android Package, der installierbaren Datei der App): `assets/vocab/*.json`, gebaut von [[build-vocab]], und `assets/i18n/<de|pt|es>.json`, die Übersetzungen der englischen Erklärtexte. „Assets“ sind mit einer App verpackte Dateien, die kein Code sind. Die Datei `assets/content.json` ist das Manifest dieses eingebauten Pakets: eine Schema-Nummer (das Dateiformat), eine Inhaltsversion und der SHA-256-Fingerabdruck (Secure Hash Algorithm 256) jeder Datei ([[content-manifest]]).

## What it does
Sie sind der eingebaute Fragenpool, die App hat also ab dem ersten Start den ganzen Pool offline; ein neuerer, aus dem Update-Feed geladener Pool wird stattdessen benutzt, wenn er neuer ist ([[question-pack]]). Außerdem übersetzen sie Hinweise, Fehlertypen und Regeln in die Sprache der App.

## How it does it
Sie werden beim Start von `VocabularySource` und `ContentTranslationSource` gelesen und in [[quizapp-core]] geparst. Der Test `ContentTranslationsTest` schlägt fehl, wenn eine Übersetzung fehlt.

## Where it sits in the pipeline
Zwischen [[build-vocab]] und der [[card-factory]].

## Who receives its output
Die [[card-factory]]; die i18n-Dateien (i18n steht für „Internationalisierung“, i, dann 18 Buchstaben, dann n: Text in mehreren Sprachen) werden auch nach [[quizweb]] kopiert.
