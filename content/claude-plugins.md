---
id: claude-plugins
title: Claude Code plugins
aliases: [plugins, android-test-pilot]
kind: data
project: laptop-setup
status: active
location: home:.claude/plugins
fed_by: []
feeds: []
sources: [home:.claude/plugins/installed_plugins.json]
reviewed: 2026-11-01T22:25Z
---

## What it is
A plugin is an add-on package for Claude Code that brings extra abilities ([plugins documentation](https://docs.claude.com/en/docs/claude-code/plugins)). This page lists the plugins installed on the laptop and says which are switched on.

## What it does
- pyright-lsp and kotlin-lsp give Claude "code intelligence" for the Python and Kotlin languages (LSP is the Language Server Protocol, a standard way for an editor or assistant to ask a language tool about errors and definitions).
- session-report produces a usage report of past sessions.
- claude-md-management helps keep CLAUDE.md files (instruction files) in good shape.
- security-guidance warns about risky code.
- feature-dev and pr-review-toolkit provide review and planning agents (sub-assistants for a specific job).
- claude-code-setup recommends automations.
- android-test-pilot analyses Android apps and runs tests on the device; it comes from the `panicgit/android-test-pilot` marketplace.

## How it does it
They are installed under `~/.claude/plugins` (the list is in `installed_plugins.json`) and switched on or off in [[claude-code-settings]]. Switched on: pyright-lsp, kotlin-lsp, security-guidance and android-test-pilot. Installed but switched off: session-report, claude-md-management, feature-dev, pr-review-toolkit and claude-code-setup.

## Where it sits in the pipeline
Inside every Claude Code session.

## Who receives its output
[[claude-code]].
