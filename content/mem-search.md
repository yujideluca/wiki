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
`mem search` is a full-text search over every memory entry, including the ones too old to appear in the brief and open items that were parked. Use it when the brief says "N more entries did not fit".

## What it does
`mem search "words"` prints the matching entries together with their `#code`.

## How it does it
It builds a temporary index with SQLite FTS5 ([SQLite](https://www.sqlite.org/) is a small database engine; FTS5 is its full-text search feature) from the log every time it is called and never stores it in the repository. If wanted, "vector" (meaning-based) search could be added later without touching the log.

## Where it sits in the pipeline
Used when the short brief does not contain what is needed.

## Who receives its output
The Claude instance that searched.
