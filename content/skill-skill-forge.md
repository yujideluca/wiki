---
id: skill-skill-forge
title: Skill: skill-forge
aliases: [skill-forge]
kind: skill
project: skills
status: active
location: home:.claude/skills/skill-forge
fed_by: []
feeds: []
sources: [home:.claude/skills/skill-forge/SKILL.md]
---

## What it is
The full pipeline for creating or rebuilding a skill for Giovanni.

## What it does
Requirements analysis, three competing versions, tests, compatibility checks with the other skills, then validation and packaging through skill-creator. Small edits to one skill skip it and use skill-creator alone.

## How it does it
A `SKILL.md` in `~/.claude/skills/skill-forge`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
How every new or rebuilt skill is made.

## Who receives its output
The [[skills]] folder (and the Claude app's copies, [[claude-ai-skills]]).
