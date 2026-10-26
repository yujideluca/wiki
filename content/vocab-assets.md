---
id: vocab-assets
title: Bundled vocabulary JSON (assets)
aliases: [assets/vocab, assets/i18n]
kind: data
project: quizapp
status: active
location: QuizApp:app/src/main/assets
fed_by: [build-vocab]
feeds: [card-factory]
sources: [QuizApp:app/src/main/assets]
reviewed: 2026-10-25T21:20Z
---

## What it is
These are the [JSON](https://en.wikipedia.org/wiki/JSON) files (JavaScript Object Notation, a plain-text data format) inside the APK (Android Package, the app's installable file): `assets/vocab/*.json`, built by [[build-vocab]], and `assets/i18n/<de|pt|es>.json`, the translations of the English explanation texts. "Assets" are files packaged with an app that are not code. The file `assets/content.json` is the manifest of this built-in pack: a schema number (the file format), a content version and the SHA-256 (Secure Hash Algorithm 256) fingerprint of each file ([[content-manifest]]).

## What it does
They are the built-in question pool, so the app has the whole pool offline from the first start; a newer pool downloaded from the update feed is used instead when it is newer ([[question-pack]]). They also translate hints, error types and rules into the language of the app.

## How it does it
They are read at start by `VocabularySource` and `ContentTranslationSource` and parsed in [[quizapp-core]]. The test `ContentTranslationsTest` fails if a translation is missing.

## Where it sits in the pipeline
Between [[build-vocab]] and the [[card-factory]].

## Who receives its output
The [[card-factory]]; the i18n files (i18n means "internationalisation", i followed by 18 letters and n: text in several languages) are also copied to [[quizweb]].
