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
This page describes the sequence of events that gives a new [[claude-code]] chat its memory, before Giovanni's first message is answered. Without it, every chat would start as a blank slate.

## What it does
It makes every session begin with the same standing preferences and the same list of unfinished items, no matter which project the chat is opened in.

## How it does it
Claude Code runs the "session start" hooks that are configured in [[claude-code-settings]] (a hook is a small program run automatically at an event). The memory's hook prints a summary called the brief; whatever is printed at that moment becomes part of what the model reads first.

## Where it sits in the pipeline
Before any work in any project.

## Who receives its output
[[claude-code]] (and the [[remote-assistant]], which starts the same way).

## Steps
1. Giovanni opens Claude Code in a folder (or the assistant restarts) — [[claude-code]].
2. Claude Code reads [[claude-code-settings]] and runs the SessionStart hook [[hook-session-start]].
3. The hook downloads the newest `workflow-memory` from GitHub ([[mem-sync]]).
4. [[memory-fold]] combines the stored events into the current state and ranks them to fit a size budget.
5. [[mem-pendency]] adds the open items for this project, with the rule to verify them before mentioning them.
6. The [[session-brief]] is printed into the model's context, together with the instructions in [[global-claude-md]] and the index of Claude Code's own small memory ([[claude-auto-memory]]).
7. Claude answers following those defaults; when the task ends, [[end-of-task]] closes the loop.
