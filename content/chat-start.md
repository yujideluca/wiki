---
id: chat-start
title: What happens when a chat starts
aliases: [session start]
kind: process
project: workflow-memory
status: active
fed_by: []
feeds: []
sources: [workflow-memory:mem/hooks.py, home:.claude/settings.json, status-quo:crates/desktop/src/main.rs]
reviewed: 2026-11-25T17:36Z
---

## What it is
This page describes the sequence of events that gives a new [[claude-code]] chat its memory, before Giovanni's first message is answered. Without it, every chat would start as a blank slate.

## Flow
trigger t1: Giovanni opens Claude Code in a folder, or the assistant restarts | [[claude-code]], [[remote-assistant]]
step s1: Reads its settings and runs the SessionStart hook | [[claude-code-settings]], [[hook-session-start]]
step s2: Downloads the newest workflow-memory from GitHub | [[mem-sync]]
decide d1: Did the download work?
step s2b: Keeps the local copy and warns that memory may be stale
step s3: Folds the stored events into the current state | [[memory-fold]]
step s4: Adds the open items, to be verified before mentioning them | [[mem-pendency]]
step s5: Prints the brief: one standing order, a list of task tags and the open items | [[session-brief]]
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
It makes every session begin with the same standing order to load Giovanni's rules for the task at hand and the same list of unfinished items, no matter which project the chat is opened in.

## How it does it
Claude Code runs the "session start" hooks that are configured in [[claude-code-settings]] (a hook is a small program run automatically at an event). The memory's hook prints a summary called the brief; whatever is printed at that moment becomes part of what the model reads first. Three SessionStart hooks are configured: `mem hook-session-start` (the memory's hook, allowed 40 seconds); `status-quo hook claude SessionStart` (allowed 3 seconds), which records that a session began in the state folder of the desktop tray [[status-quo]] and prints nothing for the model; and, since 2026-11-22, `token-thrift hook-session-start` (allowed 5 seconds, run only when the program is installed), which prints one warning when a resumed session's stored context has probably expired and nothing otherwise ([[token-thrift]]). The brief holds no rules: it ends with three one-line reminders of how to record a rule, how to report the entries that shaped a task (`mem use`) and how to record what is still open. Its main part tells Claude to sort each message from Giovanni into task tags and to load the rules of those tags with [[mem-rules]]. A second hook, `mem hook-prompt` ([[hook-prompt]]), runs at every message and prints a one-line reminder of that order.

## Where it sits in the pipeline
Before any work in any project.

## Who receives its output
[[claude-code]] (and the [[remote-assistant]], which starts the same way).

## Steps
1. Giovanni opens Claude Code in a folder (or the assistant restarts) — [[claude-code]].
2. Claude Code reads [[claude-code-settings]] and runs the SessionStart hook [[hook-session-start]].
3. The hook downloads the newest `workflow-memory` from GitHub ([[mem-sync]]).
4. [[memory-fold]] combines the stored events into the current state.
5. [[mem-pendency]] adds the open items, with the rule to verify them before mentioning them.
6. The [[session-brief]] is printed into the model's context, together with the instructions in [[global-claude-md]] and the index of Claude Code's own small memory ([[claude-auto-memory]]).
7. For each message, Claude loads the rules that fit the task with [[mem-rules]] and answers following them; when the task ends, [[end-of-task]] closes the loop.
