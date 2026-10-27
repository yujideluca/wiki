---
id: deutsch-gespraech
lang: de
source_hash: 8fb37893e5cf
title: Projekt Deutsch-Gespräch (Claude-App)
---

## What it is
Deutsch-Gespräch ist ein Projekt in der [[claude-app]], um gesprochenes Deutsch zu üben. Da die App zwischen Chats kein Gedächtnis hat, bewahrt dieses Projekt sein Gedächtnis in einem Google Doc namens `deutsch-gespraech-state` auf.

## Flow
trigger t1: Giovanni öffnet einen Chat im Projekt Deutsch-Gespräch | [[claude-app]]
step s1: Der Skill lädt deutsch-gespraech-state aus Google Docs | [[skill-deutsch-gespraech-memory]]
step s2: Sie sprechen Deutsch; Korrekturen folgen dem Prüfungstraining-Skill | [[skill-alemao-goethe-fsp]]
decide d1: Was tippt Giovanni?
step s3: Speichert die Sitzung zurück in das Doc
step s4: Zeigt die gespeicherten Einträge
step s5: Löscht den genannten Eintrag
product p1: Ein aktualisierter Stand im Google Doc für das nächste Gespräch
product p2: Die Liste der gespeicherten Einträge auf dem Bildschirm

t1 -> s1
s1 -> s2
s2 -> d1
d1 -Ende-> s3
d1 -Gedächtnis?-> s4
d1 -Vergiss …-> s5
s3 -> p1
s5 -> p1
s4 -> p2

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
