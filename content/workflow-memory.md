---
id: workflow-memory
title: workflow-memory (shared memory)
aliases: [memory, mem repo]
kind: project
project: none
status: active
location: workflow-memory:
fed_by: [claude-code]
feeds: []
sources: [workflow-memory:README.md, workflow-memory:docs/DESIGN.md]
---

## What it is
The shared, long-lived memory of every Claude instance Giovanni uses. Private repo `yujideluca/workflow-memory`, folder `~/dev/workflow-memory`. It replaced the retired claude-workflow-backup protocol ([[retired-workflow-pipeline]]).

## What it does
Keeps preferences, facts, decisions and open items, and shows the relevant ones at the start of every chat ([[session-brief]]). It is the only interface between the Claude instances (ADR-0003, [[memory-adrs]]).

## How it does it
The log is the memory: every entry is one new, never-edited file in [[events-log]]. [[memory-fold]] computes the current state (latest ruling per key wins). [[mem-action]] regenerates [[memory-views]] on GitHub. Claude Code writes with [[mem]] and its hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); the Claude app writes through [[mem-github-connector]]. Python standard library only; [[mem-validator]] keeps secrets and contact data out.

## Where it sits in the pipeline
Under every other project: they read their defaults from it and report back with `mem use`.

## Who receives its output
Every Claude instance, through the brief; [[giovanni]] through [[memory-views]] (REVIEW.md).
