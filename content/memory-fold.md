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
reviewed: 2026-10-22T16:33Z
---

## What it is
"The fold" is the single function at the heart of [[workflow-memory]]: it takes the whole log of events and "folds" it into the current state (like folding a long list into one result). In programming terms it is a [pure function](https://en.wikipedia.org/wiki/Pure_function): the same input always gives the same output and it changes nothing else. It lives in `mem/core.py`.

## What it does
For each topic (scope plus key) the latest ruling wins; the same ruling repeated adds evidence; a negation counts as a change; `forget` and `done` close their target; feedback changes how prominent an entry is (`wrong` removes it from the brief and lists it for Giovanni to review). An event from the automatic [[mem-harvester]] never overwrites Giovanni's own words. If two writers give the same key different texts within 24 hours, the result is a conflict that Giovanni sees, not a silent merge. It then ranks the entries for the brief: preferences never fade; other types fade with a half-life (the time after which weight halves): 180 days for decisions and facts, 7 days for notes, stretched by each reported use ([[mem-use]]).

## How it does it
The result does not depend on the order in which events arrive and is [idempotent](https://en.wikipedia.org/wiki/Idempotence) (applying a duplicate changes nothing); both properties are tested. Events are sorted by time and then id, and duplicates count once. The function `brief()` fits the result into a budget of about 2,900 characters, which is about 2.5 % of a typical first turn; the number was calibrated with `scripts/calibrate.py`.

## Where it sits in the pipeline
Between [[events-log]] and everything that shows memory.

## Who receives its output
The [[session-brief]] (through [[hook-session-start]]) and [[memory-views]] (through [[mem-action]]).
