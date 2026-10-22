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
---

## What it is
The steps every new software project of Giovanni's follows, so it starts with tests, a gate, CI and recorded decisions.

## What it does
Turns an approved idea into a private repo with the template's practices in place.

## How it does it
Design first (the brainstorming skill), language chosen by Giovanni, then copy [[project-template]] and fill it in.

## Where it sits in the pipeline
Before the first line of code of any new project. The [[wiki]] was built this way on 2026-10-22.

## Who receives its output
A new project repo on [[github]].

## Steps
1. Brainstorm what is wanted and size it ([[skill-brainstorming]]); a project gets a written design document that Giovanni approves.
2. Giovanni chooses the programming language(s) ([[work-ask-language]]).
3. `cp -r ~/dev/project-template ~/dev/NewProject`, fresh `git init -b main` ([[project-template]]).
4. Fill CLAUDE.md, DESIGN.md section 1, the first requirements and their tests, the gate steps ([[template-quality-gate]]), ADR-0002 for the stack.
5. Create the private GitHub repo, push, check the first CI run is green, create the labels `debt idea P1 P2 P3` ([[github]]).
6. Build end to end, then the first-line debug pass ([[skill-verification-before-completion]]).
7. Add the project's pages to this wiki ([[end-of-task]]).
