---
id: codex
title: Codex (laptop)
aliases: [Codex]
kind: actor
project: none
status: active
fed_by: [codex-skills, giovanni, global-codex-agents]
feeds: [mem, workflow-memory, wiki-content]
reviewed: 2026-10-27T01:02Z
---

## What it is
Codex is a programming assistant that runs in the terminal (the text window) of the laptop ([[acer-nitro]]), next to [[claude-code]]. It can read files, run commands and edit code inside the permissions Giovanni allows. Giovanni uses it as a second assistant for the same projects, and it follows the same standing preferences.

## Flow
trigger t1: Giovanni starts codex in a terminal | [[giovanni]]
step s1: The launcher wraps the session in tmux; a footer shows task progress and usage | [[codex-pbar]], [[codex-status-line]]
step s2: A start hook prints the memory brief for the instance codex | [[hook-session-start]], [[session-brief]]
step s3: Reads its global instructions and the project's own AGENTS.md | [[global-codex-agents]]
decide d1: Does the task match the description of an installed skill?
step s4: Loads that skill and follows it | [[codex-skills]]
step s5: Works without a skill
step s6: Does the task and keeps the footer's step count honest | [[codex-pbar]]
decide d2: Did it change something in Giovanni's systems?
step s7: Writes the wiki pages in three languages and publishes them | [[wiki-content]]
step s8: Reports which memory entries shaped the work | [[mem-use]]
product p1: Changed code and documents in the projects
product p2: A wiki that matches what was built | [[wiki]]
product p3: Memory usage recorded in the log under the instance codex | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -yes-> s4
d1 -no-> s5
s4 -> s6
s5 -> s6
s6 -> p1
s6 -> d2
d2 -yes-> s7
d2 -no-> s8
s7 -> s8
s7 -> p2
s8 -> p3

## What it does
It builds, tests and documents software in `~/dev` the way [[claude-code]] does. It reads Giovanni's shared memory ([[workflow-memory]]) at the start of each session, records corrections with [[mem]], and updates this wiki at the end of a task ([[end-of-task]]).

## How it does it
Its own instruction file is [[global-codex-agents]]. Its memory hooks run the command `mem --instance codex`, so every memory entry says which assistant wrote it; a preference only Codex needs is stored with the scope `instance:codex`, while global entries are read by both assistants. Its skills are the Codex adaptations in [[codex-skills]], installed by [[codex-skillsctl]]. In the terminal, [[codex-pbar]] draws the task-progress row and [[codex-status-line]] shows the usage allowances and context size.

## Where it sits in the pipeline
Between [[giovanni]] and the project repositories, in parallel with [[claude-code]]. It never talks to other assistants directly: anything shared goes through [[workflow-memory]] or the repositories.

## Who receives its output
The project repositories, the memory log [[events-log]] and the wiki content ([[wiki-content]]).
