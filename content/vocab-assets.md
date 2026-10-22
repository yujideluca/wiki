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
---

## What it is
The JSON files inside the APK: `assets/vocab/*.json` (built by [[build-vocab]]) and `assets/i18n/<de|pt|es>.json` (translations of the English explanation text).

## What it does
Give the app its whole question pool offline, and translate hints, error types and rules into the app language.

## How it does it
Read at start by `VocabularySource` and `ContentTranslationSource`, parsed in [[quizapp-core]]; `ContentTranslationsTest` fails when a translation is missing.

## Where it sits in the pipeline
Between [[build-vocab]] and [[card-factory]].

## Who receives its output
[[card-factory]]; the i18n files are copied to [[quizweb]].
