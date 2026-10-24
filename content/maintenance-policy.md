---
id: maintenance-policy
title: Maintenance policy (technical debt)
aliases: [MAINTENANCE.md, debt policy]
kind: decision
project: project-template
status: active
location: project-template:docs/MAINTENANCE.md
fed_by: []
feeds: [monthly-architecture-review]
sources: [project-template:docs/MAINTENANCE.md]
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the rulebook for keeping every project healthy as it changes over time (`docs/MAINTENANCE.md` in [[project-template]]). It draws on four known ideas: the maintenance types of the standard ISO/IEC/IEEE 14764 (corrective = fixing faults, adaptive = adjusting to a changing environment, perfective = improving, preventive = preparing against future problems; see [software maintenance](https://en.wikipedia.org/wiki/Software_maintenance)); [Lehman's laws](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) of software evolution (software that is used must keep changing, and grows more complex unless work is done to reduce it); fitness functions (automatic checks of design qualities, see [[fitness-check]]); and DORA (DevOps Research and Assessment) delivery metrics such as how often changes are released and how quickly ([dora.dev](https://dora.dev/)).

## What it does
It defines technical debt: anything that works today but makes the next change slower or riskier ([technical debt](https://en.wikipedia.org/wiki/Technical_debt)). Debt becomes a GitHub Issue (a tracked task) with the label `debt` and a priority from P1 (most urgent) to P3; new feature ideas use the label `idea`. About one work session in five goes to debt or prevention: when the last four sessions were all about features, Claude says so and proposes the top debt issue, and Giovanni decides.

## How it does it
A limitation found while working becomes an issue in the same session, and the monthly review checks the list.

## Where it sits in the pipeline
Part of the template, copied into each project.

## Who receives its output
The [[monthly-architecture-review]] and every Claude session (through each project's CLAUDE.md).
