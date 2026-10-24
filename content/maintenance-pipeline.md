---
id: maintenance-pipeline
title: Maintenance pipeline (measure, then judge)
aliases: [pipeline-check process, maintenance process]
kind: process
project: project-template
status: active
fed_by: []
feeds: []
sources: [QuizApp:docs/2026-10-24-pipeline-check-design.md, QuizApp:docs/adr/0013-program-measures-skill-judges.md]
---

## What it is
The way Giovanni's software projects are kept maintainable: a program measures and blocks, a skill judges and proposes, and the two talk only through `report.json`.

## What it does
Turns the rules of [[maintenance-policy]] into something a machine enforces: the CI job fails on a `falha`, and the monthly review reads the same numbers instead of measuring by hand.

## How it does it
[[pipeline-check]] runs in CI and on the laptop; [[skill-revisao-manutencao]] reads the report. Blocking a merge also needs branch protection that requires the CI job; only Giovanni changes it. On a private repository of a free GitHub plan this protection is not available (GitHub answers 403), so a red CI run alone does not yet stop a merge; the options are GitHub Pro, a public repository, or a local pre-push check. Applied first to [[quizapp]], then copied to the other projects and to [[project-template]].

## Where it sits in the pipeline
Between every push and the monthly review: [[quizapp-ci]], then [[monthly-architecture-review]].

## Who receives its output
Giovanni.

## Steps
1. A push runs the CI job `gate`, which runs [[pipeline-check]].
2. Any `falha` fails the job; branch protection stops the merge.
3. An `aviso` never fails but shows in the report.
4. At the monthly review, [[skill-revisao-manutencao]] turns warnings and failures into prioritised `debt` proposals.
5. Giovanni decides; the skill records a Preventive row in the decision log and publishes the wiki.
