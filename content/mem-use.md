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
---

## What it is
The end-of-task report: `mem use REF1,REF2 --note "how"`, naming the memory entries (by their #code) that shaped the work.

## What it does
Each use stretches an entry's half-life by `1 + log2(1 + uses)`, so rules that are used stay in the brief; for an open item it records when and how it was last checked. It is also the trigger point of the wiki update ([[end-of-task]]).

## How it does it
Writes a `use` event with `target: ref1, ref2` and one short line (the note has a length limit).

## Where it sits in the pipeline
The last step of every task, right after `wiki publish`.

## Who receives its output
[[events-log]]; [[memory-fold]] counts the uses when ranking the brief.
