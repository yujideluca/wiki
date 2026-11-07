---
id: checks-workflow-memory
title: workflow-memory: checkers and rules
aliases: [memory checks, mem checks]
kind: decision
project: workflow-memory
status: active
fed_by: []
feeds: []
sources: [workflow-memory:tools/quality_gate.sh, workflow-memory:pipeline-check.toml, workflow-memory:.github/workflows/mem.yml, workflow-memory:.github/workflows/quality-gate.yml, workflow-memory:mem/validate.py, workflow-memory:docs/adr, workflow-memory:tests/test_tags.py]
reviewed: 2026-11-07T22:06Z
---

## What it is
These are the checkers of [[workflow-memory]], the shared memory of Giovanni's assistants. It stores events (records that something was decided or learned) as files and derives views from them.

## What it does
The gate has two steps: the unit tests (`python3 -m unittest discover`, seven test files) and `pipeline-check --measure-only`. Limits: no Python file over 400 lines in `mem`, `bin` and `scripts`, the gate at most 300 seconds. The content rules live in the code: every new event passes the validator in `mem/validate.py`, which checks the schema, clamps timestamps that lie in the future and applies the shared privacy patterns; an event that fails is moved to `quarantine/` with a `.reason` note ([[mem-validator]]). The invariant 'an event file is never edited in place' (ADR-0002 (an architecture decision record)) is a CI (continuous integration) job named `append-only`. `tests/test_tags.py` checks the rule tags, including that the start-up output of the real memory stays under 1,900 characters and that no rule written by Giovanni lacks a tag.

## How it does it
Two workflows exist: `mem.yml` (on every change to events, and daily) tests, quarantines, promotes and rebuilds the views and pushes them to `main`; `quality-gate.yml` runs on changes to the tools and tests. Branch protection is not possible here, because the `mem` job pushes with GitHub's built-in token; `protection_exception` records this and the local pre-push check stands in, guarded by the paths `mem/`, `bin/`, `scripts/`, `tests/`, `tools/`, `docs/` ([[branch-protection-explained]]). Six ADRs are in [[memory-adrs]].

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
