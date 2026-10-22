---
id: claude-auto-memory
title: Claude Code auto-memory
aliases: [MEMORY.md, auto memory]
kind: data
project: laptop-setup
status: active
location: home:.claude/projects/-home-yuji/memory
fed_by: []
feeds: [claude-code]
sources: [home:.claude/projects/-home-yuji/memory]
---

## What it is
Claude Code's own small file memory for sessions started in the home folder: one fact per file plus the index `MEMORY.md`, loaded into every such session.

## What it does
Holds laptop-specific notes: how to check the remote assistant, the German Quiz project, user-space tool paths, the debug-after-coding rule, that the deutsch-gespraech notice is not for Claude Code, and that the old pipeline is retired.

## How it does it
Written by Claude Code with the memory format (frontmatter + fact + why + how to apply). Shared, cross-instance rules belong in [[workflow-memory]] instead.

## Where it sits in the pipeline
Loaded at [[chat-start]] next to [[global-claude-md]].

## Who receives its output
[[claude-code]].
