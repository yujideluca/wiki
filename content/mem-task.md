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
---

## What it is
How an unfinished goal or known problem is kept in front of Giovanni until it is dealt with: `mem task --check HOW [--category C] "text"`.

## What it does
Creates a `task` event (`what is open | check: how to verify it still applies`). It is shown at the start of every chat until Giovanni decides: solved (`mem done`), parked (`mem archive`, back with `mem reopen`) or deleted (`mem forget`). Rules are in [[mem-pendency]].

## How it does it
The CLI refuses a task without a check. Before reminding Giovanni of one, Claude runs its check; if it no longer applies, Claude closes it instead.

## Where it sits in the pipeline
Created at the end of a session for anything still open.

## Who receives its output
[[events-log]], then the [[session-brief]] of every chat.
