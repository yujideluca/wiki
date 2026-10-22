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
A Claude Code session that runs all the time on the laptop and that [[giovanni]] reaches from the Claude app on the phone (Remote Control). It appears in the app as `yuji-nitro-assistant`.

## What it does
Short tasks on the laptop when Giovanni is away: same rules as [[claude-code]], writing to memory as instance `assistant`.

## How it does it
Kept alive by the [[claude-assistant]] service: a tmux session runs `claude remote-control` in a restart loop from the folder `~/assistant`, whose own CLAUDE.md asks for short, phone-friendly replies. Its permission mode was set by Giovanni himself.

## Where it sits in the pipeline
A second door into the same laptop and the same repos as Claude Code.

## Who receives its output
Same as [[claude-code]]: repos and [[events-log]] (with `MEM_INSTANCE=assistant`).
