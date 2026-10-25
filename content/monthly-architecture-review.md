---
id: monthly-architecture-review
title: Monthly architecture review
aliases: [architecture review, monthly review]
kind: process
project: project-template
status: active
fed_by: [maintenance-policy, skill-revisao-manutencao]
feeds: []
sources: [project-template:docs/MAINTENANCE.md]
reviewed: 2026-10-24T22:03Z
---

## What it is
Once a month, one working session looks at all of Giovanni's projects together, in the role that a staff engineer (a senior engineer who watches the overall coherence) would have in a company. The idea comes from decision ADR-0003 of [[workflow-memory]] (an ADR is an architecture decision record, a short note that records one decision and its reasons). It is kept as an open item in the memory, so every chat shows it until it is done.

## What it does
It walks through the checklist of [[maintenance-policy]] for each active project in `~/dev` and records the outcome. Since 2026-10-24 it is run by the skill [[skill-revisao-manutencao]], based on the report of [[pipeline-check]] ([[maintenance-pipeline]]).

## How it does it
It uses each project's quality gate, delivery metrics (the `dora` block of the [[pipeline-check]] report), fitness functions, design file (DESIGN.md), ADRs and debt list. The skill [[skill-revisao-manutencao]] runs `tools/pipeline-check.sh` and reads `build/pipeline-check/report.json`; steps 1 to 3 below are what the program already measured, and the rest is judgement.

## Where it sits in the pipeline
Monthly, across [[quizapp]], [[quizweb]], [[workflow-memory]], the [[wiki]] and the template.

## Who receives its output
Each project's decision log (a Preventive row) and [[project-template]] (better solutions are moved into it).

## Steps
1. The gate passes locally and the latest CI runs (continuous integration) are green.
2. Metrics: how often changes are released, how long they take, how much work is redone, and the preventive share (target about 20 %).
3. Fitness functions: which one is closest to its limit? Act before it crosses ([[fitness-check]]).
4. The diagrams in DESIGN.md and the ADRs still match the code; every structural change has an ADR.
5. Adaptive maintenance: updates of tools, SDKs (software development kits) and dependencies are tried on a branch and put through the gate.
6. Debt list: still true, right priority; a P1 older than a month is scheduled now ([[maintenance-policy]]).
7. Across projects: was the same problem solved twice in different ways? Move the better solution into [[project-template]].
8. Memory: are the entries still true (`mem search <project>`)? Outdated ones get `mem feedback REF stale` ([[workflow-memory]]).
9. Record a Preventive decision-log row per project and report with [[mem-use]].
