---
id: new-project
title: Starting a new project (golden path)
aliases: [new project]
kind: process
project: project-template
status: active
fed_by: [skill-brainstorming]
feeds: []
sources: [project-template:README.md]
reviewed: 2026-10-24T22:03Z
---

## What it is
This page lists the steps that every new software project of Giovanni's follows, so that it starts with tests, a quality gate, automatic checks and recorded decisions instead of adding them later.

## Flow
trigger t1: Giovanni wants a new software project | [[giovanni]]
step s1: Brainstorms what is wanted and sizes it; Giovanni approves a written design | [[skill-brainstorming]]
step s2: Giovanni chooses the programming languages | [[work-ask-language]]
step s3: Copies the template to a new folder and starts a fresh git history | [[project-template]]
step s4: Fills in CLAUDE.md, DESIGN.md, requirements, gate steps, limits and a decision note | [[template-quality-gate]], [[fitness-check]]
step s5: Creates the private GitHub repository, pushes, gets the first automatic checks green | [[github]], [[maintenance-pipeline]]
step s6: Builds end to end, then does the first debug pass | [[skill-verification-before-completion]]
step s7: Adds the project's pages to this wiki | [[end-of-task]]
product p1: A private repository born with tests, a gate and recorded decisions
product p2: The project documented in the wiki | [[wiki]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> p1
s6 -> s7
s7 -> p2

## What it does
It turns an approved idea into a private repository that already has the practices of [[project-template]] in place.

## How it does it
The design comes first (with the brainstorming skill), Giovanni chooses the programming language, and then the template is copied and filled in.

## Where it sits in the pipeline
Before the first line of code of any new project. The [[wiki]] was built this way on 2026-10-22.

## Who receives its output
A new project repository on [[github]].

## Steps
1. Brainstorm what is wanted and size it ([[skill-brainstorming]]); a project gets a written design document that Giovanni approves.
2. Giovanni chooses the programming language(s) ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NewProject`, then a fresh `git init -b main` ([[project-template]]).
4. Fill in CLAUDE.md, section 1 of DESIGN.md, the first requirements and their tests, the gate steps ([[template-quality-gate]]), the limits in `pipeline-check.toml` ([[fitness-check]]) and ADR-0002 for the technology (an ADR is an architecture decision record, a short note that records a decision and its reasons).
5. Create the private GitHub repository, push, check that the first CI run (continuous integration: automatic checks) is green, create the labels `debt idea P1 P2 P3` ([[github]]), and turn on the local pre-push check with `git config core.hooksPath tools/hooks` ([[maintenance-pipeline]]).
6. Build end to end, then do the first-line debug pass ([[skill-verification-before-completion]]).
7. Add the project's pages to this wiki ([[end-of-task]]).
