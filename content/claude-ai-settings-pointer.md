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
A short Portuguese text pasted once into claude.ai Settings > preferences; it lives in `docs/CLAUDE-AI.md`.

## What it does
Tells every Claude app chat to load the GitHub tools, read `views/BRIEF.md` and follow it; if that fails, to follow at least three rules: reply in the message's language, explain plainly, never store clinical, secret or contact data about other people.

## How it does it
Only Giovanni can write that field, so it is a pointer: the content lives in the brief, which the Action regenerates. It replaced the line that made chats read `code/CORE.md` of the old repository.

## Where it sits in the pipeline
At the start of every Claude app chat.

## Who receives its output
[[mem-github-connector]].
