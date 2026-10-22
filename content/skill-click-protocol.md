---
id: skill-click-protocol
title: Skill: click-protocol
aliases: [click-protocol]
kind: skill
project: skills
status: active
location: home:.claude/skills/click-protocol
fed_by: []
feeds: []
sources: [home:.claude/skills/click-protocol/SKILL.md]
---

## What it is
A protocol for multi-step clicking in web pages with menus, dialogs, search results or media (YouTube Music, Spotify web).

## What it does
Click by element reference, verify each step, avoid accidental playback; includes a YouTube Music add-to-playlist recipe.

## How it does it
A `SKILL.md` in `~/.claude/skills/click-protocol`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session.
