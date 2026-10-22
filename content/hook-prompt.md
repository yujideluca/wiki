---
id: hook-prompt
title: UserPromptSubmit hook (mem hook-prompt)
aliases: [prompt hook]
kind: hook
project: workflow-memory
status: active
location: workflow-memory:mem/hooks.py
fed_by: [claude-code-settings]
feeds: [mem-harvester]
sources: [workflow-memory:mem/hooks.py]
---

## What it is
The Claude Code hook that runs on every message Giovanni sends: `mem hook-prompt` (timeout 10 s).

## What it does
Passes the message text to [[mem-harvester]], which records any preference Giovanni stated. Prints nothing.

## How it does it
Errors go to the hook log; it always exits 0 so it can never block a message.

## Where it sits in the pipeline
Between Giovanni's message and the model.

## Who receives its output
[[mem-harvester]].
