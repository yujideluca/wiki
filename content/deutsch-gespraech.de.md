---
id: deutsch-gespraech
lang: de
source_hash: d61da8c22e56
title: Projekt Deutsch-Gespräch (Claude-App)
aliases: [Deutsch-Gespräch]
---

## What it is
Ein Projekt in der Claude-App zum Üben deutscher Gespräche, dessen Gedächtnis ein Google-Dokument ist: `deutsch-gespraech-state`.

## What it does
Bei der ersten Nachricht jedes Chats in diesem Projekt lädt es den Gesprächsstand aus dem Dokument; bei „Ende“ speichert es die Sitzung dort; bei „Gedächtnis?“ oder „Vergiss …“ zeigt oder löscht es gespeicherte Punkte.

## How it does it
Der Skill deutsch-gespraech-memory in der App ([[claude-ai-skills]]). Sein Hinweis beim Sitzungsstart gilt nicht für Claude Code, das ihn ignoriert.

## Where it sits in the pipeline
Nur in der [[claude-app]], neben [[skill-alemao-goethe-fsp]].

## Who receives its output
Das Google-Dokument und Giovanni im nächsten Gespräch.

## Steps
1. Giovanni öffnet einen Chat im Projekt Deutsch-Gespräch der [[claude-app]].
2. Der Skill lädt `deutsch-gespraech-state` aus Google Docs.
3. Es wird Deutsch gesprochen; Korrekturen folgen [[skill-alemao-goethe-fsp]].
4. „Ende“ speichert die Sitzung zurück ins Dokument.
5. „Gedächtnis?“ zeigt gespeicherte Punkte, „Vergiss …“ löscht einen.
