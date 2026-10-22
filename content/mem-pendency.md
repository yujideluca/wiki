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
The rules that govern open items ([[mem-task]]): their own memory flow with their own budget.

## What it does
Nothing lapses: an item shows in every chat until solved, parked or deleted. Shown everywhere by default; only when Giovanni says so is an item or category made project-specific (`mem scope project:X`). Budget 2,000 tokens, separate from the brief's; one item at most 500 characters; most recently active first.

## How it does it
Session start always says how to record, solve, park, delete and scope; when items are shown it adds the verify rule (run the check before reminding; if it no longer applies, close it; if not checked, say "unchecked"). Created after an item was reported as open from memory of the conversation on 2026-10-20, though it was already settled.

## Where it sits in the pipeline
Part of the brief built by [[hook-session-start]].

## Who receives its output
[[session-brief]].
