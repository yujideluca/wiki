---
id: build-vocab
title: build_vocab.py
aliases: [vocabulary build]
kind: script
project: quizapp
status: active
location: QuizApp:tools/build_vocab.py
fed_by: [check-fsp-cases, vocab-tsv]
feeds: [check-errors-languagetool, content-manifest, quizweb-content, vocab-assets]
sources: [QuizApp:tools/build_vocab.py, QuizApp:tools/check_fsp_cases.py]
reviewed: 2026-11-06T23:20Z
---

## What it is
`build_vocab.py` is the script that checks the vocabulary tables ([[vocab-tsv]]) and turns them into the [JSON](https://en.wikipedia.org/wiki/JSON) files (JavaScript Object Notation, a plain-text data format) that the app carries inside it.

## What it does
It checks the structure, duplicates, allowed articles and cases, hints for ambiguous prepositions and the rule that each error sentence has exactly one wrong chunk. Since 2026-11-06 it also loads the simulated FSP exam cases (FSP: Fachsprachprüfung, the German medical-language exam; [[fsp-case]]): every case of `tools/data/fsp_cases.tsv` must have its file in `tools/data/fsp/` and pass [[check-fsp-cases]], and a case file missing from the list is an error. It writes `assets/vocab/*.json` (the cases in list order, ordered by area of medicine, into `fsp_cases.json`) and refreshes the manifest of the question pool through [[content-manifest]]. It exits with a non-zero code on any problem, so bad data cannot reach the app. On success it prints the counts, ending with `| fsp cases: <n>`. The option `--verify-nouns` cross-checks genders and plurals against the German Wiktionary (de.wiktionary.org).

## How it does it
It is a [Python](https://www.python.org/) script. It reads [[vocab-tsv]]; the corrected error sentences are additionally checked by [[check-errors-languagetool]].

## Where it sits in the pipeline
Between [[vocab-tsv]] and [[vocab-assets]]; its JSON is copied into [[quizweb]] as well.

## Who receives its output
[[vocab-assets]] (the app) and [[quizweb-content]] (the `vocab/` folder of the web twin).
