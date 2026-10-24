---
id: session-brief
title: Session brief (memory at chat start)
aliases: [brief, memory brief]
kind: data
project: workflow-memory
status: active
fed_by: [hook-session-start, mem-pendency, memory-fold]
feeds: [claude-code, remote-assistant]
sources: [workflow-memory:mem/hooks.py, workflow-memory:mem/project.py]
---

## What it is
The session brief is the block of text a [[claude-code]] chat sees first. It starts with "Memory (workflow-memory)…" and lists Giovanni's standing preferences (each tagged with a short `#code` so it can be referred to), the open items, and how to record a new preference, report what was used, and give feedback.

## What it does
It sets the defaults for the session. It never authorizes anything by itself: the order of precedence is the current instruction first, then the repository's rules file, then project memory, then the general profile. In other words, what Giovanni says now always beats what memory says.

## How it does it
The [[hook-session-start]] prints it, using the ranking from [[memory-fold]] and the open-item rules from [[mem-pendency]], each within a size budget so the brief stays short. When the download of the newest memory failed, the brief says "memory may be stale".

## Where it sits in the pipeline
It is the first input of every Claude Code session ([[chat-start]]).

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
