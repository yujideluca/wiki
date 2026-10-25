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
reviewed: 2026-10-25T02:07Z
---

## What it is
A plugin is an add-on package for Claude Code that brings extra abilities ([plugins documentation](https://docs.claude.com/en/docs/claude-code/plugins)). This page lists the plugins enabled on the laptop.

## What it does
- pyright-lsp and kotlin-lsp give Claude "code intelligence" for the Python and Kotlin languages (LSP is the Language Server Protocol, a standard way for an editor or assistant to ask a language tool about errors and definitions).
- session-report produces a usage report of past sessions.
- claude-md-management helps keep CLAUDE.md files (instruction files) in good shape.
- security-guidance warns about risky code.
- feature-dev and pr-review-toolkit provide review and planning agents (sub-assistants for a specific job).
- claude-code-setup recommends automations.
- android-test-pilot analyses Android apps and runs tests on the device; it comes from the `panicgit/android-test-pilot` marketplace.

## How it does it
They are installed under `~/.claude/plugins` (the list is in `installed_plugins.json`) and switched on in [[claude-code-settings]].

## Where it sits in the pipeline
Inside every Claude Code session.

## Who receives its output
[[claude-code]].
