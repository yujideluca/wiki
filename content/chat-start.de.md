---
id: chat-start
lang: de
source_hash: 2055347cc02e
title: Was beim Start eines Chats passiert
aliases: [Sitzungsstart]
---

## What it is
Die Abfolge, die einem neuen Claude-Code-Chat sein Gedächtnis gibt, bevor Giovannis erste Nachricht beantwortet wird.

## What it does
Sorgt dafür, dass jede Sitzung mit denselben festen Vorlieben und offenen Punkten beginnt, egal in welchem Projekt.

## How it does it
Claude Code führt die SessionStart-Hooks aus [[claude-code-settings]] aus; der des Gedächtnisses gibt das Briefing aus.

## Where it sits in the pipeline
Vor jeder Arbeit in jedem Projekt.

## Who receives its output
[[claude-code]] (und [[remote-assistant]]).

## Steps
1. Giovanni öffnet Claude Code in einem Ordner (oder der Assistent startet neu) — [[claude-code]].
2. Claude Code liest [[claude-code-settings]] und führt den SessionStart-Hook [[hook-session-start]] aus.
3. Der Hook holt `workflow-memory` von GitHub ([[mem-sync]]).
4. [[memory-fold]] faltet [[events-log]] zum aktuellen Zustand und rankt ihn im Budget.
5. [[mem-pendency]] fügt die offenen Punkte für dieses Projekt mit der Prüfregel hinzu.
6. Das [[session-brief]] landet im Kontext des Modells, zusammen mit [[global-claude-md]] und dem Index des Auto-Gedächtnisses ([[claude-auto-memory]]).
7. Claude antwortet nach diesen Voreinstellungen; am Ende der Aufgabe schließt [[end-of-task]] den Kreis.
