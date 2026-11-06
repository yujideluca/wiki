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
reviewed: 2026-11-06T21:22Z
---

## What it is
`mem sync` keeps the laptop's copy of the memory repository in step with GitHub. The copy is called a clone; GitHub holds the original.

## What it does
`pull` downloads the newest version before the memory is read (at the start of a session). `push` uploads new events after they were written (at the stop hook), with retries. It never merges the derived files (the generated views), because those can always be regenerated.

## How it does it
It uses Git with time limits. Several sessions often start at the same moment and work on the same clone, so only one sync at a time works on it: each takes a lock file (`mem-sync.lock` in the clone's `.git` folder) and waits up to 15 seconds for it before going ahead anyway. It does not use `git pull`: that command merges whatever is listed in `.git/FETCH_HEAD`, a file that simultaneous downloads append to, and it then failed with "Cannot fast-forward to multiple branches" (shown at session start as "memory may be stale"). Instead it downloads without writing that file (`git fetch --no-write-fetch-head`, tried a second time if it fails) and then moves forward to the downloaded branch (`git merge --ff-only @{u}`). Before uploading, it downloads remote changes the same way and replays local commits on top of them (a rebase). If an event conflicts, it reports `conflict after pull, nothing pushed:` and stops before attempting an upload. It leaves the conflicting files available for inspection. It never force-pushes.

The integration test uses real local Git repositories. It creates a shared event dated 2001 before a new event dated 2000, and uses the path printed by `mem add` to select the new event. These fixed dates catch selection by file order without depending on the clock. The test requires the conflict message, an unchanged remote history reference, no upload attempt and an unresolved event file. Git calls are recorded and forwarded to the real Git program; their results are not simulated. Two more tests make `.git/FETCH_HEAD` unwritable (pull and push must still work) and run four pulls of one clone at once (all must report `pulled`).

## Where it sits in the pipeline
Between the local clone and [[github]].

## Who receives its output
[[github]] and [[hook-session-start]].
