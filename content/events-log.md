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
---

## What it is
The memory itself: one Markdown file per event in `events/YYYY/MM/`, named `<time>-<instance>-<6 chars>.md` (the name is the id; its last segment is the #code shown in the brief).

## What it does
Holds every preference, fact, decision, task, note and control event (feedback, claim, done, forget, use, archive, reopen, rescope). Files are never edited or deleted, so writers never conflict (ADR-0002).

## How it does it
A header (`type`, `scope`, `key`, `owner`, `instance`, `ts`, optional `supersedes`, `target`, `signal`, `category`) and one or two sentences. CI job `append-only` rejects edits; invalid files are moved to `quarantine/` by [[mem-validator]].

## Where it sits in the pipeline
Written by [[mem]] (laptop) and [[mem-github-connector]] (Claude app); read by [[memory-fold]].

## Who receives its output
[[memory-fold]] and [[mem-action]].
