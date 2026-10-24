---
id: mem
title: mem (memory command)
aliases: [bin/mem, mem CLI]
kind: program
project: workflow-memory
status: active
location: workflow-memory:bin/mem
fed_by: [claude-code, giovanni, remote-assistant]
feeds: [events-log]
sources: [workflow-memory:bin/mem, workflow-memory:mem/cli.py]
reviewed: 2026-10-22T16:33Z
---

## What it is
`mem` is the command-line tool of [[workflow-memory]] (a command-line tool is a program you run by typing its name and options in a terminal). It is how [[claude-code]] and the [[remote-assistant]] read and write the shared memory. It is written in Python 3 and needs nothing beyond Python's standard library.

## What it does
It writes one new event file per change ([[mem-add]], [[mem-use]], [[mem-task]], and also feedback, forget, done, claim and similar), prints the brief, searches the memory ([[mem-search]]), checks files for problems, builds the readable files in [[memory-views]], synchronises with GitHub, and installs its own Claude Code hooks.

## How it does it
The file `mem/cli.py` reads the command line and calls the modules: `events.py` (writing and reading event files), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]] and `install.py`.

## Where it sits in the pipeline
It is the door through which the memory is written on the laptop. The hooks call it too, as `mem hook-session-start`, `mem hook-prompt` and `mem hook-stop`.

## Who receives its output
[[events-log]] (the new files) and the terminal (the brief, search results).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: record a correction or lasting preference
- `mem feedback REF wrong|stale|helpful|not_helpful`: rate an entry
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: delete, solve, park, bring back
- `mem claim REF`: claim a task (the earliest claim wins)
- `mem pending`, `mem scope`: list and scope open items
- `mem brief`, `mem search "words"`: print the brief, full-text search
- `mem check`, `mem quarantine`, `mem dismiss`: validity of event files
- `mem promote`, `mem compact [--apply]`: make habits global; summarise old entries
- `mem build [--check]`: regenerate the views
- `mem sync [--pull] [--push]`, `mem install-hooks`
