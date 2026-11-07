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
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/ContentPack.kt, QuizApp:docs/adr/0014-fsp-case-simulations.md, QuizApp:app/src/main/assets/content.json, QuizApp:docs/adr/0012-downloadable-question-pool.md, QuizApp:tools/mutation_check.py, QuizApp:core/src/test/java/dev/yuji/quiz/content/ContentPackTest.kt]
reviewed: 2026-11-07T17:57Z
---

## What it is
The question pack (code name `ContentPack`) is the question pool of [[quizapp]] seen as one versioned package: eight files (five `vocab/*.json`, among them the simulated exam cases `vocab/fsp_cases.json` since 2026-11-06, and three `i18n/*.json`) described by a manifest, `content.json` (decision ADR-0012, 2026-10-22; an ADR is an architecture decision record, a short note that keeps the reasons for a decision). Because it is a package, it can be replaced without releasing a new app.

## What it does
The manifest says the file format (`schema`, equal to `CONTENT_SCHEMA`: 3 since app version 2.9.0 of 2026-11-07, 2 since 2.8.0 of 2026-11-06, 1 before), the pool version (`contentVersion`, which rises whenever any file changes (QP-4; the committed pack has version 9)) and the SHA-256 of every file (SHA-256, Secure Hash Algorithm 256, a fingerprint of the file's content). The function `validateContentPack` accepts a pack only when every file is listed, matches its fingerprint and can be parsed, and every mode still has at least one question. `shouldDownloadContent` decides whether a pack found on the feed is worth downloading: only when its schema is the one the app reads and its version is higher. `fspCasesFrom` reads the FSP cases of a pack (FSP: Fachsprachprüfung, the German medical-language exam; [[fsp-case]]), and `buildDeckFrom` builds the deck of all six modes. Schema 2 exists because of those cases (decision ADR-0014): an app that reads schema 1 (version 2.7.1 and older) ignores schema-2 packs and keeps its built-in pool until it is updated. Since 2026-11-07 both branches of the feed, beta and stable, hold pool 9 with schema 3 ([[release-feed]]).

## How it does it
It is pure Kotlin in [[quizapp-core]], tested by `ContentPackTest` and by five mutants in the [[mutation-check]] (requirements QP-1 to QP-4): four planted in `ContentPack.kt` (a same-version pack downloaded again, an outdated pack preferred to the built-in one, checksums not compared, a pack that empties a mode accepted) and one in the app's `ContentStore.kt` (an outdated or unreadable downloaded pack kept on disk). All five are in `tools/mutation_check.py`; the web-twin fault changed there on 2026-11-02 does not concern the pack. The pack built into the app is `assets/content.json`, maintained by [[content-manifest]]. A new mode or a new field in the files is not a pool change: it needs an app release and a higher schema, which older apps ignore.

## Where it sits in the pipeline
Between the content build ([[build-vocab]], [[content-manifest]]) and the app's [[question-pool-updater]].

## Who receives its output
The [[question-pool-updater]], which uses it to check and install downloaded packs.
