---
id: skill-brainstorming
title: Skill: brainstorming
aliases: [brainstorming]
kind: skill
project: skills
status: active
location: home:.claude/skills/brainstorming
fed_by: []
feeds: [new-project]
sources: [home:.claude/skills/brainstorming/SKILL.md]
---

## What it is
The process skill used before building anything new: find out what Giovanni actually wants, and why, before code exists.

## What it does
Asks one open question at a time, plays understanding back, offers a visual companion (a browser tab with mockups) when seeing helps, sizes the work (quick task, small change, project with a written design), has a fresh reviewer read the design, and blocks building until Giovanni approves. Since 2026-10-22 it also asks which programming language to use ([[work-ask-language]]).

## How it does it
A `SKILL.md` in `~/.claude/skills/brainstorming`; Claude loads it when a request matches its description. Adapted from obra/superpowers 7.0.0 (MIT).

## Where it sits in the pipeline
Part of the development process in Claude Code, used in every project.

## Who receives its output
Giovanni (questions and the design document) and the build that follows.
