---
id: mem-harvester
title: Preference harvester (harvest.py)
aliases: [harvester, harvest]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/harvest.py
fed_by: [hook-prompt]
feeds: [events-log]
sources: [workflow-memory:mem/harvest.py]
reviewed: 2026-10-22T16:33Z
---

## What it is
The harvester ("harvest" means to gather) picks up preferences from Giovanni's own words in the messages he sends, so that a rule said once is not lost just because nobody ran `mem add`. It lives in `mem/harvest.py`.

## What it does
Only the user's own message text counts (never tool output or Claude's text), in English and Portuguese, and only sentences that state a rule and name an action. By default a harvested preference applies to the current project only; a habit seen in two projects, or one phrased "in all my projects", becomes global (this step is called `promote`).

## How it does it
Event ids are deterministic (the same input always produces the same id), so a hook call that is repeated writes the same file instead of a duplicate. A harvested entry never overwrites one with `owner: user` (Giovanni's own recorded words); instead it becomes a proposal listed in the review file for Giovanni to decide.

## Where it sits in the pipeline
Called by [[hook-prompt]] on every message Giovanni sends to Claude Code.

## Who receives its output
[[events-log]].
