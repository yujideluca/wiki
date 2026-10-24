---
id: mem-task
title: mem task (open items)
aliases: [pendency, open item, mem pending]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/pendency.py
fed_by: []
feeds: [events-log]
sources: [workflow-memory:mem/pendency.py]
reviewed: 2026-10-22T16:33Z
---

## What it is
An "open item" is an unfinished goal or a known problem that Giovanni should not forget. `mem task --check HOW [--category C] "text"` is the command (CLI, command-line interface) that records one, so that it stays visible until it is dealt with.

## What it does
It creates a `task` event shaped as `what is open | check: how to verify it still applies`. The item is shown at the start of every chat until Giovanni decides: solved (`mem done`), parked (`mem archive`, brought back with `mem reopen`) or deleted (`mem forget`). The rules for open items are on [[mem-pendency]].

## How it does it
The command refuses a task that comes without a check, because an item that cannot be verified becomes a stale reminder. Before reminding Giovanni of an item, Claude runs its check; if the item no longer applies, Claude closes it instead of mentioning it.

## Where it sits in the pipeline
Created at the end of a session for anything that is still open.

## Who receives its output
[[events-log]], and then the [[session-brief]] of every chat.
