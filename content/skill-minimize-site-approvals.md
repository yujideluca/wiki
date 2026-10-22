---
id: skill-minimize-site-approvals
title: Skill: minimize-site-approvals
aliases: [minimize-site-approvals]
kind: skill
project: skills
status: active
location: home:.claude/skills/minimize-site-approvals
fed_by: []
feeds: []
sources: [home:.claude/skills/minimize-site-approvals/SKILL.md]
---

## What it is
A planning step before browsing so Giovanni clicks "approve" as few times as possible.

## What it does
Plans the domains up front, requests site-wide access once, prefers tools that need no approval. It never bypasses approvals or the site safety check.

## How it does it
A `SKILL.md` in `~/.claude/skills/minimize-site-approvals`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session and Giovanni (fewer prompts).
