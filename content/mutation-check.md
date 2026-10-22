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
---

## What it is
A check that the tests really protect the rules: it plants faults on purpose and demands that a test fails for each one.

## What it does
Each mutant changes one constant, comparison or condition in the scheduler, grader, queue, session, store or the web twin; a surviving mutant means a requirement is not really protected. Source files are always restored.

## How it does it
Python; runs the matching test suite per mutant (`--web-only`, `--app-only`). Slow, so it runs in `promote` and every Monday in CI, not on every push.

## Where it sits in the pipeline
Inside [[quizapp-quality-gate]] when called with `--mutation`, which [[publish-apk]] `promote` does.

## Who receives its output
[[quizapp-quality-gate]].
