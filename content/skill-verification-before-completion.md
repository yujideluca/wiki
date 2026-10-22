---
id: skill-verification-before-completion
title: Skill: verification-before-completion
aliases: [verification-before-completion]
kind: skill
project: skills
status: active
location: home:.claude/skills/verification-before-completion
fed_by: []
feeds: []
sources: [home:.claude/skills/verification-before-completion/SKILL.md]
---

## What it is
The rule that evidence comes before any claim that work is done, fixed or passing.

## What it does
Before saying "done" or committing: run the verification commands and read their output. Feeds the "Verified by:" line that ends every report to Giovanni, which also names what could not be checked.

## How it does it
A `SKILL.md` in `~/.claude/skills/verification-before-completion`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project.

## Who receives its output
Giovanni (the report) and the commit.
