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
reviewed: 2026-10-22T16:33Z
---

## What it is
"Conformance vectors" are hand-computed test cases that both [[quizapp]] and [[quizweb]] must pass (`scheduler.json`, `daily_bar.json`). Because the two apps are written in different languages, the shared cases make sure the two implementations cannot drift apart.

## What it does
Each vector is an input history together with the exact expected schedule or progress bar, worked out by hand and not by the code under test.

## How it does it
The same files live in both repositories. Step 4 of the [[quizapp-quality-gate]] fails unless they are byte-identical (checked with `cmp`, a command that compares two files).

## Where it sits in the pipeline
Between the two domain layers: the [[spaced-repetition-scheduler]] and [[quizweb-domain]].

## Who receives its output
Both test suites and the [[quizapp-quality-gate]].
