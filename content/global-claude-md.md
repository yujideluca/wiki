---
id: global-claude-md
title: Global CLAUDE.md
aliases: [~/.claude/CLAUDE.md, global instructions]
kind: data
project: laptop-setup
status: active
location: home:.claude/CLAUDE.md
fed_by: []
feeds: [claude-code, remote-assistant]
sources: [home:.claude/CLAUDE.md]
reviewed: 2026-11-19T01:52Z
---

## What it is
`~/.claude/CLAUDE.md` is Giovanni's private instruction file for every Claude Code session on the laptop. A CLAUDE.md file is plain text that Claude Code reads automatically at the start of a session and treats as standing instructions ([documentation](https://docs.claude.com/en/docs/claude-code/memory)). This one is "global": it applies in every project, while each project also has its own.

## What it does
It names [[workflow-memory]] as the shared memory and explains how to record a correction (`mem add`), how to report which memory entries shaped a task (`mem use`) and how to flag a wrong entry. It forbids editing the `events/` and `views/` folders by hand and storing clinical, secret or contact data about other people. It also makes updating the wiki part of finishing any task ([[end-of-task]]) and says that the wiki is English only: no `.de` or `.pt-BR` files, which `wiki check` refuses. It also says that a page checked and found right gets its `reviewed:` field set to the current UTC time, that `wiki publish -m "review: no page change"` is only for a change that no page describes, and that a Stop hook ([[wiki-hook-stop]]) reminds the session once if code changed after the last publish. Since 2026-11-18 its first lines say that the memory repository is public: open items and notes are encrypted there ([[events-log]]), rules are readable by anyone, so no private detail goes into a rule. It also carries the rule that only a real run is proof: "works", "fixed" or "done" may be said only after the real command was run in the real target environment and its outcome was seen; otherwise the report starts with "NOT proven". It tells a session that starts a general-purpose subagent (a helper session that Claude Code launches for one side task) for lookup, search or summarising work to give it a cheaper model, and to keep the default model only for hard reasoning. Since 2026-11-18 it also says that `~/AGENTS.md`, the instruction file of Codex ([[global-codex-agents]]), is loaded by Claude Code too when a session starts in the home folder, and that its parts meant only for Codex (`mem --instance codex`, `codex-task-progress`) are to be ignored.

## How it does it
It is loaded automatically into the context of every session, next to the memory brief ([[session-brief]]). No command is needed.

## Where it sits in the pipeline
Read at the start of each chat ([[chat-start]]).

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
