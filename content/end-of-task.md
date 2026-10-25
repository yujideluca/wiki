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
reviewed: 2026-10-25T02:06Z
---

## What it is
This page describes what Claude does every time it finishes a task, so that the memory and this wiki never fall behind what has actually been built. Giovanni decided on 2026-10-22 that the wiki update is tied to the `mem use` report.

## What it does
Claude updates the wiki pages for whatever changed (new, changed or retired things, each with its German and Portuguese translation), publishes them through the content checks, and then reports which memory entries shaped the work.

## How it does it
The rule is written in [[global-claude-md]]; the checks that guard publishing are in [[wiki-check]]; and a safety net, [[wiki-hook-stop]], reminds Claude if it forgot.

## Where it sits in the pipeline
It is the last step of every coding task, in any project.

## Who receives its output
The wiki content ([[wiki-content]]), [[github]] (where the wiki is stored) and the memory log [[events-log]].

## Steps
1. The task's work is done and proven by running checks ([[skill-verification-before-completion]]).
2. Claude updates or creates the English pages in `~/dev/wiki/content` for what changed, then the German and Brazilian Portuguese versions ([[wiki-content]]). A page that was compared with its sources and found right gets its `reviewed` time set to the current UTC time, which is what clears it in [[wiki-stale]].
3. Anything that has grown past the page threshold gets its own page (the promotion rule, enforced by [[wiki-check]]).
4. `wiki publish -m "…"` checks the content, builds the site, commits only the `content/` folder and uploads it ([[wiki-cli]]).
5. The live site serves the new data at once ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` reports the memory entries that were used ([[mem-use]]).
7. When the turn ends, [[wiki-hook-stop]] confirms nothing was forgotten and [[hook-stop]] uploads the memory events.
