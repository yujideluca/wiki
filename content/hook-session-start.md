---
id: hook-session-start
title: SessionStart hook (mem hook-session-start)
aliases: [session start hook]
kind: hook
project: workflow-memory
status: active
location: workflow-memory:mem/hooks.py
fed_by: [claude-code-settings, mem-sync]
feeds: [session-brief]
sources: [workflow-memory:mem/hooks.py]
---

## What it is
The Claude Code hook that runs when a chat starts: `python3 ~/dev/workflow-memory/bin/mem hook-session-start` (timeout 40 s).

## What it does
Pulls the memory repo, folds the events, and prints the [[session-brief]] for the current project (the folder name of the chat).

## How it does it
Must never fail loudly: its stdout goes into the model's context, so errors are written to `~/.local/state/mem/hook.log` instead. Offline it falls back to the last pulled state.

## Where it sits in the pipeline
First step of [[chat-start]].

## Who receives its output
[[session-brief]] → the Claude Code session.
