---
id: mem-action
title: mem GitHub Action (mem.yml)
aliases: [mem workflow, mem-action]
kind: service
project: workflow-memory
status: active
location: workflow-memory:.github/workflows/mem.yml
fed_by: [events-log]
feeds: [memory-views]
sources: [workflow-memory:.github/workflows/mem.yml]
---

## What it is
The GitHub Actions workflow that keeps the memory consistent without any machine of Giovanni's being on.

## What it does
On every push to events or code and once a day (relevance decays with time): runs the tests, quarantines invalid events, promotes habits seen in two projects, rebuilds [[memory-views]], commits. Also enforces that events are append-only.

## How it does it
Python 3.12; never merges derived files: on a lost race it resets to the newest `main` and derives again (up to five tries).

## Where it sits in the pipeline
On GitHub, after [[events-log]] changes.

## Who receives its output
[[memory-views]] (committed back to `main`).
