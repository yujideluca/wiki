---
id: mem-github-connector
title: Writing memory from the Claude app
aliases: [GitHub connector, app writes memory]
kind: process
project: workflow-memory
status: active
fed_by: [claude-ai-settings-pointer, claude-app]
feeds: [events-log]
sources: [workflow-memory:docs/CLAUDE-AI.md, workflow-memory:README.md]
---

## What it is
How the [[claude-app]], which cannot run `mem`, still reads and writes the shared memory.

## What it does
Reads `views/BRIEF.md` at the start of each chat and records a correction by creating one new event file.

## How it does it
Through the GitHub connector (its tools are deferred in the app and must be loaded by name), following the how-to at the end of BRIEF.md. Tested on the phone app (plain and project chats).

## Where it sits in the pipeline
The Claude app's side of [[workflow-memory]].

## Who receives its output
[[events-log]].

## Steps
1. The chat starts; the pointer in claude.ai Settings ([[claude-ai-settings-pointer]]) tells it to load the GitHub tools.
2. It reads `views/BRIEF.md` of `yujideluca/workflow-memory` (branch main) — [[memory-views]].
3. Giovanni gives a correction; the chat creates one event file in `events/` with the format of the brief's how-to ([[events-log]]).
4. The push triggers [[mem-action]], which validates the file ([[mem-validator]]) and rebuilds [[memory-views]].
5. The next Claude Code session pulls it in its brief ([[hook-session-start]]).
