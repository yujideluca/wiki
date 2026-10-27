---
id: laptop-setup
title: Laptop setup
aliases: [Acer Nitro setup, machine]
kind: project
project: none
status: active
location: home:.claude
fed_by: []
feeds: []
sources: [home:.claude/settings.json, home:.claude/CLAUDE.md]
reviewed: 2026-10-25T07:34Z
---

## What it is
"Laptop setup" is the collection of everything that is installed and configured on the laptop ([[acer-nitro]]) so that the Claude assistants can do their work. It is not one program but a toolbox: settings for [[claude-code]], the background assistant, helper tools, the Android build tools and the means to reach the laptop from a phone.

## Flow
trigger t1: The assistants need a tool or a setting on the laptop | [[acer-nitro]]
decide d1: Does the step need administrator rights?
step s1: Claude installs it in the user's own folders | [[user-space-tools]]
step s2: The command is handed to Giovanni to run | [[giovanni]]
step s3: The lasting fact is recorded in memory | [[claude-auto-memory]], [[workflow-memory]]
step s4: Claude Code settings and global instructions | [[claude-code-settings]], [[global-claude-md]]
step s5: The always-on assistant and the status bar | [[claude-assistant]], [[pbar]]
step s6: Android build tools and remote access | [[android-toolchain]], [[remote-terminal]]
step s7: machine-bootstrap captures the setup | [[machine-bootstrap]]
product p1: A laptop ready for Claude Code, the remote assistant and every project | [[claude-code]]
product p2: A recorded setup that can be rebuilt after a reinstall

t1 -> d1
d1 -no-> s1
d1 -yes-> s2
s1 -> s3
s2 -> s3
s3 -> s4
s3 -> s5
s3 -> s6
s4 -> p1
s5 -> p1
s6 -> p1
s3 -> s7
s7 -> p2

## What it does
It provides the ground that every project stands on. The parts are: the Claude Code settings and instructions ([[claude-code-settings]], [[global-claude-md]]), the always-on [[claude-assistant]] service, the status bar [[pbar]], the Telegram sender [[tg-send]], the Android build tools ([[android-toolchain]]), the extra tools in `~/.local` ([[user-space-tools]]), the private network [[tailscale]] and the secure remote access setup [[remote-terminal]].

## How it does it
Most installs are "user-space": they are placed in the user's own folders (`~/.local` and `~/dev`) instead of system folders, so they need no administrator rights (no `sudo`, the command that runs something as administrator). The few steps that do need administrator rights are handed to Giovanni to run. Lasting facts about the setup are kept in [[claude-auto-memory]] and in the shared memory [[workflow-memory]].

## Where it sits in the pipeline
Below all other projects: [[quizapp]] is built with its toolchain, the wiki runs as one of its services, and the assistant lives in its service manager (systemd, the Linux program that starts and watches background services).

## Who receives its output
[[claude-code]], the [[remote-assistant]] and every project in `~/dev`.

The Codex companion [[codex-pbar]] adapts this display for Codex sessions.

The terminal uses [[codex-status-line]] for Codex usage allowances and context size. [[machine-bootstrap]] records the laptop setup and can rebuild it after a reinstall.

Codex’s global instruction file [[global-codex-agents]] describes task progress, verification, reporting and the closing steps for real-system changes.
