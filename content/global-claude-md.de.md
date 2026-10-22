---
id: global-claude-md
lang: de
source_hash: 66237ee44f5f
title: Globale CLAUDE.md
aliases: [globale Anweisungen]
---

## What it is
`~/.claude/CLAUDE.md`: Giovannis private Anweisungen für jede Claude-Code-Sitzung auf dem Laptop.

## What it does
Verweist auf [[workflow-memory]] als gemeinsames Gedächtnis; sagt, wie man eine Korrektur festhält (`mem add`), meldet, was eine Aufgabe geprägt hat (`mem use`), und einen falschen Eintrag markiert; verbietet, `events/` oder `views/` von Hand zu bearbeiten oder klinische, geheime oder Kontaktdaten anderer zu speichern; und macht die Wiki-Aktualisierung zum Teil des Aufgabenabschlusses ([[end-of-task]]).

## How it does it
Automatisch in den Kontext jeder Sitzung geladen, neben dem Briefing.

## Where it sits in the pipeline
Gelesen bei [[chat-start]].

## Who receives its output
[[claude-code]] und [[remote-assistant]].
