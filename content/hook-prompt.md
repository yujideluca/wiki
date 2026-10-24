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
A hook is a small program that [[claude-code]] runs automatically at a certain event ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This one runs every time Giovanni sends a message: the command `mem hook-prompt`, with a time limit of 10 seconds.

## What it does
It passes the text of the message to the [[mem-harvester]], which looks for a preference that Giovanni has stated and records it, so that a rule said once is not forgotten. The hook itself prints nothing.

## How it does it
It is designed never to get in the way. Any error goes to the hook log, and the program always ends with exit code 0 (the number a program returns to say "all fine"), so a failure here can never block a message from reaching Claude.

## Where it sits in the pipeline
Between Giovanni's message and the model: the message is read on the way through.

## Who receives its output
The [[mem-harvester]].
