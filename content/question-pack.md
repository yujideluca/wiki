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
The question pack (code name `ContentPack`) is the question pool of [[quizapp]] seen as one versioned package: seven files (`vocab/*.json` and `i18n/*.json`) described by a manifest, `content.json` (decision ADR-0012, 2026-10-22; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). Because it is a package, it can be replaced without releasing a new app.

## What it does
The manifest says the file format (`schema`, currently 1, equal to `CONTENT_SCHEMA`), the pool version (`contentVersion`, which rises by one whenever any file changes) and the SHA-256 of every file (SHA-256, Secure Hash Algorithm 256, a fingerprint of the file's content). The function `validateContentPack` accepts a pack only when every file is listed, matches its fingerprint and can be parsed, and every mode still has at least one question. `shouldDownloadContent` decides whether a pack found on the feed is worth downloading.

## How it does it
It is pure Kotlin in [[quizapp-core]], tested by `ContentPackTest` and by five mutants in the [[mutation-check]] (requirements QP-1 to QP-4). The pack built into the app is `assets/content.json`, maintained by [[content-manifest]]. A new mode or a new field in the files is not a pool change: it needs an app release and a higher schema, which older apps ignore.

## Where it sits in the pipeline
Between the content build ([[build-vocab]], [[content-manifest]]) and the app's [[question-pool-updater]].

## Who receives its output
The [[question-pool-updater]], which uses it to check and install downloaded packs.
