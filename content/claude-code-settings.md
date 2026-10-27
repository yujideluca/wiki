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
reviewed: 2026-10-27T00:21Z
---

## What it is
`~/.claude/settings.json` is the user-level settings file of Claude Code on the laptop. It is a [JSON](https://en.wikipedia.org/wiki/JSON) file (JavaScript Object Notation, a plain-text format for structured data) that Claude Code reads when it starts. See the [settings documentation](https://docs.claude.com/en/docs/claude-code/settings).

## What it does
It registers the hooks, which are small programs that Claude Code runs automatically at certain moments ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)): at the start of a chat ([[hook-session-start]]), whenever Giovanni sends a message ([[hook-prompt]]) and when Claude finishes a reply ([[hook-stop]] and [[wiki-hook-stop]]). It also sets the status line ([[pbar]]), two environment variables (`ANDROID_HOME` and `MOBILEMCP_DISABLE_TELEMETRY`, set to 1), the enabled plugins ([[claude-plugins]]) with one extra plugin source (the GitHub repository `panicgit/android-test-pilot`), the model (`sonnet`), the colour theme (`dark`), the switch `agentPushNotifEnabled` for push notifications and an `autoMode` entry that describes the working environment in text.

## How it does it
Claude Code reads the file at startup. The memory hooks were added by the command `mem install-hooks`, and the wiki hook by its own setup. The file is changed only on purpose; there is a skill called update-config for this job. The `skillOverrides` entry switches off 13 skills synced from claude.ai (listed as `anthropic-skills:<name>`) that exist as Claude Code skills of the same name, because the model's skill list was printing every one twice; the Claude Code copies stay on.

## Where it sits in the pipeline
Read at the start of every Claude Code session ([[chat-start]]).

## Who receives its output
Claude Code itself.
