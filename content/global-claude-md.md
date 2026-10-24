---
id: global-claude-md
title: Global CLAUDE.md
aliases: [~/.claude/CLAUDE.md, global instructions]
kind: data
project: laptop-setup
status: active
location: home:.claude/CLAUDE.md
fed_by: []
feeds: [claude-code, remote-assistant]
sources: [home:.claude/CLAUDE.md]
reviewed: 2026-10-22T16:33Z
---

## What it is
`~/.claude/CLAUDE.md` is Giovanni's private instruction file for every Claude Code session on the laptop. A CLAUDE.md file is plain text that Claude Code reads automatically at the start of a session and treats as standing instructions ([documentation](https://docs.claude.com/en/docs/claude-code/memory)). This one is "global": it applies in every project, while each project also has its own.

## What it does
It names [[workflow-memory]] as the shared memory and explains how to record a correction (`mem add`), how to report which memory entries shaped a task (`mem use`) and how to flag a wrong entry. It forbids editing the `events/` and `views/` folders by hand and storing clinical, secret or contact data about other people. It also makes updating the wiki part of finishing any task ([[end-of-task]]).

## How it does it
It is loaded automatically into the context of every session, next to the memory brief ([[session-brief]]). No command is needed.

## Where it sits in the pipeline
Read at the start of each chat ([[chat-start]]).

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
