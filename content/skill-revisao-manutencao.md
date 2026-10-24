---
id: skill-revisao-manutencao
title: Skill: revisao-manutencao
aliases: [revisao-manutencao, maintenance review skill]
kind: skill
project: skills
status: active
location: home:.claude/skills/revisao-manutencao
fed_by: [pipeline-check]
feeds: [monthly-architecture-review, skill-gerar-teste-automatizado]
sources: [home:.claude/skills/revisao-manutencao/SKILL.md]
---

## What it is
The judging half of the [[maintenance-pipeline]]: a skill that reads what [[pipeline-check]] measured and proposes what to do about it.

## What it does
Runs `tools/pipeline-check.sh`, reads `report.json` and never re-measures. For each `aviso` or `falha` it proposes a `debt` issue with priority P1 (risk of data or wrong results), P2 (slows every change) or P3 (desirable). It then checks what a machine cannot see: do `DESIGN.md` and the ADRs match the code, does every structural change have an ADR, was the same problem solved twice (move the better solution to [[project-template]]). It adds a Preventive row to each reviewed project's decision log, calls [[skill-gerar-teste-automatizado]] (create on the first review, update afterwards), and ends with `mem use`, `wiki publish` and "Verified by:". It also checks the standards no tool measures: every project folder is a git repository with a GitHub remote, the local pre-push check is enabled, the pinned pipeline-check version is the newest, and no script is copied between projects. It proposes; it never closes issues, changes a limit, promotes a version or changes branch protection.

## How it does it
A `SKILL.md` in `~/.claude/skills/revisao-manutencao`. Triggered by the monthly review item in workflow-memory and at the end of a task in a software project.

## Where it sits in the pipeline
Runs the [[monthly-architecture-review]] and the end-of-task review of every software project.

## Who receives its output
Giovanni (proposals and decisions) and each project's decision log.
