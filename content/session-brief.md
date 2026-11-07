---
id: session-brief
title: Session brief (memory at chat start)
aliases: [brief, memory brief]
kind: data
project: workflow-memory
status: active
fed_by: [hook-session-start, mem-pendency, memory-fold, mem-rules]
feeds: [claude-code, remote-assistant]
sources: [workflow-memory:mem/hooks.py, workflow-memory:mem/project.py, workflow-memory:mem/tags.py, workflow-memory:mem/tags.toml, workflow-memory:docs/adr/0008-router-rules-as-modules.md, workflow-memory:mem/cli.py]
reviewed: 2026-11-07T22:03Z
---

## What it is
The session brief is the block of text a [[claude-code]] chat sees first. It starts with "Memory (workflow-memory)…" and has four parts. First the router: the one standing order, which says to classify each message from Giovanni into tags (the kinds of task, such as `deploy` or `git`) and to load the rules of those tags with [[mem-rules]] as the very first step, before reading skills or files. Then an index of the tags, with the number of rules and a one-line "use when" for each. Then the open items. Last, how to record a new preference, report what was used, and give feedback. No rule is printed in it (ADR-0008, an architecture decision record, 2026-11-07): rules are modules loaded per task.

## What it does
It sets the defaults for the session. It never authorizes anything by itself: the order of precedence is the current instruction first, then the repository's rules file, then project memory, then the general profile. In other words, what Giovanni says now always beats what memory says.

## How it does it
The [[hook-session-start]] prints it. The index comes from the tags kept in `mem/tags.toml` (the list of known tags, each with its "use when" line); the open items follow the rules of [[mem-pendency]]. The part before the open items stays under 1,900 characters, because the program that runs the hook shows a chat only the first 2 KB of what a hook prints; a test fails if the real memory makes it longer. For each message, Claude runs [[mem-rules]] with the tags that fit, to read the full wording of those rules; a one-line reminder printed on every message ([[hook-prompt]]) keeps this going in long chats where the task changes. `mem brief` prints the same text (`mem brief --full` prints the old ranked list of rules for inspection). When the download of the newest memory failed, the brief says "memory may be stale". After `/clear` or a compaction the brief is the same, because it is already short. Rules that concern only Codex are scoped `instance:codex` and do not appear in Claude Code's brief.

## Where it sits in the pipeline
It is the first input of every Claude Code session ([[chat-start]]).

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
