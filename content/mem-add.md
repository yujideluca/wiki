---
id: mem-add
title: mem add (record a preference or fact)
aliases: [add entry, record preference]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/cli.py
fed_by: []
feeds: [events-log]
sources: [workflow-memory:mem/cli.py, workflow-memory:mem/tags.py]
reviewed: 2026-11-07T22:03Z
---

## What it is
`mem add` is the command that records a new entry in the memory: a preference, a fact, a decision, a task or a note. It is what Claude runs when Giovanni corrects it or states a lasting preference.

## What it does
`mem add --type pref --owner user --key topic "the rule"` writes one event file. Each entry has a `key`, a short name for its topic. A newer entry with the same key replaces the older one: the new entry is automatically marked as superseding the old, so a rule that Giovanni changes is updated rather than duplicated. Add `--tags deploy,git` to say for which kinds of task the rule matters (see [[mem-rules]]): without `--tags`, an entry that replaces another keeps the old tags, and `--tags -` clears them.

## How it does it
The entry is checked by [[mem-validator]] before it is written, and the text may be at most 1200 characters. Empty or placeholder text ("...", "TODO", a single letter) is refused, because three rules with the text "..." were once recorded by mistake and shown in every task of their kind. The `owner` field matters: `user` means the words are Giovanni's own, which the automatic [[mem-harvester]] may never overwrite.

## Where it sits in the pipeline
Used whenever Giovanni corrects Claude or states a lasting preference (a rule in the global instructions, [[global-claude-md]]).

## Who receives its output
[[events-log]].
