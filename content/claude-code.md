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
Claude Code is Anthropic's AI assistant for programming, running in the terminal (the text window) of the laptop ([[acer-nitro]]). It can read files, run commands and edit code, always inside the permissions Giovanni allows. In the division of roles recorded in ADR-0003 (an ADR, "architecture decision record", is a short note that records one decision and its reasons), Claude Code is the developer. See the [official documentation](https://docs.claude.com/en/docs/claude-code/overview).

## Flow
trigger t1: Giovanni types a request in the terminal | [[giovanni]]
step s1: The chat starts: a hook prints the memory brief | [[hook-session-start]], [[session-brief]]
step s2: Reads the global rules and the project's own CLAUDE.md | [[global-claude-md]]
step s3: Does the task with its tools, inside the permissions it was given | [[claude-code-settings]]
decide d1: Did it change something in Giovanni's systems?
step s4: Writes the wiki pages in three languages and publishes them | [[wiki-content]]
step s5: Reports which memory entries shaped the work | [[mem]]
product p1: Changed code and documents in the projects | [[quizapp]], [[workflow-memory]]
product p2: The wiki, up to date | [[wiki]]
product p3: The memory log with new lessons and usage | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> p1
s3 -> d1
d1 -yes-> s4
d1 -no-> s5
s4 -> s5
s4 -> p2
s5 -> p3

## What it does
It builds, tests, documents and releases the software in `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] and this [[wiki]]. It keeps each project's decision notes, its continuous integration (CI, automatic checks on every push) and its list of technical debt (shortcuts that make later changes harder). It records what it learns with [[mem]] and updates the wiki at the end of every task ([[end-of-task]]).

## How it does it
When a chat starts it reads the [[session-brief]] printed by [[hook-session-start]], then follows the global instructions in [[global-claude-md]] and each project's own CLAUDE.md. It works with the tools and permissions in [[claude-code-settings]], and finishes with `wiki publish` and `mem use`.

## Where it sits in the pipeline
Between [[giovanni]] (who asks and approves) and the repositories it changes. It never talks to other Claude instances directly: anything shared goes through [[workflow-memory]] or the repositories.

## Who receives its output
The project repositories, the memory log [[events-log]] and the wiki content ([[wiki-content]]).
