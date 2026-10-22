---
id: end-of-task
title: End of a task (wiki update chain)
aliases: [update chain, wiki publish chain]
kind: process
project: wiki
status: active
fed_by: []
feeds: []
sources: [home:.claude/CLAUDE.md, wiki:server/lib/wiki/cli.ex]
---

## What it is
What Claude does every time it finishes a task, so memory and wiki never fall behind what was built (decided by Giovanni on 2026-10-22: the wiki update is tied to `mem use`).

## What it does
Updates the pages for what changed (new, changed, retired concepts, with their translations), publishes them through the checks, then reports which memory entries shaped the work.

## How it does it
A rule in [[global-claude-md]]; the checks in [[wiki-check]]; the safety net [[wiki-hook-stop]].

## Where it sits in the pipeline
The last step of every coding task in any project.

## Who receives its output
[[wiki-content]], [[github]] and [[events-log]].

## Steps
1. The task's work is done and verified ([[skill-verification-before-completion]]).
2. Claude updates or creates the English pages in `~/dev/wiki/content` for what changed, then the de and pt-BR versions ([[wiki-content]]).
3. Anything that grew past the page threshold gets its own page (promotion rule, [[wiki-check]]).
4. `wiki publish -m "…"` checks locally, builds, commits only content/ and pushes ([[wiki-cli]]).
5. The live site serves the new data at once ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` reports the memory entries used ([[mem-use]]).
7. When the turn ends, [[wiki-hook-stop]] confirms nothing was forgotten and [[hook-stop]] pushes the memory events.
