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
reviewed: 2026-10-22T16:33Z
---

## What it is
A hook is a small program that [[claude-code]] runs automatically when a certain event happens ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This one runs when a chat starts: `python3 ~/dev/workflow-memory/bin/mem hook-session-start`, with a time limit of 40 seconds. Its job is to give the new chat its memory.

## What it does
It downloads the newest version of the memory from GitHub, combines the stored events into the current state, and prints the [[session-brief]] for the current project (the project is taken from the name of the folder the chat was opened in). Whatever a hook prints at this moment is placed in front of the model, which is how Claude "remembers" Giovanni's preferences.

## How it does it
It must never fail loudly, because its printed output goes straight into the model's context: an error message there would confuse the chat. So errors are written to a log file, `~/.local/state/mem/hook.log`, instead. If the laptop is offline it falls back to the last state it downloaded, and the brief then says that the memory may be stale.

## Where it sits in the pipeline
It is the first step of [[chat-start]].

## Who receives its output
The [[session-brief]], and through it the Claude Code session.
