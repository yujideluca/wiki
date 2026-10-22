---
id: claude-ai-settings-pointer
lang: de
source_hash: a60b04d30bf6
title: Verweis in den claude.ai-Einstellungen
---

## What it is
Ein kurzer portugiesischer Text, einmal in claude.ai > Einstellungen > Präferenzen eingefügt; er liegt in `docs/CLAUDE-AI.md`.

## What it does
Sagt jedem Chat der Claude-App, die GitHub-Werkzeuge zu laden, `views/BRIEF.md` zu lesen und zu befolgen; klappt das nicht, mindestens drei Regeln einzuhalten: in der Sprache der Nachricht antworten, einfach erklären, nie klinische, geheime oder Kontaktdaten über andere speichern.

## How it does it
Nur Giovanni kann dieses Feld schreiben, deshalb ist es ein Verweis: Der Inhalt steht im Briefing, das die Action neu erzeugt. Er ersetzte die Zeile, mit der Chats `code/CORE.md` aus dem alten Repository lasen.

## Where it sits in the pipeline
Am Anfang jedes Chats der Claude-App.

## Who receives its output
[[mem-github-connector]].
