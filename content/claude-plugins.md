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
---

## What it is
The Claude Code plugins enabled on the laptop.

## What it does
pyright-lsp and kotlin-lsp (code intelligence for Python and Kotlin), session-report (usage report), claude-md-management, security-guidance, feature-dev, pr-review-toolkit (review agents), claude-code-setup, and android-test-pilot (Android app analysis and device tests, from the `panicgit/android-test-pilot` marketplace).

## How it does it
Installed and listed in `~/.claude/plugins`, enabled in [[claude-code-settings]].

## Where it sits in the pipeline
Inside every Claude Code session.

## Who receives its output
[[claude-code]].
