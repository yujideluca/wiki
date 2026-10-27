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
reviewed: 2026-10-26T18:38Z
---

## What it is
This page describes what Claude does every time it finishes a task, so that the memory and this wiki never fall behind what has actually been built. Giovanni decided on 2026-10-22 that the wiki update is tied to the `mem use` report.

## Flow
trigger t1: Claude finishes a coding task | [[claude-code]]
trigger t2: Claude tries to stop after code changes without publishing | [[wiki-hook-stop]]
step s1: Proves the work by running checks | [[skill-verification-before-completion]]
step s2: Writes or updates the English pages, then the German and Portuguese ones | [[wiki-content]]
step s3: Gives its own page to anything that outgrew its place | [[wiki-check]]
decide d1: Does the content check pass?
step s3b: Fixes what the check reports
step s4: Runs wiki publish: checks, builds the site, commits content/, uploads | [[wiki-cli]]
step s5: The live site serves the new pages at once | [[wiki-site]]
step s6: Reports which memory entries shaped the work | [[mem-use]]
product p1: A wiki that matches what was built | [[wiki]]
product p2: The pages stored on GitHub | [[github]]
product p3: Memory usage recorded in the log | [[events-log]]

t1 -> s1
s1 -> s2
t2 -> s2
s2 -> s3
s3 -> d1
d1 -yes-> s4
d1 -no-> s3b
s3b -> s4
s4 -> s5
s4 -> p2
s5 -> p1
s5 -> s6
s6 -> p3

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
4. `wiki publish -m "…"` checks the content, builds the site, commits only the `content/` folder and uploads it ([[wiki-cli]]). The session adds `--co-author "Name <email>"` with its own attribution line, or leaves it out.
5. The live site serves the new data at once ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` reports the memory entries that were used ([[mem-use]]).
7. When the turn ends, [[wiki-hook-stop]] confirms nothing was forgotten and [[hook-stop]] uploads the memory events.
