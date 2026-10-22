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
---

## What it is
Everything installed and configured on the laptop ([[acer-nitro]]) so the Claude instances can work: Claude Code's settings and hooks, the always-on assistant, user-space tools, the Android toolchain and remote access.

## What it does
Provides the ground every project runs on: [[claude-code-settings]] and [[global-claude-md]], the [[claude-assistant]] service, the status line [[pbar]], the Telegram sender [[tg-send]], the Android build tools ([[android-toolchain]]), the extra tools in `~/.local` ([[user-space-tools]]), [[tailscale]] and the SSH setup ([[remote-terminal]]).

## How it does it
Most installs are user-space (no sudo) under `~/.local` and `~/dev`; the steps that need sudo are handed to Giovanni. Lasting facts about the setup are kept in [[claude-auto-memory]] and [[workflow-memory]].

## Where it sits in the pipeline
Below all projects: QuizApp builds with its toolchain, the wiki runs as its service, the assistant lives in its systemd.

## Who receives its output
[[claude-code]], [[remote-assistant]] and every project in `~/dev`.
