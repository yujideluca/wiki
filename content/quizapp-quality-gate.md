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
reviewed: 2026-10-22T16:33Z
---

## What it is
`tools/quality_gate.sh` is the one definition of "passing" for [[quizapp]]. A release runs it, and CI (continuous integration, the automatic checks on GitHub) runs exactly the same script. If it fails, nothing is released.

## What it does
It has seven steps. (1) Unit, property, conformance and integration tests of the `:core` and `:app` modules, with coverage measured (property tests try many random inputs; conformance tests check that the app and the web twin agree). (2) Coverage thresholds. (3) The web twin's own tests. (4) The shared conformance vectors are identical in app and web ([[quizweb-conformance]]). (5) Requirement traceability: every requirement has a test ([[check-traceability]]). (6) Android lint (an automatic code-quality checker). (7) `pipeline-check --measure-only` together with the tests of its code ([[pipeline-check]], with the limits described in [[fitness-check]]), and the check that the manifest of the question pack matches its files ([[content-manifest]] with `--check`). With the option `--mutation` it also runs the [[mutation-check]]. It fails if it takes longer than 1200 seconds.

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script with `set -euo pipefail` (stop at the first error); it loads `~/dev/env.sh` on the laptop ([[android-toolchain]]), and every step is a command that exits with a non-zero code on failure.

## Where it sits in the pipeline
Before every publish ([[publish-apk]]) and on every push ([[quizapp-ci]]); it is derived from the [[template-quality-gate]].

## Who receives its output
[[publish-apk]] (go or no-go) and [[quizapp-ci]].

## Functions
- `check_coverage.py`: logic packages at 90 % line coverage, no file below 80 %
- `pipeline-check --traceability`: every requirement has a tagged test
- `mutation_check.py`: planted faults must be caught (`--mutation` only)
- `metrics.py`: delivery metrics in the style of DORA (DevOps Research and Assessment) for the monthly review (not part of the gate)
