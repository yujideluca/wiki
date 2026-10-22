---
id: claude-code
lang: de
source_hash: 92ea6bcda322
title: Claude Code (Laptop)
aliases: [Entwickler]
---

## What it is
Claude im Terminal des Laptops ([[acer-nitro]]). In den Rollen von ADR-0003 ist es der Entwickler.

## What it does
Baut, testet, dokumentiert und veröffentlicht die Software in `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]], dieses [[wiki]]. Pflegt ADRs, CI und Schuldenliste jedes Projekts, hält Gelerntes mit [[mem]] fest und aktualisiert das Wiki am Ende jeder Aufgabe ([[end-of-task]]).

## How it does it
Liest beim Chatstart das von [[hook-session-start]] ausgegebene [[session-brief]], folgt der globalen [[global-claude-md]] und der CLAUDE.md jedes Projekts, arbeitet mit den Werkzeugen aus [[claude-code-settings]] und schließt mit `wiki publish` und `mem use` ab.

## Where it sits in the pipeline
Zwischen [[giovanni]] (fragt und genehmigt) und den Repositorys, die es ändert. Es spricht nie direkt mit anderen Claude-Instanzen: Gemeinsames läuft über [[workflow-memory]] oder die Repos.

## Who receives its output
Die Projekt-Repositorys, [[events-log]] (Gedächtnis-Ereignisse) und [[wiki-content]].
