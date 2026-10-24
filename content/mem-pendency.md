---
id: mem-pendency
title: Open items: rules (pendency.py)
aliases: [pendency rules]
kind: decision
project: workflow-memory
status: active
location: workflow-memory:mem/pendency.py
fed_by: []
feeds: [session-brief]
sources: [workflow-memory:mem/pendency.py]
---

## What it is
These are the rules for "open items" (see [[mem-task]]): unfinished goals and known problems that are kept in front of Giovanni. They form their own flow inside the memory, with their own size budget, so that a flood of old preferences can never push an open item out. The code is in `mem/pendency.py`.

## What it does
Nothing lapses: an item is shown in every chat until it is solved, parked or deleted. By default it is shown in every project; only when Giovanni says so is an item or a category made specific to one project (`mem scope project:X`). The budget is 2,000 tokens (a token is a small piece of text, roughly three-quarters of a word), separate from the brief's budget; one item may be at most 500 characters; the most recently active come first.

## How it does it
The session start always says how to record, solve, park, delete and scope an item. When items are shown, it also adds the verify rule: run the item's check before reminding Giovanni; if the item no longer applies, close it; if it could not be checked, say "unchecked". The rule was created after an item was reported as open from memory of the conversation on 2026-10-20, although it had already been settled.

## Where it sits in the pipeline
Part of the brief that [[hook-session-start]] builds.

## Who receives its output
The [[session-brief]].
