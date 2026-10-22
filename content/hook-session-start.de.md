---
id: hook-session-start
lang: de
source_hash: e610c985eb91
title: SessionStart-Hook (mem hook-session-start)
---

## What it is
Der Claude-Code-Hook, der beim Chatstart läuft: `python3 ~/dev/workflow-memory/bin/mem hook-session-start` (Zeitlimit 40 s).

## What it does
Holt das Gedächtnis-Repo, faltet die Ereignisse und gibt das [[session-brief]] für das aktuelle Projekt (den Ordnernamen des Chats) aus.

## How it does it
Darf nie laut scheitern: Seine Ausgabe landet im Kontext des Modells, Fehler gehen daher nach `~/.local/state/mem/hook.log`. Offline nimmt es den zuletzt geholten Stand.

## Where it sits in the pipeline
Erster Schritt von [[chat-start]].

## Who receives its output
[[session-brief]] → die Claude-Code-Sitzung.
