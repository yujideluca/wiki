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
reviewed: 2026-11-06T22:03Z
---

## What it is
`~/.claude/settings.json` is the user-level settings file of Claude Code on the laptop. It is a [JSON](https://en.wikipedia.org/wiki/JSON) file (JavaScript Object Notation, a plain-text format for structured data) that Claude Code reads when it starts. See the [settings documentation](https://docs.claude.com/en/docs/claude-code/settings).

## What it does
It registers the hooks, which are small programs that Claude Code runs automatically at certain moments ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)): at the start of a chat ([[hook-session-start]]), whenever Giovanni sends a message ([[hook-prompt]]) and when Claude finishes a reply ([[hook-stop]] and [[wiki-hook-stop]]). The Status Quo tray ([[status-quo]]) adds its own hook, `status-quo hook claude <event>` (timeout 3 seconds), on nine events: SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, PermissionRequest, SubagentStart, SubagentStop, Stop and SessionEnd. It also sets the status line ([[pbar]], a command run again every second, `refreshInterval: 1`), two environment variables (`ANDROID_HOME`, the folder of the Android build tools, and `MOBILEMCP_DISABLE_TELEMETRY`, set to 1), the enabled plugins ([[claude-plugins]]) with one extra plugin source (the GitHub repository `panicgit/android-test-pilot`), the model (`opus`), the permission mode (`auto`, tuned by the `autoMode` entry described below), the colour theme (`dark`), the switches `switchModelsOnFlag` and `agentPushNotifEnabled` (push notifications), both set to true, and an `autoMode` entry. That entry has two lists: `environment`, a text description of the working environment (no organisation, no cloud provider, which paths hold sensitive data), and `soft_deny`, the actions that stay blocked until confirmed: the built-in defaults (`$defaults`) plus `systemctl stop` (the command that stops a background service), because stopping a service on the laptop is disruptive. What `switchModelsOnFlag` changes was not verified.

## How it does it
Claude Code reads the file at startup. The memory hooks were added by the command `mem install-hooks`, and the wiki hook by its own setup. The file is changed only on purpose; there is a skill called update-config for this job. The `skillOverrides` entry switches off 13 skills synced from claude.ai (listed as `anthropic-skills:<name>`) that exist as Claude Code skills of the same name, because the model's skill list was printing every one twice; the Claude Code copies stay on.

## Where it sits in the pipeline
Read at the start of every Claude Code session ([[chat-start]]).

## Who receives its output
Claude Code itself.
