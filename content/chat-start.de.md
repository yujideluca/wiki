---
id: chat-start
lang: de
source_hash: 6bef9dd2e160
title: Was beim Start eines Chats passiert
---

## What it is
Diese Seite beschreibt die Abfolge, die einem neuen [[claude-code]]-Chat sein Gedächtnis gibt, bevor Giovannis erste Nachricht beantwortet wird. Ohne sie würde jeder Chat bei null beginnen.

## Flow
trigger t1: Giovanni öffnet Claude Code in einem Ordner, oder der Assistent startet neu | [[claude-code]], [[remote-assistant]]
step s1: Liest seine Einstellungen und führt den SessionStart-Hook aus | [[claude-code-settings]], [[hook-session-start]]
step s2: Lädt das neueste workflow-memory von GitHub herunter | [[mem-sync]]
decide d1: Hat der Download geklappt?
step s2b: Behält die lokale Kopie und warnt, dass das Gedächtnis veraltet sein kann
step s3: Faltet die gespeicherten Ereignisse zum aktuellen Stand, sortiert nach Platzbudget | [[memory-fold]]
step s4: Fügt die offenen Punkte dieses Projekts hinzu, vor Erwähnung zu prüfen | [[mem-pendency]]
step s5: Gibt die Zusammenfassung in den Kontext des Modells aus | [[session-brief]]
step s6: Fügt die globalen Anweisungen und Claudes eigenen Gedächtnisindex hinzu | [[global-claude-md]], [[claude-auto-memory]]
product p1: Ein Chat, der mit Giovannis Grundvorlieben und offenen Punkten beginnt

t1 -> s1
s1 -> s2
s2 -> d1
d1 -ja-> s3
d1 -nein-> s2b
s2b -> s3
s3 -> s4
s4 -> s5
s5 -> s6
s6 -> p1

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
