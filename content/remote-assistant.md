---
id: remote-assistant
title: Remote assistant
aliases: [claude-assistant, assistant]
kind: actor
project: none
status: active
fed_by: [claude-assistant, giovanni, global-claude-md, session-brief]
feeds: [mem]
reviewed: 2026-10-22
---

## What it is
The remote assistant is a Claude Code session that runs all the time on the laptop, and that [[giovanni]] can reach from the Claude app on the phone through a feature called Remote Control. In the app it appears as `yuji-nitro-assistant`. Think of it as a second door into the same laptop: the same Claude, the same repositories, but reachable from anywhere.

## What it does
It does short tasks on the laptop while Giovanni is away from it. It follows the same rules as [[claude-code]] and writes to the shared memory under the instance name `assistant`, so the memory can tell who wrote what.

## How it does it
The [[claude-assistant]] service keeps it alive: a tmux session (a terminal that keeps running without a window) runs `claude remote-control` in a restart loop from the folder `~/assistant`. That folder has its own CLAUDE.md (a text file of standing instructions that Claude Code reads at start) which asks for short replies that read well on a phone. Its permission mode (how much Claude may do without asking) was chosen by Giovanni personally.

## Where it sits in the pipeline
It is a second entrance to the same laptop and the same project repositories as Claude Code; the difference is only how Giovanni gets to it.

## Who receives its output
The same recipients as [[claude-code]]: the project repositories and the memory log [[events-log]] (entries are tagged with `MEM_INSTANCE=assistant`).
