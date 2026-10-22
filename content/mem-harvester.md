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
---

## What it is
Picks up preferences from Giovanni's own words in the prompts, so a rule said once is not lost.

## What it does
Only the user's prompt text counts (never tool output or Claude's text), English and Portuguese, only sentences that state a rule and name an action. Default scope is the project; a habit seen in two projects, or phrased "in all my projects", becomes global (`promote`).

## How it does it
Deterministic event ids, so a repeated hook call writes the same file. A harvested entry never overwrites one with `owner: user`; it becomes a proposal in REVIEW instead.

## Where it sits in the pipeline
Called by [[hook-prompt]] on every message Giovanni sends to Claude Code.

## Who receives its output
[[events-log]].
