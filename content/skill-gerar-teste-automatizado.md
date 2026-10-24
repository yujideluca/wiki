---
id: skill-gerar-teste-automatizado
title: Skill: gerar-teste-automatizado
aliases: [gerar-teste-automatizado, bug-finding test skill]
kind: skill
project: skills
status: active
location: home:.claude/skills/gerar-teste-automatizado
fed_by: [skill-revisao-manutencao]
feeds: []
sources: [home:.claude/skills/gerar-teste-automatizado/SKILL.md]
---

## What it is
The skill that creates, and later updates, the automated test suite that hunts for real bugs in a project.

## What it does
Create mode (no `docs/TESTES-AUTOMATIZADOS.md` yet): a full diagnosis of the code, a test matrix tied to the requirements, tests whose expected results are independent of the code, then checks that the tests can detect defects (mutation testing, coverage, repeated runs). Update mode: reads the record and the suite, finds what changed since the commit it names, and brings both up to date. It never edits production code to make tests pass and proposes any fix separately.

## How it does it
A `SKILL.md` in `~/.claude/skills/gerar-teste-automatizado`, based on a prompt written by Giovanni. The record `docs/TESTES-AUTOMATIZADOS.md` is the marker that the suite exists.

## Where it sits in the pipeline
Called by [[skill-revisao-manutencao]] in step 4 of every review.

## Who receives its output
Giovanni (defects found, residual risks) and the project's test folders.
