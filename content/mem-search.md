---
id: mem-search
title: mem search
aliases: [memory search]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/search.py
fed_by: [events-log]
feeds: []
sources: [workflow-memory:mem/search.py]
---

## What it is
Full-text search over every memory entry, including those too cold to appear in the brief and archived open items.

## What it does
`mem search "words"` prints matching entries with their #codes.

## How it does it
A derived SQLite FTS5 index rebuilt from the log on each call and never committed; vectors could be added later without touching the log.

## Where it sits in the pipeline
Used when the brief says "N more entries did not fit".

## Who receives its output
The Claude instance that searched.
