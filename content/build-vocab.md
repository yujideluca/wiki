---
id: build-vocab
title: build_vocab.py
aliases: [vocabulary build]
kind: script
project: quizapp
status: active
location: QuizApp:tools/build_vocab.py
fed_by: [vocab-tsv]
feeds: [check-errors-languagetool, content-manifest, quizweb-content, vocab-assets]
sources: [QuizApp:tools/build_vocab.py]
---

## What it is
The script that validates the TSV vocabulary and writes the JSON the app bundles.

## What it does
Checks structure, duplicates, allowed articles and cases, hints for ambiguous prepositions and the one-wrong-chunk rule of error sentences; writes `assets/vocab/*.json` and refreshes the pool manifest through [[content-manifest]]. Exits non-zero on any problem, so bad data cannot reach the app. `--verify-nouns` cross-checks genders and plurals against de.wiktionary.org.

## How it does it
Python; reads [[vocab-tsv]]; the corrected error sentences are also checked by [[check-errors-languagetool]].

## Where it sits in the pipeline
Between [[vocab-tsv]] and [[vocab-assets]]; its JSON is copied into [[quizweb]] too.

## Who receives its output
[[vocab-assets]] (the app) and [[quizweb-content]] (the web twin's `vocab/`).
