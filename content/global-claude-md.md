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
---

## What it is
`~/.claude/CLAUDE.md`: Giovanni's private instructions for every Claude Code session on the laptop.

## What it does
Points to [[workflow-memory]] as the shared memory; says how to record a correction (`mem add`), report what shaped a task (`mem use`), and flag a wrong entry; forbids editing `events/` or `views/` by hand and storing other people's clinical, secret or contact data; and makes the wiki update part of finishing a task ([[end-of-task]]).

## How it does it
Loaded automatically into the context of every session, next to the brief.

## Where it sits in the pipeline
Read at [[chat-start]].

## Who receives its output
[[claude-code]] and [[remote-assistant]].
