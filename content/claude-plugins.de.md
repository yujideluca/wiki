---
id: claude-plugins
lang: de
source_hash: 636185c44be4
title: Claude-Code-Plugins
---

## What it is
Die auf dem Laptop aktiven Plugins von Claude Code.

## What it does
pyright-lsp und kotlin-lsp (Code-Intelligenz für Python und Kotlin), session-report (Nutzungsbericht), claude-md-management, security-guidance, feature-dev, pr-review-toolkit (Review-Agenten), claude-code-setup und android-test-pilot (Analyse und Gerätetests von Android-Apps, aus dem Marktplatz `panicgit/android-test-pilot`).

## How it does it
Installiert und gelistet in `~/.claude/plugins`, aktiviert in [[claude-code-settings]].

## Where it sits in the pipeline
In jeder Claude-Code-Sitzung.

## Who receives its output
[[claude-code]].
