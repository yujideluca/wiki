---
id: hook-stop
title: Stop hook (mem hook-stop)
aliases: [memory stop hook]
kind: hook
project: workflow-memory
status: active
location: workflow-memory:mem/hooks.py
fed_by: [claude-code-settings]
feeds: [mem-sync]
sources: [workflow-memory:mem/hooks.py]
---

## What it is
The memory's Claude Code hook that runs when Claude finishes a turn: `mem hook-stop` (timeout 40 s).

## What it does
Pushes new memory events to GitHub, so the Claude app and the next session see them.

## How it does it
Calls [[mem-sync]] `push`; offline it commits locally and pushes later; failures go to the hook log. It runs next to the wiki's own Stop hook ([[wiki-hook-stop]]).

## Where it sits in the pipeline
End of every turn.

## Who receives its output
[[mem-sync]] → [[github]].
