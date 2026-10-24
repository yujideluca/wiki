---
id: claude-code-settings
lang: de
source_hash: db997487333c
title: Claude Code settings.json
---

## What it is
`~/.claude/settings.json` ist die Einstellungsdatei von Claude Code auf Benutzerebene auf dem Laptop. Es ist eine [JSON](https://en.wikipedia.org/wiki/JSON)-Datei (JavaScript Object Notation, ein Klartextformat für strukturierte Daten), die Claude Code beim Start liest. Siehe die [Dokumentation der Einstellungen](https://docs.claude.com/en/docs/claude-code/settings).

## What it does
Sie registriert die Hooks, das sind kleine Programme, die Claude Code zu bestimmten Zeitpunkten automatisch ausführt ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)): zu Beginn eines Chats ([[hook-session-start]]), wenn Giovanni eine Nachricht sendet ([[hook-prompt]]) und wenn Claude eine Antwort beendet ([[hook-stop]] und [[wiki-hook-stop]]). Außerdem legt sie die Statuszeile ([[pbar]]), eine Umgebungsvariable (`ANDROID_HOME`), die aktivierten Plugins ([[claude-plugins]]), das Modell und das Farbschema fest.

## How it does it
Claude Code liest die Datei beim Start. Die Gedächtnis-Hooks wurden durch den Befehl `mem install-hooks` eingetragen, der Wiki-Hook durch seine eigene Einrichtung. Die Datei wird nur absichtlich geändert; für diese Aufgabe gibt es die Skill update-config.

## Where it sits in the pipeline
Wird zu Beginn jeder Claude-Code-Sitzung gelesen ([[chat-start]]).

## Who receives its output
Claude Code selbst.
