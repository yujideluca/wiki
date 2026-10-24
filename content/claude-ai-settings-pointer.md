---
id: claude-ai-settings-pointer
title: claude.ai Settings pointer
aliases: [CLAUDE-AI.md]
kind: data
project: workflow-memory
status: active
location: workflow-memory:docs/CLAUDE-AI.md
fed_by: []
feeds: [mem-github-connector]
sources: [workflow-memory:docs/CLAUDE-AI.md]
---

## What it is
A "pointer" is a short text that points somewhere else instead of holding the content itself. This one is a short Portuguese text that Giovanni pasted once into the preferences field of the claude.ai settings. A copy is kept in the file `docs/CLAUDE-AI.md` of [[workflow-memory]].

## What it does
It tells every chat in the Claude app to load the GitHub tools, read the file `views/BRIEF.md` and follow it. If that fails, the chat still follows three basic rules: reply in the language of the message, explain things plainly, and never store clinical, secret or contact data about other people.

## How it does it
Only Giovanni can write into that settings field, so nothing long can be kept there. That is why it is only a pointer: the real content lives in the brief, which a GitHub Action (an automatic job on GitHub) regenerates whenever memory changes. The pointer replaced an older line that made chats read `code/CORE.md` of the old, retired repository.

## Where it sits in the pipeline
At the very start of every chat in the [[claude-app]].

## Who receives its output
[[mem-github-connector]], the process by which the app then reads and writes memory.
