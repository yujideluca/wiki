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
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the GitHub Actions workflow `.github/workflows/mem.yml` of [[workflow-memory]]. [GitHub Actions](https://docs.github.com/en/actions) is GitHub's service for running automatic jobs on its own computers, so no machine of Giovanni's needs to be on.

## What it does
It runs on every push to the events or the code, and also once a day (because the relevance of old entries fades with time). Each run: runs the tests, moves invalid events to quarantine, promotes habits seen in two projects to global preferences, rebuilds [[memory-views]] and commits the result. It also enforces that events are append-only (existing files are never edited).

## How it does it
It uses Python 3.12. It never merges generated files: if another push arrives at the same time and its own upload is refused, it resets to the newest `main` and generates again (up to five tries).

## Where it sits in the pipeline
On GitHub, after [[events-log]] changes.

## Who receives its output
[[memory-views]] (committed back to `main`).
