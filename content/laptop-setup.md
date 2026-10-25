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
reviewed: 2026-10-25T02:07Z
---

## What it is
"Laptop setup" is the collection of everything that is installed and configured on the laptop ([[acer-nitro]]) so that the Claude assistants can do their work. It is not one program but a toolbox: settings for [[claude-code]], the background assistant, helper tools, the Android build tools and the means to reach the laptop from a phone.

## What it does
It provides the ground that every project stands on. The parts are: the Claude Code settings and instructions ([[claude-code-settings]], [[global-claude-md]]), the always-on [[claude-assistant]] service, the status bar [[pbar]], the Telegram sender [[tg-send]], the Android build tools ([[android-toolchain]]), the extra tools in `~/.local` ([[user-space-tools]]), the private network [[tailscale]] and the secure remote access setup [[remote-terminal]].

## How it does it
Most installs are "user-space": they are placed in the user's own folders (`~/.local` and `~/dev`) instead of system folders, so they need no administrator rights (no `sudo`, the command that runs something as administrator). The few steps that do need administrator rights are handed to Giovanni to run. Lasting facts about the setup are kept in [[claude-auto-memory]] and in the shared memory [[workflow-memory]].

## Where it sits in the pipeline
Below all other projects: [[quizapp]] is built with its toolchain, the wiki runs as one of its services, and the assistant lives in its service manager (systemd, the Linux program that starts and watches background services).

## Who receives its output
[[claude-code]], the [[remote-assistant]] and every project in `~/dev`.
