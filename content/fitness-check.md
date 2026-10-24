---
id: fitness-check
title: Fitness functions
aliases: [fitness_check.py, architecture checks]
kind: data
project: quizapp
status: active
location: QuizApp:pipeline-check.toml
fed_by: []
feeds: [quizapp-quality-gate, pipeline-check]
sources: [QuizApp:pipeline-check.toml]
---

## What it is
Automatic checks that the architecture has not drifted ("fitness functions", from evolutionary architecture; ADR-0009).

## What it does
1. The `:core` module stays pure Kotlin (no Android plugin or dependency). 2. No Kotlin file grows past 400 lines. 3. With `--apk`, the release APK stays below 3 MB.

## How it does it
Since 2026-10-24 the limits live in `pipeline-check.toml` and [[pipeline-check]] measures them (it replaced `fitness_check.py`), with a warning from 80 % of a limit. A limit is raised only on purpose, in the same commit as an ADR or decision-log row that says why.

## Where it sits in the pipeline
Step 7 of [[quizapp-quality-gate]] (`pipeline-check --measure-only`) and the CI job; reviewed in the [[monthly-architecture-review]].

## Who receives its output
[[quizapp-quality-gate]].
