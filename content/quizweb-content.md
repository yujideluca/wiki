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
reviewed: 2026-10-22T16:33Z
---

## What it is
`content.js` and the `vocab/` folder of [[quizweb]]: the code that turns vocabulary into cards and wrong options for the web twin, ported from the content package of the app, plus the `vocab/` JSON files (JSON, JavaScript Object Notation, is a plain-text data format). They are the same files as in the Android app; `errors.json` is built from `errors.tsv`.

## What it does
It builds the deck: one card per word and mode, with the same deterministic wrong options as the [[distractor-factory]].

## How it does it
It is a plain ES module (the standard JavaScript file format). [[check-web-sync]] makes sure that `vocab/` equals the app's [[vocab-assets]].

## Where it sits in the pipeline
Between the output of [[build-vocab]] and [[quizweb-app]], which builds the deck at start.

## Who receives its output
[[quizweb-app]] (and through it the [[quizweb-controller]]).
