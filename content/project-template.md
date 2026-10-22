---
id: project-template
title: project-template (golden path)
aliases: [template, golden path]
kind: project
project: none
status: active
location: project-template:
fed_by: []
feeds: [quizapp, wiki]
sources: [project-template:README.md, project-template:CLAUDE.md]
---

## What it is
The starting point for every new software project of Giovanni's (`~/dev/project-template`, repo `yujideluca/project-template`), so the right way to work is also the quickest. Chosen in the maintenance and evolution review of 2026-10-22.

## What it does
Gives a new project, from day one: principles each enforced by a check, a design file with C4 diagrams and a decision log, ADRs, a requirements list with tagged tests ([[check-traceability]]), a quality gate ([[template-quality-gate]]), CI, and the technical-debt and review policy ([[maintenance-policy]]).

## How it does it
Copied with `cp -r` into a new folder; the first session fills CLAUDE.md, DESIGN.md section 1, the first requirements, the gate steps and ADR-0002 for the stack, then creates the private GitHub repo and its labels ([[new-project]]). Before any of that, Giovanni chooses the programming language ([[work-ask-language]]).

## Where it sits in the pipeline
Upstream of every new project; QuizApp was the reference it was extracted from. This [[wiki]] was the first project started from it.

## Who receives its output
New projects such as [[wiki]]; better solutions found in projects flow back into it during the [[monthly-architecture-review]].
