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
reviewed: 2026-10-30T20:27Z
---

## What it is
This page describes the sequence of events that gives a new [[claude-code]] chat its memory, before Giovanni's first message is answered. Without it, every chat would start as a blank slate.

## Flow
trigger t1: Giovanni opens Claude Code in a folder, or the assistant restarts | [[claude-code]], [[remote-assistant]]
step s1: Reads its settings and runs the SessionStart hook | [[claude-code-settings]], [[hook-session-start]]
step s2: Downloads the newest workflow-memory from GitHub | [[mem-sync]]
decide d1: Did the download work?
step s2b: Keeps the local copy and warns that memory may be stale
step s3: Folds the stored events into the current state, ranked to fit a size budget | [[memory-fold]]
step s4: Adds this project's open items, to be verified before mentioning them | [[mem-pendency]]
step s5: Prints the brief into the model's context | [[session-brief]]
step s6: Adds the global instructions and Claude's own memory index | [[global-claude-md]], [[claude-auto-memory]]
product p1: A chat that starts with Giovanni's standing preferences and open items

t1 -> s1
s1 -> s2
s2 -> d1
d1 -yes-> s3
d1 -no-> s2b
s2b -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> p1

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
