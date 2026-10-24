---
id: claude-code
lang: de
source_hash: b4eed29baa1a
title: Claude Code (Laptop)
---

## What it is
Claude Code ist Anthropics KI-Assistent zum Programmieren und läuft im Terminal (dem Textfenster) des Laptops ([[acer-nitro]]). Er kann Dateien lesen, Befehle ausführen und Code ändern, immer innerhalb der Berechtigungen, die Giovanni erlaubt. In der Rollenverteilung aus ADR-0003 (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine Entscheidung und ihre Gründe festhält) ist Claude Code der Entwickler. Siehe die [offizielle Dokumentation](https://docs.claude.com/en/docs/claude-code/overview).

## What it does
Er baut, testet, dokumentiert und veröffentlicht die Software in `~/dev`: [[quizapp]], [[quizweb]], [[workflow-memory]] und dieses [[wiki]]. Er pflegt für jedes Projekt die Entscheidungsnotizen, die Continuous Integration (CI, automatische Prüfungen bei jedem Push) und die Liste der technischen Schulden (Abkürzungen, die spätere Änderungen erschweren). Er hält mit [[mem]] fest, was er lernt, und aktualisiert am Ende jeder Aufgabe das Wiki ([[end-of-task]]).

## How it does it
Beim Start eines Chats liest er den [[session-brief]], den [[hook-session-start]] ausgibt, und befolgt dann die globalen Anweisungen in [[global-claude-md]] und die CLAUDE.md des jeweiligen Projekts. Er arbeitet mit den Werkzeugen und Berechtigungen aus [[claude-code-settings]] und schließt mit `wiki publish` und `mem use` ab.

## Where it sits in the pipeline
Zwischen [[giovanni]] (der fragt und genehmigt) und den Repositories, die er ändert. Er spricht nie direkt mit anderen Claude-Instanzen: Alles Gemeinsame läuft über [[workflow-memory]] oder die Repositories.

## Who receives its output
Die Projekt-Repositories, das Gedächtnisprotokoll [[events-log]] und die Wiki-Inhalte ([[wiki-content]]).
