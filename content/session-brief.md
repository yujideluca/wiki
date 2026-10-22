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
The block of text a Claude Code chat sees first: "Memory (workflow-memory)…" with Giovanni's standing preferences (each with its #code), open items and how to record, report and give feedback.

## What it does
Sets defaults for the session (it never authorizes anything); precedence is current instruction > repo rules file > project memory > profile.

## How it does it
Printed by [[hook-session-start]] from [[memory-fold]] and [[mem-pendency]], within its budgets; says "memory may be stale" when the pull failed.

## Where it sits in the pipeline
The first input of every Claude Code session ([[chat-start]]).

## Who receives its output
[[claude-code]] and [[remote-assistant]].
