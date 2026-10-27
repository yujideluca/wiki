---
id: mem-use
title: mem use (report which entries shaped a task)
aliases: [use report]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/cli.py
fed_by: []
feeds: [events-log]
sources: [workflow-memory:mem/cli.py, workflow-memory:mem/core.py]
reviewed: 2026-10-27T00:22Z
---

## What it is
`mem use REF1,REF2 --note "how"` is the end-of-task report. It names the memory entries (by their short `#code`) that shaped the work, and says in a few words how they did.

## What it does
Each reported use makes the entry fade more slowly: its "half-life" (the time after which its weight in the brief halves) is stretched by the factor `1 + log2(1 + uses)`. Rules that are really used therefore stay in the brief, and unused ones gradually drop out. For an open item, it also records when and how it was last checked. It is also the point at which the wiki update is triggered ([[end-of-task]]).

## How it does it
It writes a `use` event listing the entries as `target: ref1, ref2` and one short line of note (the note has a length limit).

## Where it sits in the pipeline
The very last step of every task, right after `wiki publish`.

## Who receives its output
The memory log [[events-log]]; [[memory-fold]] counts the uses when it ranks entries for the brief.
