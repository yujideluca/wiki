---
id: memory-fold
title: The fold (core.py)
aliases: [fold, core.py, resolve]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/core.py
fed_by: [events-log]
feeds: [memory-views, session-brief]
sources: [workflow-memory:mem/core.py]
---

## What it is
The one pure function of [[workflow-memory]]: it folds the log of events into the current state.

## What it does
Latest ruling per (scope, key) wins; the same ruling again adds evidence; a negation is a change; `forget` and `done` close their target; feedback changes salience (`wrong` removes an entry from the brief and lists it for review); a harvester event never overwrites Giovanni's own words; two writers giving one key different texts within 24 h become a conflict, not a merge. Then it ranks entries for the brief: preferences never decay, other types fade with half-lives (decision and fact 180 days, note 7 days), stretched by each use.

## How it does it
Order-independent and idempotent (tested): events are sorted by time then id and duplicates count once. `brief()` fits the result into a budget of about 2,900 characters (2.5 % of a typical first turn, calibrated by `scripts/calibrate.py`).

## Where it sits in the pipeline
Between [[events-log]] and everything that shows memory.

## Who receives its output
[[session-brief]] (via [[hook-session-start]]) and [[memory-views]] (via [[mem-action]]).
