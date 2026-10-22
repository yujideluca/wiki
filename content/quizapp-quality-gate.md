---
id: quizapp-quality-gate
title: QuizApp quality gate
aliases: [quality_gate.sh, gate]
kind: script
project: quizapp
status: active
location: QuizApp:tools/quality_gate.sh
fed_by: [android-toolchain, check-traceability, content-manifest, fitness-check, mutation-check, quizweb-conformance, template-quality-gate]
feeds: [publish-apk, quizapp-ci]
sources: [QuizApp:tools/quality_gate.sh]
---

## What it is
`tools/quality_gate.sh`: the one definition of "passing" for [[quizapp]]. A release runs it and CI runs exactly the same script.

## What it does
Seven steps: core and app unit/property/conformance/integration tests with coverage; coverage thresholds; the web twin's tests; conformance vectors identical in app and web ([[quizweb-conformance]]); requirement traceability ([[check-traceability]]); Android lint; fitness functions ([[fitness-check]]); the question pack manifest matches its files ([[content-manifest]] `--check`). With `--mutation` it also runs [[mutation-check]]. It fails if it takes more than 1200 s.

## How it does it
Bash, `set -euo pipefail`, sources `~/dev/env.sh` ([[android-toolchain]]) on the laptop; every step is a command that exits non-zero on failure.

## Where it sits in the pipeline
Before every publish ([[publish-apk]]) and on every push ([[quizapp-ci]]); derived from [[template-quality-gate]].

## Who receives its output
[[publish-apk]] (go / no-go) and [[quizapp-ci]].

## Functions
- `check_coverage.py`: logic packages at 90 % line coverage, no file below 80 %
- `check_traceability.py`: every requirement has a tagged test
- `fitness_check.py`: architecture limits
- `mutation_check.py`: planted faults must be caught (`--mutation` only)
- `metrics.py`: DORA-style delivery metrics for the monthly review (not part of the gate)
