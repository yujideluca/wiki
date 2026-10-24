---
id: mutation-check
title: Mutation check
aliases: [mutation_check.py, mutants]
kind: script
project: quizapp
status: active
location: QuizApp:tools/mutation_check.py
fed_by: []
feeds: [quizapp-quality-gate]
sources: [QuizApp:tools/mutation_check.py]
reviewed: 2026-10-22T16:33Z
---

## What it is
Mutation testing ([mutation testing](https://en.wikipedia.org/wiki/Mutation_testing)) asks: "if I deliberately break the program, does a test notice?" `mutation_check.py` plants faults on purpose and demands that a test fails for each one. If a planted fault ("mutant") goes unnoticed, the tests do not really protect that rule.

## What it does
Each mutant changes one constant, comparison or condition in the scheduler, grader, queue, session or store of [[quizapp]], or in the web twin. A surviving mutant means a requirement is not really protected. The source files are always restored afterwards.

## How it does it
A [Python](https://www.python.org/) script that runs the matching test suite for each mutant (`--web-only` and `--app-only` limit it to one side). It is slow, so it runs in `promote` and every Monday in CI (continuous integration, automatic checks on GitHub), not on every push.

## Where it sits in the pipeline
Inside the [[quizapp-quality-gate]] when called with `--mutation`, which [[publish-apk]] `promote` does.

## Who receives its output
The [[quizapp-quality-gate]].
