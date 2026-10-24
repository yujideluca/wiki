---
id: claude-auto-memory
title: Claude Code auto-memory
aliases: [MEMORY.md, auto memory]
kind: data
project: laptop-setup
status: active
location: home:.claude/projects/-home-yuji/memory
fed_by: []
feeds: [claude-code]
sources: [home:.claude/projects/-home-yuji/memory]
---

## What it is
Claude Code has a small memory of its own, separate from the shared one. It is a folder of short text files, one fact per file, plus an index file called `MEMORY.md`. It is used for chats started in the home folder, and the index is loaded into the start of every such chat. This is the "auto-memory" documented in the [Claude Code memory guide](https://docs.claude.com/en/docs/claude-code/memory).

## What it does
It holds notes that only matter on this laptop: how to check on the remote assistant, the German Quiz project, where the user-space tools are installed, the rule that code must be debugged before being reported done, the fact that a certain notice about a German-conversation skill is not meant for Claude Code, and the fact that the old pipeline is retired.

## How it does it
Claude Code writes these files itself, in a fixed format (a small header, the fact, why it matters, how to apply it). Rules that must be shared between all the Claude instances do not belong here; they go into the shared memory [[workflow-memory]] instead.

## Where it sits in the pipeline
Loaded at the start of a chat ([[chat-start]]), next to the instructions in [[global-claude-md]].

## Who receives its output
[[claude-code]].
