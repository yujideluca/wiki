---
id: global-claude-md
lang: de
source_hash: dcfe9682ac70
title: Globale CLAUDE.md
---

## What it is
`~/.claude/CLAUDE.md` ist Giovannis private Anweisungsdatei für jede Claude-Code-Sitzung auf dem Laptop. Eine CLAUDE.md-Datei ist Klartext, den Claude Code zu Beginn einer Sitzung automatisch liest und als dauerhafte Anweisungen behandelt ([Dokumentation](https://docs.claude.com/en/docs/claude-code/memory)). Diese hier ist „global“: Sie gilt in jedem Projekt, während jedes Projekt zusätzlich eine eigene hat.

## What it does
Sie nennt [[workflow-memory]] als gemeinsames Gedächtnis und erklärt, wie man eine Korrektur festhält (`mem add`), wie man meldet, welche Gedächtniseinträge eine Aufgabe geprägt haben (`mem use`), und wie man einen falschen Eintrag markiert. Sie verbietet, die Ordner `events/` und `views/` von Hand zu ändern und klinische, geheime oder Kontaktdaten über andere Personen zu speichern. Außerdem macht sie die Aktualisierung des Wikis zum Teil jeder abgeschlossenen Aufgabe ([[end-of-task]]).

## How it does it
Sie wird automatisch in den Kontext jeder Sitzung geladen, neben dem Gedächtnis-Brief ([[session-brief]]). Ein Befehl ist nicht nötig.

## Where it sits in the pipeline
Wird zu Beginn jedes Chats gelesen ([[chat-start]]).

## Who receives its output
[[claude-code]] und der [[remote-assistant]].
