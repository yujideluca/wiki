---
id: mem
title: mem (memory command)
aliases: [bin/mem, mem CLI]
kind: program
project: workflow-memory
status: active
location: workflow-memory:bin/mem
fed_by: [claude-code, codex, giovanni, remote-assistant]
feeds: [events-log]
sources: [workflow-memory:bin/mem, workflow-memory:mem/cli.py]
reviewed: 2026-10-27T01:45Z
---

## What it is
`mem` is the command-line tool of [[workflow-memory]] (a command-line tool is a program you run by typing its name and options in a terminal). It is how [[claude-code]] and the [[remote-assistant]] read and write the shared memory. It is written in Python 3 and needs nothing beyond Python's standard library.

## Architecture
### Context
person g: Giovanni — runs it by hand now and then | [[giovanni]]
person c: Claude Code — writes events and reads the brief | [[claude-code]]
person x: Codex — the same, with its own scope | [[codex]]
person r: Remote assistant — the same, from the phone | [[remote-assistant]]
system m: mem — the memory command
external e: Event log — the files it reads and writes | [[events-log]]
external h: GitHub — where the memory is kept in step | [[github]]

g -runs-> m
c -runs-> m
x -runs-> m
r -runs-> m
m -reads and appends to-> e
m -synchronises with-> h

### Containers
person u: Giovanni or an assistant
container cl: cli.py — reads the command line and calls the modules
container ev: Events — write and read event files
container fo: Fold — turns the log into the current entries | [[memory-fold]]
container ck: Checks — validator, harvester and pendencies | [[mem-validator]], [[mem-harvester]]
container se: Search — finds entries by words | [[mem-search]]
container sy: Sync and installer — GitHub pull and push, Claude Code hooks | [[mem-sync]]
store lg: Event log — one file per event | [[events-log]]
store vw: Views — the readable files it builds | [[memory-views]]

u -runs-> cl
cl -calls-> ev
cl -calls-> fo
cl -calls-> ck
cl -calls-> se
cl -calls-> sy
ev -writes and reads-> lg
fo -writes-> vw

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
