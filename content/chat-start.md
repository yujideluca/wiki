---
id: chat-start
title: What happens when a chat starts
aliases: [session start]
kind: process
project: workflow-memory
status: active
fed_by: []
feeds: []
sources: [workflow-memory:mem/hooks.py, home:.claude/settings.json]
---

## What it is
The sequence that gives a new Claude Code chat its memory before Giovanni's first message is answered.

## What it does
Makes every session start from the same standing preferences and open items, whichever project it is in.

## How it does it
Claude Code runs the SessionStart hooks configured in [[claude-code-settings]]; the memory one prints the brief.

## Where it sits in the pipeline
Before any work in any project.

## Who receives its output
[[claude-code]] (and [[remote-assistant]]).

## Steps
1. Giovanni opens Claude Code in a folder (or the assistant restarts) — [[claude-code]].
2. Claude Code reads [[claude-code-settings]] and runs the SessionStart hook [[hook-session-start]].
3. The hook pulls `workflow-memory` from GitHub ([[mem-sync]]).
4. [[memory-fold]] folds [[events-log]] into the current state and ranks it within the budget.
5. [[mem-pendency]] adds the open items for this project, with the verify rule.
6. The [[session-brief]] is printed into the model's context, together with [[global-claude-md]] and the auto-memory index ([[claude-auto-memory]]).
7. Claude answers following those defaults; when the task ends, [[end-of-task]] closes the loop.
