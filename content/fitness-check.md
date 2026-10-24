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
reviewed: 2026-10-22T16:33Z
---

## What it is
A "fitness function" is an automatic check that a quality of the design has not drifted over time. The idea comes from "evolutionary architecture" ([Building Evolutionary Architectures](https://www.thoughtworks.com/insights/books/building-evolutionary-architectures); see also [fitness function](https://en.wikipedia.org/wiki/Fitness_function)) and is recorded in decision ADR-0009 of QuizApp (an ADR is an architecture decision record, a short note that keeps the reasons for a decision). The page's configuration is the file `pipeline-check.toml` of [[quizapp]].

## What it does
It checks three limits: (1) the `:core` module stays pure Kotlin, with no Android plugin or dependency; (2) no Kotlin file grows past 400 lines; (3) with the option `--apk`, the release APK (the installable Android package) stays below 3 MB.

## How it does it
Since 2026-10-24 the limits live in `pipeline-check.toml`, and [[pipeline-check]] measures them (it replaced the script `fitness_check.py`), giving a warning from 80 % of a limit. A limit is raised only on purpose, in the same commit as an ADR or decision-log row that says why. That way a number cannot creep upward unnoticed.

## Where it sits in the pipeline
Step 7 of [[quizapp-quality-gate]] (`pipeline-check --measure-only`) and of the continuous integration (CI) job; reviewed in the [[monthly-architecture-review]].

## Who receives its output
[[quizapp-quality-gate]].
