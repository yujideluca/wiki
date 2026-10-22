---
id: quizweb-content
title: QuizWeb content.js and vocab/
aliases: [web content, web vocab]
kind: module
project: quizweb
status: active
location: QuizWeb:src/content.js
fed_by: [build-vocab, publish-content]
feeds: [quizweb-app]
sources: [QuizWeb:src/content.js, QuizWeb:vocab]
---

## What it is
Vocabulary → cards and distractors for the web twin, ported from the app's content package, plus the `vocab/` JSON files (the same files as the Android app; `errors.json` is built from its `errors.tsv`).

## What it does
Builds the deck: one card per word and mode, with the same deterministic distractors as [[distractor-factory]].

## How it does it
Plain ES module; [[check-web-sync]] makes sure `vocab/` equals the app's [[vocab-assets]].

## Where it sits in the pipeline
Between [[build-vocab]] output and [[quizweb-app]], which builds the deck at start.

## Who receives its output
[[quizweb-app]] (and through it [[quizweb-controller]]).
