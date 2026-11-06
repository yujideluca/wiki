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
sources: [QuizApp:app/src/main/assets, QuizApp:core/src/main/java/dev/yuji/quiz/content/ContentPack.kt]
reviewed: 2026-11-06T23:20Z
---

## What it is
These are the [JSON](https://en.wikipedia.org/wiki/JSON) files (JavaScript Object Notation, a plain-text data format) inside the APK (Android Package, the app's installable file): `assets/vocab/*.json`, built by [[build-vocab]] (nouns, prepositions, verbs, errors and, since 2026-11-06, `fsp_cases.json` with the 58 simulated FSP exam cases; FSP is the Fachsprachprüfung, the German medical-language exam, [[fsp-case]]), and `assets/i18n/<de|pt|es>.json`, the translations of the English explanation texts. "Assets" are files packaged with an app that are not code. The file `assets/content.json` is the manifest of this built-in pack: a schema number (the file format, 2 since 2026-11-06), a content version (8 in app version 2.8.0) and the SHA-256 (Secure Hash Algorithm 256) fingerprint of each of the eight files ([[content-manifest]]).

## What it does
They are the built-in question pool, so the app has the whole pool offline from the first start; a newer pool downloaded from the update feed is used instead when it is newer ([[question-pack]]). They also translate hints, error types and rules into the language of the app.

## How it does it
They are read at start by `VocabularySource` and `ContentTranslationSource` and parsed in [[quizapp-core]]; the cases are parsed by [[fsp-case]]. The case texts are German only. The test `ContentTranslationsTest` fails if a translation is missing.

## Where it sits in the pipeline
Between [[build-vocab]] and the [[card-factory]].

## Who receives its output
The [[card-factory]]; the i18n files (i18n means "internationalisation", i followed by 18 letters and n: text in several languages) are also copied to [[quizweb]].
