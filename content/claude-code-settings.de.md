---
id: claude-code-settings
lang: de
source_hash: 1f64bfdb8efe
title: Claude Code settings.json
---

## What it is
`~/.claude/settings.json`: die Benutzerkonfiguration von Claude Code auf dem Laptop.

## What it does
Registriert die Hooks (SessionStart → [[hook-session-start]], UserPromptSubmit → [[hook-prompt]], Stop → [[hook-stop]] und [[wiki-hook-stop]]), die Statuszeile ([[pbar]]), Umgebung (`ANDROID_HOME`), aktive Plugins ([[claude-plugins]]), Modell und Design.

## How it does it
JSON, von Claude Code beim Start gelesen; die Gedächtnis-Hooks kamen über `mem install-hooks`, der Wiki-Hook über dessen Einrichtung. Nur absichtlich geändert.

## Where it sits in the pipeline
Zu Beginn jeder Claude-Code-Sitzung gelesen ([[chat-start]]).

## Who receives its output
Claude Code selbst.
