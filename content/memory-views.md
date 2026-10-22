---
id: memory-views
title: views/ (BRIEF, PREFERENCES, REVIEW)
aliases: [BRIEF.md, REVIEW.md, PREFERENCES.md]
kind: data
project: workflow-memory
status: active
location: workflow-memory:views
fed_by: [mem-action, memory-fold]
feeds: [claude-app, giovanni]
sources: [workflow-memory:mem/project.py]
---

## What it is
The generated, read-only files of [[workflow-memory]]: `BRIEF.md` (what Claude app chats read), `PREFERENCES.md`, `REVIEW.md` (the only list that needs Giovanni).

## What it does
BRIEF holds the ranked entries, open items and, at the end, how a chat records a correction. REVIEW lists conflicts, entries marked wrong, quarantined files, harvester proposals and warnings.

## How it does it
Never edited by hand: rebuilt by `mem build` and by [[mem-action]] on every push and daily; CI fails if a view was edited (`build --check`).

## Where it sits in the pipeline
The output side of the memory, for readers that cannot run `mem`.

## Who receives its output
[[claude-app]] (BRIEF through the GitHub connector) and [[giovanni]] (REVIEW).
