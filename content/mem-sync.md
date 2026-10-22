---
id: mem-sync
title: mem sync (pull and push)
aliases: [sync.py]
kind: function
project: workflow-memory
status: active
location: workflow-memory:mem/sync.py
fed_by: [hook-stop]
feeds: [github, hook-session-start]
sources: [workflow-memory:mem/sync.py]
---

## What it is
Keeps the laptop's clone of the memory repo in step with GitHub.

## What it does
`pull` before reading (session start); `push` after writing (stop hook), with retries; never merges derived files.

## How it does it
Plain git with timeouts; on a lost race it starts again from the newest `main`. Never force-pushes.

## Where it sits in the pipeline
Between the local clone and [[github]].

## Who receives its output
[[github]] and [[hook-session-start]].
