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
reviewed: 2026-11-22T18:09Z
---

## What it is
These are the rules for "open items" (see [[mem-task]]): unfinished goals and known problems that are kept in front of Giovanni. They form their own flow inside the memory, with their own size budget, so that a flood of old preferences can never push an open item out. The code is in `mem/pendency.py`.

## What it does
Nothing lapses: an item is shown in every chat until it is solved, parked or deleted. By default it is shown in every project; only when Giovanni says so is an item or a category made specific to one project (`mem scope project:X`). The budget is 1,000 tokens (a token is a small piece of text, roughly three-quarters of a word) for the whole printed section, that is the heading, the items, the closing line and the two fixed rules; it is separate from the brief's budget; the most recently active come first. Since 2026-11-22 the list at the start of a chat is a briefing: each item is its text up to 200 characters, without its check, and items that do not fit are counted in one closing line. `mem pending` prints every item whole (up to 500 characters at start-up before that day), with its check. The budget was 2,000 tokens before; the reason for the change is on the page [[task-delegation]].

## How it does it
The session start always says how to record, solve, park, delete and scope an item. When items are shown, it also adds the verify rule: run the item's check before reminding Giovanni; if the item no longer applies, close it; if it could not be checked, say "unchecked". The rule was created after an item was reported as open from memory of the conversation on 2026-10-20, although it had already been settled.

## Where it sits in the pipeline
Part of the brief that [[hook-session-start]] builds.

## Who receives its output
The [[session-brief]].
