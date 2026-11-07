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
sources: [workflow-memory:mem/project.py, workflow-memory:mem/tags.py, workflow-memory:docs/adr/0008-router-rules-as-modules.md]
reviewed: 2026-11-07T23:44Z
---

## What it is
The `views/` folder contains the readable summaries of [[workflow-memory]]. They are generated, never written by hand: `BRIEF.md` (what chats in the [[claude-app]] read), `rules/TAG.md` (one file per kind of task, with the full wording of its rules), `PREFERENCES.md` (all standing preferences) and `REVIEW.md` (the only list that needs Giovanni's attention). They exist for readers that cannot run the [[mem]] command.

## What it does
BRIEF holds the router (the order to classify each request into tags and fetch their rules first; no rule is printed in BRIEF itself), an index of the kinds of task (tags), the open items and, at the end, instructions on how a chat records a correction. A chat that is about to do a task of one kind fetches `rules/TAG.md` for that tag, the same way the [[mem-rules]] command serves Claude Code. REVIEW lists everything that needs a human decision: conflicts between writers, entries marked wrong, quarantined files, proposals made by the automatic harvester, and warnings (for example a rule that has no tag).

## How it does it
The files are rebuilt by `mem build` and by [[mem-action]] on every push and once a day. Continuous integration (CI, automatic checks on every push) fails if somebody edited a view by hand, using `build --check`, which rebuilds and compares.

## Where it sits in the pipeline
The output side of the memory.

## Who receives its output
The [[claude-app]] (BRIEF, through the GitHub connector) and [[giovanni]] (REVIEW).
