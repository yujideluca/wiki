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
sources: [workflow-memory:mem/cli.py]
---

## What it is
The command that records a new entry: a preference, fact, decision, task or note.

## What it does
`mem add --type pref --owner user --key topic "the rule"` writes an event; a newer entry with the same key replaces the older one (it is marked `supersedes` automatically), so a rule changed by Giovanni is updated, not duplicated.

## How it does it
Validated by [[mem-validator]] before writing; text at most 1200 characters; owner `user` means Giovanni's own words, which the [[mem-harvester]] may never overwrite.

## Where it sits in the pipeline
Whenever Giovanni corrects Claude or states a lasting preference (global CLAUDE.md rule).

## Who receives its output
[[events-log]].
