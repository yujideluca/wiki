---
id: question-pack
title: Question pack (ContentPack)
aliases: [content pack, content.json, question pool, CONTENT_SCHEMA]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/content/ContentPack.kt
fed_by: [content-manifest]
feeds: [question-pool-updater]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/ContentPack.kt, QuizApp:app/src/main/assets/content.json, QuizApp:docs/adr/0012-downloadable-question-pool.md]
---

## What it is
The question pool of [[quizapp]] as one versioned set of seven files (`vocab/*.json` and `i18n/*.json`) described by a manifest, `content.json` (ADR-0012, 2026-10-22).

## What it does
The manifest says the file format (`schema`, 1 for now = `CONTENT_SCHEMA`), the pool version (`contentVersion`, rises by one whenever any file changes) and the SHA-256 of every file. `validateContentPack` accepts a pack only when every file is listed, matches its checksum, parses, and every mode keeps at least one question; `shouldDownloadContent` decides whether a pack on the feed is worth downloading.

## How it does it
Pure Kotlin in [[quizapp-core]], tested by `ContentPackTest` and five mutants in [[mutation-check]] (requirements QP-1..QP-4). The pack built into the APK is `assets/content.json`, kept by [[content-manifest]]. A new mode or a new field in the files is not a pool change: it needs an app release and a higher schema, which older apps ignore.

## Where it sits in the pipeline
Between the content build ([[build-vocab]], [[content-manifest]]) and the app's [[question-pool-updater]].

## Who receives its output
[[question-pool-updater]], which uses it to check and install downloaded packs.
