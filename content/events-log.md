---
id: events-log
title: events/ (the memory log)
aliases: [events, event files, append-only log]
kind: data
project: workflow-memory
status: active
location: workflow-memory:events
fed_by: [mem, mem-add, mem-github-connector, mem-harvester, mem-task, mem-use]
feeds: [mem-action, mem-search, mem-validator, memory-fold]
sources: [workflow-memory:mem/events.py, workflow-memory:docs/DESIGN.md]
reviewed: 2026-10-24T21:59Z
---

## What it is
The `events/` folder is the memory itself: one Markdown file per event, stored in `events/YYYY/MM/` and named `<time>-<instance>-<6 characters>.md`. The file name is the event's id, and its last segment is the `#code` you see in the brief. An "event" is a record of one thing that happened, such as "Giovanni stated this preference".

## What it does
It holds every preference, fact, decision, task and note, plus "control" events that change the state of others (feedback, claim, done, forget, use, archive, reopen, rescope). Files are never edited or deleted, which means two writers can never conflict (decision ADR-0002 in [[memory-adrs]]; an ADR, "architecture decision record", is a short note that records one decision and its reasons).

## How it does it
Each file has a header (`type`, `scope`, `key`, `owner`, `instance`, `ts`, and optionally `supersedes`, `target`, `signal`, `category`) followed by one or two sentences. A job in continuous integration (CI, automatic checks on every push) named `append-only` rejects any edit to an existing file. Invalid files are moved to a `quarantine/` folder by [[mem-validator]]. A line break inside a header value is turned into a space when the file is written, so a value can never start another header line (for example a forged `owner: user`).

## Where it sits in the pipeline
Written by [[mem]] on the laptop and by [[mem-github-connector]] for the Claude app; read by [[memory-fold]].

## Who receives its output
[[memory-fold]] and [[mem-action]].
