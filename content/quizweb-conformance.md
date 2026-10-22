---
id: quizweb-conformance
title: Conformance vectors (app = web)
aliases: [shared vectors, conformance tests]
kind: data
project: quizweb
status: active
location: QuizWeb:tests/conformance
fed_by: []
feeds: [quizapp-quality-gate]
sources: [QuizWeb:tests/conformance, QuizApp:core/src/test/resources/conformance]
---

## What it is
Hand-computed test cases (`scheduler.json`, `daily_bar.json`) that both [[quizapp]] and [[quizweb]] must pass, so the two implementations cannot drift apart.

## What it does
Each vector is an input history and the exact expected schedule or progress bar.

## How it does it
The same files live in both repos; step 4 of [[quizapp-quality-gate]] fails unless they are byte-identical (`cmp`).

## Where it sits in the pipeline
Between the two domain layers: [[spaced-repetition-scheduler]] and [[quizweb-domain]].

## Who receives its output
Both test suites and [[quizapp-quality-gate]].
