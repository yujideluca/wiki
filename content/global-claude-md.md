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
reviewed: 2026-11-22T22:52Z
---

## What it is
`~/.claude/CLAUDE.md` is Giovanni's private instruction file for every Claude Code session on the laptop. A CLAUDE.md file is plain text that Claude Code reads automatically at the start of a session and treats as standing instructions ([documentation](https://docs.claude.com/en/docs/claude-code/memory)). This one is "global": it applies in every project, while each project also has its own.

## What it does
It names [[workflow-memory]] as the shared memory and explains how to record a correction (`mem add`), how to report which memory entries shaped a task (`mem use`) and how to flag a wrong entry. It forbids editing the `events/` and `views/` folders by hand and storing clinical, secret or contact data about other people. It also makes updating the wiki part of finishing any task ([[end-of-task]]) and says that the wiki is English only: no `.de` or `.pt-BR` files, which `wiki check` refuses. It also says that a page checked and found right gets its `reviewed:` field set to the current UTC time, that `wiki publish -m "review: no page change"` is only for a change that no page describes, and that a Stop hook ([[wiki-hook-stop]]) reminds the session once if code changed after the last publish. Since 2026-11-18 its first lines say that the memory repository is public: open items and notes are encrypted there ([[events-log]]), rules are readable by anyone, so no private detail goes into a rule. It also carries the rule that only a real run is proof: "works", "fixed" or "done" may be said only after the real command was run in the real target environment and its outcome was seen; otherwise the report starts with "NOT proven". It sets the delegation rule ([[task-delegation]]): every step goes to the cheapest level that can do it. A fixed, repeatable step is a script or command with no model. Lookup, search, reading logs or web pages and summarising go to a subagent (a helper session that Claude Code launches for one side task) on the small model Haiku. Work from a clear written specification goes to a subagent on the default model, which the setting `CLAUDE_CODE_SUBAGENT_MODEL` in [[claude-code-settings]] makes Sonnet. Design, root cause, medical facts and anything that needs judgement stay with the main session, or go to a subagent on the model Opus with the reason stated. A subagent gets a brief (goal, files, what done means) and never the whole history; routine work gets no fork (a copy of the session that carries the full context and the main model); the session checks the result itself before reporting it. Since 2026-11-22 it also carries a context rule, because everything a session has read is paid for again at every step: read a briefing first (`mem rules TAG`, see [[mem-rules]], or a project's CLAUDE.md), then only the part the task needs; when a topic is finished, record what is open with `mem task` and tell Giovanni that `/clear` (the command that empties the conversation) is now cheaper. The command `token-thrift report` ([[token-thrift]]) shows where the tokens went (tokens are the text units a model counts). The real-run rule is dated 2026-11-18, applies to every task and project, and ends with a demand on projects: each one with an install or release path needs an automated real run on bare machines that blocks the release when it fails. The file no longer mentions `~/AGENTS.md`, the instruction file written for Codex in the home folder ([[global-codex-agents]] describes the global one): since 2026-11-22 the setting `claudeMdExcludes` in [[claude-code-settings]] keeps Claude Code from loading it.

## How it does it
It is loaded automatically into the context of every session, next to the memory brief ([[session-brief]]). No command is needed.

## Where it sits in the pipeline
Read at the start of each chat ([[chat-start]]).

## Who receives its output
[[claude-code]] and the [[remote-assistant]].
