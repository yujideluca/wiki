---
id: monthly-architecture-review
title: Monthly architecture review
aliases: [architecture review, monthly review]
kind: process
project: project-template
status: active
fed_by: [maintenance-policy]
feeds: []
sources: [project-template:docs/MAINTENANCE.md]
---

## What it is
One session a month that plays the role a staff engineer has in a company: checking coherence across all projects (workflow-memory ADR-0003). It is an open item in memory, so every chat shows it until done.

## What it does
Walks the checklist of [[maintenance-policy]] for each active project in `~/dev` and records the outcome.

## How it does it
Uses each project's gate, metrics (`tools/metrics.py` where present), fitness functions, DESIGN.md, ADRs and debt list.

## Where it sits in the pipeline
Monthly, across [[quizapp]], [[quizweb]], [[workflow-memory]], [[wiki]] and the template.

## Who receives its output
Each project's decision log (a Preventive row) and [[project-template]] (better solutions moved into it).

## Steps
1. The gate passes locally and the latest CI runs are green.
2. Metrics: deployment frequency, lead time, rework rate, preventive share (target about 20 %).
3. Fitness functions: what is closest to its limit? Act before it crosses ([[fitness-check]]).
4. DESIGN.md diagrams and ADRs still match the code; every structural change has an ADR.
5. Adaptive maintenance: toolchain, SDK and dependency updates, upgraded on a branch and gated.
6. Debt list: still true, right priority; a P1 older than a month is scheduled now ([[maintenance-policy]]).
7. Across projects: the same problem solved twice in different ways? Move the better one into [[project-template]].
8. Memory: entries still true (`mem search <project>`); outdated ones get `mem feedback REF stale` ([[workflow-memory]]).
9. Record a Preventive decision-log row per project and report with [[mem-use]].
