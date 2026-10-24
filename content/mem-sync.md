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
`mem sync` keeps the laptop's copy of the memory repository in step with GitHub. The copy is called a clone; GitHub holds the original.

## What it does
`pull` downloads the newest version before the memory is read (at the start of a session). `push` uploads new events after they were written (at the stop hook), with retries. It never merges the derived files (the generated views), because those can always be regenerated.

## How it does it
It uses plain git with time limits. If another writer uploaded at the same moment and the upload was refused, it starts again from the newest `main` (the main line of the history). It never force-pushes.

## Where it sits in the pipeline
Between the local clone and [[github]].

## Who receives its output
[[github]] and [[hook-session-start]].
