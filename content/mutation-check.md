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
sources: [QuizApp:tools/mutation_check.py, QuizApp:core/src/main/java/dev/yuji/quiz/content/FspCase.kt]
reviewed: 2026-11-06T23:20Z
---

## What it is
Mutation testing ([mutation testing](https://en.wikipedia.org/wiki/Mutation_testing)) asks: "if I deliberately break the program, does a test notice?" `mutation_check.py` plants faults on purpose and demands that a test fails for each one. If a planted fault ("mutant") goes unnoticed, the tests do not really protect that rule.

## What it does
Each mutant changes one constant, comparison or condition in the scheduler, grader, study pipeline, session, daily goal, update check, progress and training stores, study controller or question-pool loader and store of [[quizapp]] ([[question-pack]]), or in the web twin. On 2026-11-06 there were 43 mutants for the app and 9 for the web twin. The 7 added that day guard the FSP-Fälle mode ([[fsp-case]], simulated cases of the FSP, Fachsprachprüfung, the German medical-language exam): pass mark lowered to 70 %, exactly 80 % failing, a new case graded EASY, the HARD boundary moved, a step solved after a wrong pick counted as right, picks after solving changing the step, and a case graded by the time it took instead of its score ([[study-session]]). A surviving mutant means a requirement is not really protected. The source files are always restored afterwards. A mutant is found by its exact text; if that text has changed in the code (for example the web twin gained a guard), the mutant is reported as "not applicable" and counts as a survivor until its search text is updated.

## How it does it
A [Python](https://www.python.org/) script that runs the matching test suite for each mutant (`--web-only` and `--app-only` limit it to one side). It is slow, so it runs in `promote` and every Monday in CI (continuous integration, automatic checks on GitHub), not on every push.

## Where it sits in the pipeline
Inside the [[quizapp-quality-gate]] when called with `--mutation`, which [[publish-apk]] `promote` does.

## Who receives its output
The [[quizapp-quality-gate]].
