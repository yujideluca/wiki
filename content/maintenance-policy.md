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
---

## What it is
How every project stays healthy as it changes: ISO/IEC/IEEE 14764 maintenance types, Lehman's laws, fitness functions and DORA delivery metrics (`docs/MAINTENANCE.md`).

## What it does
Technical debt (anything that works today but makes the next change slower or riskier) becomes a GitHub Issue labelled `debt` with priority P1–P3; new features use `idea`. About one work session in five goes to debt or prevention: when the last four sessions were all features, Claude says so and proposes the top debt issue, and Giovanni decides.

## How it does it
A limitation found while working becomes an issue in the same session; the monthly review checks the list.

## Where it sits in the pipeline
Part of the template, copied into each project.

## Who receives its output
[[monthly-architecture-review]] and every Claude session (through each project's CLAUDE.md).
