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
reviewed: 2026-10-30T20:27Z
---

## What it is
A hook is a small program that [[claude-code]] runs automatically at a certain event ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This is the memory's "Stop" hook: `mem hook-stop`, with a time limit of 40 seconds. It runs every time Claude finishes a reply.

## What it does
It pushes (uploads) any new memory events to GitHub, so that the Claude app and the next session can see them.

## How it does it
It calls the push function of [[mem-sync]]. If the laptop is offline it saves the events locally (a git "commit") and uploads them later. Failures are written to the hook log. It runs right next to the wiki's own Stop hook ([[wiki-hook-stop]]).

## Where it sits in the pipeline
The end of every turn (a turn is one question from Giovanni and Claude's reply to it).

## Who receives its output
[[mem-sync]], and from there [[github]].
