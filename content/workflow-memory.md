---
id: workflow-memory
title: workflow-memory (shared memory)
aliases: [memory, mem repo]
kind: project
project: none
status: active
location: workflow-memory:
fed_by: [claude-code, codex]
feeds: []
sources: [workflow-memory:README.md, workflow-memory:docs/DESIGN.md]
reviewed: 2026-10-27T01:34Z
---

## What it is
workflow-memory is the shared, long-lived memory of all the Claude assistants Giovanni uses. A Claude chat normally forgets everything when it ends; this project is what lets a preference said once ("answer in the language I wrote in") still apply months later, in a different chat, on a different device. It is a public repository (`yujideluca/workflow-memory`, since 2026-10-25) and lives in `~/dev/workflow-memory`. It has no branch protection on purpose: its `mem` job pushes derived files to `main` and a required check would reject them, so the local pre-push check stands in and `pipeline-check.toml` records the exception ([[maintenance-pipeline]]). It replaced the retired protocol described in [[retired-workflow-pipeline]].

## Flow
trigger t1: Giovanni states a correction or a lasting preference | [[giovanni]]
step s1: Claude Code writes it with mem; the Claude app writes through the connector | [[mem]], [[mem-github-connector]]
step s2: One new file is added to the log and never edited later | [[events-log]]
step s3: A GitHub action validates the file and rebuilds the readable views | [[mem-action]], [[memory-views]]
step s4: memory-fold reads the log and works out the current state, the latest ruling wins | [[memory-fold]]
trigger t2: A new chat starts | [[claude-code]]
step s5: The start hook prints the brief | [[hook-session-start]], [[session-brief]]
product p1: Every Claude instance follows the preference in later chats
product p2: A review file waiting for Giovanni | [[memory-views]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s3 -> p2
s4 -> s5
t2 -> s5
s5 -> p1

## Architecture
### Context
person g: Giovanni — states preferences and corrections | [[giovanni]]
external c: Claude Code — reads the brief, writes events | [[claude-code]]
external x: Codex — the same, with its own memory scope | [[codex]]
system w: workflow-memory — the shared memory of Giovanni's systems
external h: GitHub — runs the checks and keeps the history | [[github]]

g -tells-> c
g -tells-> x
c -writes events to and reads the brief from-> w
x -writes events to and reads the brief from-> w
w -is checked and rebuilt on-> h

### Containers
person g: Giovanni | [[giovanni]]
external c: Claude Code | [[claude-code]]
container hk: Start-of-chat hook — prints the brief | [[hook-session-start]]
container m: mem command — adds events, folds them, searches | [[mem]]
store ev: Event log — one file per event, append-only | [[events-log]]
store vw: Views — derived summaries, never edited by hand | [[memory-views]]
container ci: GitHub job — rebuilds the views, refuses edits to old events | [[mem-action]]

g -tells-> c
c -starts-> hk
c -runs-> m
hk -asks for the brief-> m
m -appends to-> ev
m -rebuilds-> vw
ci -checks-> ev
ci -rebuilds-> vw

## What it does
It keeps preferences, facts, decisions and open items (things still to be done), and shows the relevant ones at the start of every chat as the [[session-brief]]. It is the only channel between the different Claude instances ([[claude-code]], the [[remote-assistant]] and the [[claude-app]]); this is decision ADR-0003 in [[memory-adrs]] (an ADR, "architecture decision record", is a short note that records one decision and its reasons).

## How it does it
The memory is a log: every entry is one new file that is never edited afterwards, stored in [[events-log]]. One function, [[memory-fold]], reads the whole log and works out the current state (the latest ruling for each topic wins). A GitHub Action ([[mem-action]], an automatic job on GitHub) regenerates the readable files in [[memory-views]]. Claude Code writes with the command [[mem]] and with three hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); the Claude app writes through [[mem-github-connector]]. Everything is written in plain Python (only its standard library), and [[mem-validator]] keeps secrets and other people's contact data out.

## Where it sits in the pipeline
Under every other project: they read their defaults from it and report back with `mem use`.

## Who receives its output
Every Claude instance, through the brief; [[giovanni]], through the review file in [[memory-views]].

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
1. **Events are append-only**: a continuous integration job refuses a change to an old event file.
2. **Views are derived**: a test fails when a view was edited by hand, and the views are rebuilt on every push.
3. **Delivery order never matters**: tests check that folding the log gives the same result in any order.
4. **Giovanni's own words outrank the harvester**: a test checks that an automatic entry never rewrites one of theirs.
5. **No secrets or contact data**: a privacy test checks the boundary, and an invalid event is quarantined.
6. **This repository is the only interface between the Claude instances**: no new protocol.

### Decisions
Five architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`, [[memory-adrs]]: 0002 one append-only event log folded by a pure function, instead of a protocol; 0003 the roles of Giovanni and the Claude instances; 0004 a program measures and a skill judges; 0005 trim the startup brief and split memory by tool. The design, the rules of the fold and the known limits are in `docs/DESIGN.md` (there is no root `DESIGN.md` with a decision log yet).

### Requirements
There is no requirements list. The principles above are pinned by named tests in `tests/` (for example the order-independence, privacy and harvester tests), run by the gate.

### Quality gate
The gate has two steps: the unit tests of the memory (`python3 -m unittest discover`) and the fitness checks of `pipeline-check`.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. Two workflows run on GitHub: `quality-gate.yml` runs the gate, and `mem.yml` checks that events are append-only and that the views are rebuilt ([[mem-action]]). This repository has no branch protection on purpose: its job pushes the derived files to `main`.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` (P1 to P3) under the [[maintenance-policy]]. The [[monthly-architecture-review]] checks the project every month; the next is due 2026-11-22.
