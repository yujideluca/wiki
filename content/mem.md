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
---

## What it is
The command-line tool of [[workflow-memory]]: how Claude Code and the assistant read and write the shared memory. Python 3, standard library only.

## What it does
Writes one new event file per change ([[mem-add]], [[mem-use]], [[mem-task]], feedback, forget, done, claim…), prints the brief, searches ([[mem-search]]), validates, builds [[memory-views]], syncs with GitHub, and installs its own Claude Code hooks.

## How it does it
`mem/cli.py` parses the command and calls the modules: `events.py` (write/read files), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]], `install.py`.

## Where it sits in the pipeline
The write door of the memory on the laptop; the hooks call it as `mem hook-session-start`, `hook-prompt`, `hook-stop`.

## Who receives its output
[[events-log]] (new files) and the terminal (brief, search results).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: record a correction or lasting preference
- `mem feedback REF wrong|stale|helpful|not_helpful`: rate an entry
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: close, solve, park, bring back
- `mem claim REF`: claim a task (earliest claim wins)
- `mem pending`, `mem scope`: list and scope open items
- `mem brief`, `mem search "words"`: print the brief, full-text search
- `mem check`, `mem quarantine`, `mem dismiss`: validity of event files
- `mem promote`, `mem compact [--apply]`: global habits; digest cold entries
- `mem build [--check]`: regenerate views
- `mem sync [--pull] [--push]`, `mem install-hooks`
