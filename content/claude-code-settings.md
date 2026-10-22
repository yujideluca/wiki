---
id: claude-code-settings
title: Claude Code settings.json
aliases: [settings.json, hooks config]
kind: data
project: laptop-setup
status: active
location: home:.claude/settings.json
fed_by: []
feeds: [hook-prompt, hook-session-start, hook-stop, pbar, wiki-hook-stop]
sources: [home:.claude/settings.json]
---

## What it is
`~/.claude/settings.json`: the user-level configuration of Claude Code on the laptop.

## What it does
Registers the hooks (SessionStart → [[hook-session-start]], UserPromptSubmit → [[hook-prompt]], Stop → [[hook-stop]] and [[wiki-hook-stop]]), the status line ([[pbar]]), environment (`ANDROID_HOME`), enabled plugins ([[claude-plugins]]), model and theme.

## How it does it
JSON read by Claude Code at start; the memory hooks were added by `mem install-hooks`, the wiki hook by its setup. Changed only on purpose (the update-config skill exists for this).

## Where it sits in the pipeline
Read at the start of every Claude Code session ([[chat-start]]).

## Who receives its output
Claude Code itself.
