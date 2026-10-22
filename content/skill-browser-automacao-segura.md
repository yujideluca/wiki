---
id: skill-browser-automacao-segura
title: Skill: browser-automacao-segura (safe browser automation)
aliases: [browser-automacao-segura]
kind: skill
project: skills
status: active
location: home:.claude/skills/browser-automacao-segura
fed_by: []
feeds: []
sources: [home:.claude/skills/browser-automacao-segura/SKILL.md]
---

## What it is
The safety rules for any action in a browser (the app's built-in browser or Claude in Chrome), especially batch actions, removals, mass edits and scripts on pages. Written in Portuguese.

## What it does
Avoids dialogs that freeze the session, loops and destructive mistakes; asks before anything irreversible.

## How it does it
A `SKILL.md` in `~/.claude/skills/browser-automacao-segura`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Before and during any browser automation.

## Who receives its output
The browser session; [[skill-click-protocol]] and [[skill-minimize-site-approvals]] defer to it for alerts and destructive actions.
