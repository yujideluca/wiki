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
reviewed: 2026-10-22T16:33Z
---

## What it is
`build_vocab.py` is the script that checks the vocabulary tables ([[vocab-tsv]]) and turns them into the [JSON](https://en.wikipedia.org/wiki/JSON) files (JavaScript Object Notation, a plain-text data format) that the app carries inside it.

## What it does
It checks the structure, duplicates, allowed articles and cases, hints for ambiguous prepositions and the rule that each error sentence has exactly one wrong chunk. It writes `assets/vocab/*.json` and refreshes the manifest of the question pool through [[content-manifest]]. It exits with a non-zero code on any problem, so bad data cannot reach the app. The option `--verify-nouns` cross-checks genders and plurals against the German Wiktionary (de.wiktionary.org).

## How it does it
It is a [Python](https://www.python.org/) script. It reads [[vocab-tsv]]; the corrected error sentences are additionally checked by [[check-errors-languagetool]].

## Where it sits in the pipeline
Between [[vocab-tsv]] and [[vocab-assets]]; its JSON is copied into [[quizweb]] as well.

## Who receives its output
[[vocab-assets]] (the app) and [[quizweb-content]] (the `vocab/` folder of the web twin).
