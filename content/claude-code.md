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

## What it does
It builds, tests, documents and releases the software in `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] and this [[wiki]]. It keeps each project's decision notes, its continuous integration (CI, automatic checks on every push) and its list of technical debt (shortcuts that make later changes harder). It records what it learns with [[mem]] and updates the wiki at the end of every task ([[end-of-task]]).

## How it does it
When a chat starts it reads the [[session-brief]] printed by [[hook-session-start]], then follows the global instructions in [[global-claude-md]] and each project's own CLAUDE.md. It works with the tools and permissions in [[claude-code-settings]], and finishes with `wiki publish` and `mem use`.

## Where it sits in the pipeline
Between [[giovanni]] (who asks and approves) and the repositories it changes. It never talks to other Claude instances directly: anything shared goes through [[workflow-memory]] or the repositories.

## Who receives its output
The project repositories, the memory log [[events-log]] and the wiki content ([[wiki-content]]).
