---
id: deutsch-gespraech
lang: de
source_hash: f03f3a15619d
title: Projekt Deutsch-Gespräch (Claude-App)
---

## What it is
Deutsch-Gespräch ist ein Projekt in der [[claude-app]], um gesprochenes Deutsch zu üben. Da die App zwischen Chats kein Gedächtnis hat, bewahrt dieses Projekt sein Gedächtnis in einem Google Doc namens `deutsch-gespraech-state` auf.

## What it does
Bei der ersten Nachricht jedes Chats in diesem Projekt wird der Stand aus dem Doc geladen. Schreibt Giovanni „Ende“, wird die Sitzung dort gespeichert. „Gedächtnis?“ zeigt, was gespeichert ist, und „Vergiss …“ löscht einen Eintrag.

## How it does it
Das erledigt die Skill deutsch-gespraech-memory in der App ([[claude-ai-skills]]). Diese Skill zeigt zu Beginn von Chats einen Hinweis, der nicht für [[claude-code]] gedacht ist; Claude Code ignoriert ihn.

## Where it sits in the pipeline
Nur in der [[claude-app]], neben [[skill-alemao-goethe-fsp]].

## Who receives its output
Das Google Doc und Giovanni im nächsten Gespräch.

## Steps
1. Giovanni öffnet einen Chat im Projekt Deutsch-Gespräch der [[claude-app]].
2. Die Skill lädt `deutsch-gespraech-state` aus Google Docs.
3. Sie sprechen Deutsch; Korrekturen folgen [[skill-alemao-goethe-fsp]].
4. „Ende“ speichert die Sitzung zurück ins Doc.
5. „Gedächtnis?“ zeigt die gespeicherten Einträge, „Vergiss …“ löscht einen.
