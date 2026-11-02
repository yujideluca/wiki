---
id: checks-project-template
title: project-template: checkers and rules
aliases: [template checks, golden path checks]
kind: decision
project: project-template
status: active
fed_by: []
feeds: []
sources: [project-template:tools/quality_gate.sh, project-template:pipeline-check.toml, project-template:CLAUDE.md, project-template:docs/REQUIREMENTS.md]
reviewed: 2026-11-02T10:44Z
---

## What it is
These are the checkers that [[project-template]] gives every new project. They are the baseline from which the other per-project pages differ.

## What it does
The template gate has three steps: a placeholder for build and tests (`TODO`, to be filled), requirement traceability with the committed matrix (the template has one example requirement, `XX-1`), and the fitness limits, ending with the 1200-second gate cap ([[template-quality-gate]]). Its `pipeline-check.toml` holds commented examples of every optional section (file size, GitHub, DORA (DevOps Research and Assessment), pre-push guard, traceability folders, ShellCheck). Principles: requirement, then test, then code; framework-free logic; the gate decides; shared tools are consumed by pinned version; decisions are written where the code is.

## How it does it
A new project copies the folder, fills the placeholders and pins a version in `pipeline-check.version` ([[new-project]]). Two ADRs ship with it: 0001 (record decisions as ADRs) and 0003 (the program measures, a skill judges), leaving 0002 for the technology choice ([[adr-explained]]).

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
