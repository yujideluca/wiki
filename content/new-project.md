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
reviewed: 2026-10-22T16:33Z
---

## What it is
This page lists the steps that every new software project of Giovanni's follows, so that it starts with tests, a quality gate, automatic checks and recorded decisions instead of adding them later.

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
4. Fill in CLAUDE.md, section 1 of DESIGN.md, the first requirements and their tests, the gate steps ([[template-quality-gate]]) and ADR-0002 for the technology (an ADR is an architecture decision record, a short note that records a decision and its reasons).
5. Create the private GitHub repository, push, check that the first CI run (continuous integration: automatic checks) is green, and create the labels `debt idea P1 P2 P3` ([[github]]).
6. Build end to end, then do the first-line debug pass ([[skill-verification-before-completion]]).
7. Add the project's pages to this wiki ([[end-of-task]]).
