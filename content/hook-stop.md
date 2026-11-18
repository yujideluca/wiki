---
id: hook-stop
title: Stop hook (mem hook-stop)
aliases: [memory stop hook]
kind: hook
project: workflow-memory
status: active
location: workflow-memory:mem/hooks.py
fed_by: [claude-code-settings]
feeds: [mem-sync]
sources: [workflow-memory:mem/hooks.py]
reviewed: 2026-11-18T06:23Z
---

## What it is
A hook is a small program that [[claude-code]] runs automatically at a certain event ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This is the memory's "Stop" hook: `mem hook-stop`, with a time limit of 40 seconds. It runs every time Claude finishes a reply.

## What it does
It pushes (uploads) any new memory events to GitHub, so that the Claude app and the next session can see them.

## How it does it
It calls the push function of [[mem-sync]]. If the laptop is offline it saves the events locally (a git "commit") and uploads them later. Every result that is not a success (a failed commit, a failed push, or a conflict found while fetching the remote changes first) is written to the hook log, `~/.local/state/mem/hook.log`; until 2026-11-18 a conflict left no trace. The log is bounded since the same day: when it passes 1 MB it keeps its newest half, cut at a whole line (it had grown to 8.5 MB). The hook itself always ends quietly, so that log is the only place a failure shows. It runs right next to the wiki's own Stop hook ([[wiki-hook-stop]]).

## Where it sits in the pipeline
The end of every turn (a turn is one question from Giovanni and Claude's reply to it).

## Who receives its output
[[mem-sync]], and from there [[github]].
