---
id: claude-code
title: Claude Code (laptop)
aliases: [developer, Claude Code]
kind: actor
project: none
status: active
fed_by: [claude-auto-memory, giovanni, global-claude-md, session-brief, wiki-hook-stop]
feeds: [mem, quizapp, quizweb, wiki, wiki-content, workflow-memory]
reviewed: 2026-10-22
---

## What it is
Claude running in the terminal of the laptop ([[acer-nitro]]). In the roles of ADR-0003 it is the developer.

## What it does
Builds, tests, documents and releases the software in `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]], this [[wiki]]. Keeps each project's ADRs, CI and debt list, records what it learns with [[mem]], and updates the wiki at the end of every task ([[end-of-task]]).

## How it does it
Reads the [[session-brief]] printed by [[hook-session-start]] when a chat starts, follows the global [[global-claude-md]] and each project's CLAUDE.md, works with the tools of [[claude-code-settings]], and finishes with `wiki publish` and `mem use`.

## Where it sits in the pipeline
Between [[giovanni]] (who asks and approves) and the repositories it changes. It never talks to other Claude instances directly: anything shared goes through [[workflow-memory]] or the repos.

## Who receives its output
The project repositories, [[events-log]] (memory events) and [[wiki-content]].
