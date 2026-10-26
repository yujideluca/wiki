---
id: global-codex-agents
title: Global Codex AGENTS.md
aliases: [Codex instructions, ~/.codex/AGENTS.md]
kind: data
project: laptop-setup
status: active
location: home:.codex/AGENTS.md
fed_by: []
feeds: [codex-pbar]
sources: [home:.codex/AGENTS.md]
memory: [b51cb7]
reviewed: 2026-10-26T18:04Z
---

## What it is
`~/.codex/AGENTS.md` is Giovanni's plain-text instruction file for Codex, the programming assistant. It describes how the assistant works on the laptop, protects existing work and proves its results. It is separate from Claude's global instructions in [[global-claude-md]].

## What it does
The file connects Codex to [[workflow-memory]], the shared record of preferences and unfinished tasks, and the wiki closing process ([[end-of-task]]). Memory provides defaults, never authorization. The opening instructions describe recording corrections, reporting the entries used and keeping private information out of memory; generated memory folders are managed through commands rather than edited by hand.

The `Terminal task progress` section describes the fixed footer in [[codex-pbar]]: the assistant records completed steps and estimates the remaining time. Only completed work advances the counter. Blocked tasks pause the countdown, and automatic documentation follow-ups retain the original task counter. The separate native display [[codex-status-line]] shows usage allowances (remaining account budgets) and context size (the amount of text the model can use at once).

## How it does it
`Working standard` starts by reserving Giovanni's help for administrator access, credentials and crucial development decisions. Its three sub-sections organize the rest of the work:

- `Mistakes you have made (do not repeat)` groups lessons from previous failures. Its evidence rules distinguish an actual result from a setting or isolated test, require the production command and environment, and cover behavior over time, such as reloads and concurrent writes. Its diagnosis rules address recurring blockers at their cause rather than recording the same obstacle again. A genuine access or decision blocker receives a concrete action, a verification command and an open task. Its safety rules protect shared state, other sessions' edits, credential sources declared in the project's documentation and the user's file layout. Its decision rules retain required skill approvals, disclose reduced scope and data changes, prefer a small reversible adjustment when authorized, and require a current check before claiming a tool or file exists. A skill is a saved set of instructions for a particular task; its required approval still applies when no user is present.
- `Reporting` makes results assessable. The result comes first, followed by `Found along the way:` for unexpected findings, then `Verified by:` for relevant checks and their limits. Data tasks account for inputs, outputs and every changed, skipped or retained record. A harmless tool hiccup gets at most a short trailing note.
- `Closing a task and asking questions` keeps every repository on a single branch, `main`, with a branch living only while continuous integration (CI, the automatic checks GitHub runs) tests a commit; it also distinguishes disposable test environments from changes to the real system. Real changes include memory-use reporting, wiki work in an isolated checkout and [[pipeline-check]], the program that runs the project's automated checks. Branch protection, repository rules that prevent updates before required checks pass, is not bypassed. Questions provide context, options and a recommendation, in that order.

## Where it sits in the pipeline
The instructions guide both the work and its report. The opening wiki instructions require English pages and their German and Brazilian Portuguese versions before `wiki publish`. The assistant updates a page’s review time after comparing it with its sources. The Stop hook, a command run automatically when a session ends, reminds the assistant about documentation still needed ([[wiki-hook-stop]]).

A handoff caused by sandbox limits still includes the wiki and memory closing work before the final message. If documentation itself cannot be published, Codex prepares the changes in an isolated checkout and records and reports that limit.

## Who receives its output
Codex reads the file; Giovanni receives the work, evidence and decisions requiring Giovanni’s input. This page explains the source's groups rather than duplicating its numbered rules. The installed file remains the source for the exact instructions.
