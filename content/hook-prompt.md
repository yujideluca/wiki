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
sources: [workflow-memory:mem/hooks.py, workflow-memory:docs/adr/0008-router-rules-as-modules.md, workflow-memory:mem/tags.py]
reviewed: 2026-11-07T23:44Z
---

## What it is
A hook is a small program that [[claude-code]] runs automatically at a certain event ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)). This one runs every time Giovanni sends a message: the command `mem hook-prompt`, with a time limit of 10 seconds.

## What it does
It passes the text of the message to the [[mem-harvester]], which looks for a preference that Giovanni has stated and records it, so that a rule said once is not forgotten. Since 2026-11-07 the hook also prints one line for every message, the router reminder: "mem router: first classify this message into tags (deploy, outward, …) and run mem rules TAG [TAG ...] for tags not loaded yet in this conversation, before skills, files or other commands." Whatever a hook prints here goes into the model's context, so the reminder reaches the chat even days after it started, when the start-up text is long gone. The harvesting itself stays silent.

## How it does it
It is designed never to get in the way. Any error goes to the hook log, and the program always ends with exit code 0 (the number a program returns to say "all fine"), so a failure here can never block a message from reaching Claude. Messages longer than 1500 characters are not read for preferences, because they are pasted documents or prompts written by a program.

## Where it sits in the pipeline
Between Giovanni's message and the model: the message is read on the way through.

## Who receives its output
The [[mem-harvester]].
