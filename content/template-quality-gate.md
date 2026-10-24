---
id: template-quality-gate
title: Template quality gate
aliases: [quality_gate.sh template]
kind: script
project: project-template
status: active
location: project-template:tools/quality_gate.sh
fed_by: [check-traceability]
feeds: [quizapp-quality-gate, wiki-quality-gate]
sources: [project-template:tools/quality_gate.sh]
reviewed: 2026-10-22T16:33Z
---

## What it is
A quality gate is one script that decides whether a project is "passing". This is the skeleton of every project's `tools/quality_gate.sh`: the single definition of "passing", used both before a release and by CI (continuous integration, automatic checks on every push). Having one definition means the checks on the laptop and on GitHub can never disagree.

## What it does
It has three steps for each project to fill in: build and tests; requirement traceability, meaning every requirement has a test and every test points to a requirement ([[check-traceability]]); and fitness functions, which are automatic checks that the design has not drifted. It also fails if the gate takes longer than 1200 seconds, because a slow gate gets skipped, and a skipped gate protects nothing.

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script with `set -euo pipefail` (stop at the first error), where each step is a command that exits with a non-zero code (the number a program returns to say something went wrong) on failure. The CI workflow (`.github/workflows/quality-gate.yml`) runs exactly this script.

## Where it sits in the pipeline
Copied into each new project ([[new-project]]).

## Who receives its output
[[quizapp-quality-gate]] and [[wiki-quality-gate]], which are its filled-in versions.
