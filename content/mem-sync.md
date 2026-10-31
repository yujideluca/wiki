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
sources: [workflow-memory:mem/sync.py, workflow-memory:tests/test_sync_views.py]
reviewed: 2026-10-31T22:07Z
---

## What it is
`mem sync` keeps the laptop's copy of the memory repository in step with GitHub. The copy is called a clone; GitHub holds the original.

## What it does
`pull` downloads the newest version before the memory is read (at the start of a session). `push` uploads new events after they were written (at the stop hook), with retries. It never merges the derived files (the generated views), because those can always be regenerated.

## How it does it
It uses Git with time limits. Before uploading, it downloads remote changes and replays local commits on top of them (a rebase). If an event conflicts, it reports `conflict after pull, nothing pushed:` and stops before attempting an upload. It leaves the conflicting files available for inspection. It never force-pushes.

The integration test uses real local Git repositories. It creates a shared event dated 2001 before a new event dated 2000, and uses the path printed by `mem add` to select the new event. These fixed dates catch selection by file order without depending on the clock. The test requires the conflict message, an unchanged remote history reference, no upload attempt and an unresolved event file. Git calls are recorded and forwarded to the real Git program; their results are not simulated.

## Where it sits in the pipeline
Between the local clone and [[github]].

## Who receives its output
[[github]] and [[hook-session-start]].
