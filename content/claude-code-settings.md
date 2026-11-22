---
id: claude-code-settings
title: Claude Code settings.json
aliases: [settings.json, hooks config]
kind: data
project: laptop-setup
status: active
location: home:.claude/settings.json
fed_by: []
feeds: [hook-prompt, hook-session-start, hook-stop, pbar, wiki-hook-stop, repo-sync-hook, token-thrift]
sources: [home:.claude/settings.json, home:.claude/CLAUDE.md]
reviewed: 2026-11-22T14:16Z
---

## What it is
`~/.claude/settings.json` is the user-level settings file of Claude Code on the laptop. It is a [JSON](https://en.wikipedia.org/wiki/JSON) file (JavaScript Object Notation, a plain-text format for structured data) that Claude Code reads when it starts. See the [settings documentation](https://docs.claude.com/en/docs/claude-code/settings).

## What it does
It registers the hooks, which are small programs that Claude Code runs automatically at certain moments ([hooks explained](https://docs.claude.com/en/docs/claude-code/hooks-guide)): at the start of a chat ([[hook-session-start]]), whenever Giovanni sends a message ([[hook-prompt]]) and when Claude finishes a reply ([[hook-stop]], [[wiki-hook-stop]] and [[repo-sync-hook]], started at the same moment). The Status Quo tray ([[status-quo]]) adds its own hook, `status-quo hook claude <event>` (timeout 3 seconds), on nine events: SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, PermissionRequest, SubagentStart, SubagentStop, Stop and SessionEnd. It also sets the status line ([[pbar]], a command run again every second, `refreshInterval: 1`), two environment variables (`ANDROID_HOME`, the folder of the Android build tools, and `MOBILEMCP_DISABLE_TELEMETRY`, set to 1), the enabled plugins ([[claude-plugins]]) with one extra plugin source (the GitHub repository `panicgit/android-test-pilot`), the model (`fable`), the permission mode (`auto`, tuned by the `autoMode` entry described below), the colour theme (`dark`), the switches `switchModelsOnFlag` and `agentPushNotifEnabled` (push notifications), both set to true, and an `autoMode` entry. That entry has two lists: `environment`, a text description of the working environment (no organisation, no cloud provider, which paths hold sensitive data), and `soft_deny`, the actions that stay blocked until confirmed: the built-in defaults (`$defaults`) plus `systemctl stop` (the command that stops a background service), because stopping a service on the laptop is disruptive. What `switchModelsOnFlag` changes was not verified. The file also holds `modelSettings` (one entry for each of three models) and `skipWorkflowUsageWarning`, set to true; what these two change was not verified.

## How it does it
Three entries limit the cost in tokens (a token is the unit in which a language model reads and writes text, about four characters) since 2026-11-22; the reasons are on the page [[task-delegation]]. The environment variable `CLAUDE_CODE_SUBAGENT_MODEL` is `sonnet`: a subagent (a helper session that the main session starts for one job) runs on the middle model Sonnet unless the call names another model; a real run on 2026-11-22 showed a helper on `claude-sonnet-5-5` under a main session on Haiku. `modelSettings` sets `autoCompactWindow` to 150000 for the three models in use (before: 250000 and 300000): when the text a session carries reaches 150,000 tokens, Claude Code replaces the older part with a summary; this was not yet observed in a real session. `claudeMdExcludes` lists `/home/yuji/AGENTS.md`, the instruction file of Codex, which Claude Code otherwise loaded next to its own `~/.claude/CLAUDE.md` in sessions started in the home folder; the same real run confirmed it is no longer loaded. The status line command also passes its input to `token-thrift statusline` ([[token-thrift]]), which adds a second line only as a warning: when the context is 100,000 tokens or more, or when the stored copy of a context of 50,000 tokens or more has expired or expires within five minutes. A tenth SessionStart entry runs `token-thrift hook-session-start`, which shows Giovanni one sentence when he resumes a session whose stored context has expired. Claude Code reads the file at startup. The memory hooks were added by the command `mem install-hooks`, and the wiki hook by its own setup. It also holds one permission rule on purpose (2026-11-18): `Bash(git push origin HEAD:main)` is allowed, so a session that has the green run of the continuous integration (CI) checks of a commit can put that exact commit on `main` (the wiki's branch rule) without being refused; auto mode (`defaultMode`) stays on. The file is changed only on purpose; there is a skill called update-config for this job. The `skillOverrides` entry switches off 13 skills synced from claude.ai (listed as `anthropic-skills:<name>`) that exist as Claude Code skills of the same name, because the model's skill list was printing every one twice; the Claude Code copies stay on. Since 2026-11-18 it also switches off seven Claude Code skills that had never been used in Claude Code since they were installed: `analise-artigo-cientifico`, `browser-automacao-segura`, `click-protocol`, `ligamagic-listas`, `ligamagic-replicar-carrinho-nas-lojas`, `minimize-site-approvals` and `regras-magic`. Their folders stay in `~/.claude/skills`; removing a name from `skillOverrides` switches that skill on again. A copy of the file from before this change is `~/.claude/settings.json.bak-doctor-20261118`.

## Where it sits in the pipeline
Read at the start of every Claude Code session ([[chat-start]]).

## Who receives its output
Claude Code itself.
