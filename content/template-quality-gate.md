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
---

## What it is
The skeleton of every project's `tools/quality_gate.sh`: the one definition of "passing", used by releases and by CI.

## What it does
Three steps to fill per project: build and tests; requirement traceability ([[check-traceability]]); fitness functions. It fails when the gate takes longer than 1200 s, because a slow gate gets skipped.

## How it does it
Bash, `set -euo pipefail`; each step a command that exits non-zero on failure. CI (`.github/workflows/quality-gate.yml`) runs exactly this script.

## Where it sits in the pipeline
Copied into each new project ([[new-project]]).

## Who receives its output
[[quizapp-quality-gate]] and [[wiki-quality-gate]].
