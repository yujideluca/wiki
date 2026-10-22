---
id: fitness-check
title: Fitness functions
aliases: [fitness_check.py, architecture checks]
kind: script
project: quizapp
status: active
location: QuizApp:tools/fitness_check.py
fed_by: []
feeds: [quizapp-quality-gate]
sources: [QuizApp:tools/fitness_check.py]
---

## What it is
Automatic checks that the architecture has not drifted ("fitness functions", from evolutionary architecture; ADR-0009).

## What it does
1. The `:core` module stays pure Kotlin (no Android plugin or dependency). 2. No Kotlin file grows past 400 lines. 3. With `--apk`, the release APK stays below 3 MB.

## How it does it
Python; a limit is raised only on purpose, in the same commit as an ADR or decision-log row that says why.

## Where it sits in the pipeline
Step 7 of [[quizapp-quality-gate]]; reviewed in the [[monthly-architecture-review]].

## Who receives its output
[[quizapp-quality-gate]].
