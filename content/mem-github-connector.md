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
reviewed: 2026-10-24T21:59Z
---

## What it is
The [[claude-app]] cannot run programs, so it cannot use the `mem` command. This page explains how it nevertheless reads and writes the shared memory: through the GitHub connector, an add-on that gives the app tools to read and write files in GitHub repositories.

## Flow
trigger t1: A chat starts in the Claude app | [[claude-app]]
step s1: The pointer in the claude.ai settings tells it to load the GitHub tools | [[claude-ai-settings-pointer]]
step s2: Reads views/BRIEF.md of workflow-memory, branch main | [[memory-views]]
trigger t2: Giovanni gives a correction in the chat | [[giovanni]]
step s3: Creates one event file in events/, in the format at the end of the brief | [[events-log]]
step s4: The push starts an action that validates the file and rebuilds the views | [[mem-action]], [[mem-validator]]
step s5: The next Claude Code session downloads the new views | [[hook-session-start]]
product p1: A chat that knows Giovanni's standing preferences
product p2: Rebuilt memory views | [[memory-views]]
product p3: The correction in the next Claude Code brief | [[session-brief]]

t1 -> s1
s1 -> s2
s2 -> p1
t2 -> s3
s3 -> s4
s4 -> p2
s4 -> s5
s5 -> p3

## What it does
At the start of each chat it reads `views/BRIEF.md`; when Giovanni corrects it, it records the correction by creating one new event file.

## How it does it
Its GitHub tools are "deferred" in the app, meaning they must be loaded by name before they can be used; the pointer text in the app settings ([[claude-ai-settings-pointer]]) tells it to do so. It then follows the how-to printed at the end of BRIEF.md. This was tested on the phone app, in plain chats and in project chats.

## Where it sits in the pipeline
The Claude app's side of [[workflow-memory]].

## Who receives its output
[[events-log]].

## Steps
1. The chat starts; the pointer in the claude.ai settings ([[claude-ai-settings-pointer]]) tells it to load the GitHub tools.
2. It reads `views/BRIEF.md` of `yujideluca/workflow-memory` (branch main) — see [[memory-views]].
3. Giovanni gives a correction; the chat creates one event file in `events/` in the format described at the end of the brief ([[events-log]]).
4. The push triggers [[mem-action]], which validates the file ([[mem-validator]]) and rebuilds [[memory-views]].
5. The next Claude Code session downloads it and shows it in its brief ([[hook-session-start]]).
