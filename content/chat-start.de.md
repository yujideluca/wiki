---
id: chat-start
lang: de
source_hash: 13cb6baff016
title: Was beim Start eines Chats passiert
---

## What it is
Diese Seite beschreibt die Abfolge, die einem neuen [[claude-code]]-Chat sein Gedächtnis gibt, bevor Giovannis erste Nachricht beantwortet wird. Ohne sie würde jeder Chat bei null beginnen.

## What it does
Sie sorgt dafür, dass jede Sitzung mit denselben dauerhaften Vorlieben und derselben Liste unerledigter Punkte beginnt, egal in welchem Projekt der Chat geöffnet wird.

## How it does it
Claude Code führt die „Session-Start“-Hooks aus, die in [[claude-code-settings]] eingestellt sind (ein Hook ist ein kleines Programm, das bei einem Ereignis automatisch läuft). Der Hook des Gedächtnisses gibt eine Zusammenfassung aus, den Brief; was in diesem Moment ausgegeben wird, wird Teil dessen, was das Modell zuerst liest.

## Where it sits in the pipeline
Vor jeder Arbeit in jedem Projekt.

## Who receives its output
[[claude-code]] (und der [[remote-assistant]], der genauso startet).

## Steps
1. Giovanni öffnet Claude Code in einem Ordner (oder der Assistent startet neu) — [[claude-code]].
2. Claude Code liest [[claude-code-settings]] und führt den SessionStart-Hook [[hook-session-start]] aus.
3. Der Hook lädt das neueste `workflow-memory` von GitHub herunter ([[mem-sync]]).
4. [[memory-fold]] fasst die gespeicherten Ereignisse zum aktuellen Stand zusammen und ordnet sie so, dass sie in ein Größenbudget passen.
5. [[mem-pendency]] ergänzt die offenen Punkte dieses Projekts, mit der Regel, sie vor der Erwähnung zu prüfen.
6. Der [[session-brief]] wird in den Kontext des Modells ausgegeben, zusammen mit den Anweisungen aus [[global-claude-md]] und dem Index des kleinen eigenen Gedächtnisses von Claude Code ([[claude-auto-memory]]).
7. Claude antwortet nach diesen Vorgaben; wenn die Aufgabe endet, schließt [[end-of-task]] den Kreis.
