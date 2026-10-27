---
id: codex
lang: de
source_hash: 1b73cde614c6
title: Codex (Laptop)
---

## What it is
Codex ist ein Programmierassistent, der im Terminal (dem Textfenster) des Laptops ([[acer-nitro]]) läuft, neben [[claude-code]]. Er kann Dateien lesen, Befehle ausführen und Code ändern, innerhalb der Berechtigungen, die Giovanni erlaubt. Giovanni nutzt ihn als zweiten Assistenten für dieselben Projekte, und er folgt denselben Grundvorlieben.

## Flow
trigger t1: Giovanni startet codex in einem Terminal | [[giovanni]]
step s1: Der Starter hüllt die Sitzung in tmux ein; eine Fußzeile zeigt Aufgabenfortschritt und Nutzung | [[codex-pbar]], [[codex-status-line]]
step s2: Ein Start-Hook gibt die Gedächtnis-Zusammenfassung für die Instanz codex aus | [[hook-session-start]], [[session-brief]]
step s3: Liest seine globalen Anweisungen und die AGENTS.md des Projekts | [[global-codex-agents]]
decide d1: Passt die Aufgabe zur Beschreibung eines installierten Skills?
step s4: Lädt diesen Skill und folgt ihm | [[codex-skills]]
step s5: Arbeitet ohne Skill
step s6: Erledigt die Aufgabe und hält den Schrittzähler der Fußzeile ehrlich | [[codex-pbar]]
decide d2: Hat sich etwas in Giovannis Systemen geändert?
step s7: Schreibt die Wiki-Seiten in drei Sprachen und veröffentlicht sie | [[wiki-content]]
step s8: Meldet, welche Gedächtniseinträge die Arbeit geprägt haben | [[mem-use]]
product p1: Geänderter Code und Dokumente in den Projekten
product p2: Ein Wiki, das dem Gebauten entspricht | [[wiki]]
product p3: Gedächtnisnutzung im Protokoll unter der Instanz codex festgehalten | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -ja-> s4
d1 -nein-> s5
s4 -> s6
s5 -> s6
s6 -> p1
s6 -> d2
d2 -ja-> s7
d2 -nein-> s8
s7 -> s8
s7 -> p2
s8 -> p3

## What it does
Er baut, testet und dokumentiert Software in `~/dev` so wie [[claude-code]]. Er liest zu Beginn jeder Sitzung Giovannis gemeinsames Gedächtnis ([[workflow-memory]]), hält Korrekturen mit [[mem]] fest und aktualisiert am Ende einer Aufgabe dieses Wiki ([[end-of-task]]).

## How it does it
Seine eigene Anweisungsdatei ist [[global-codex-agents]]. Seine Gedächtnis-Hooks führen den Befehl `mem --instance codex` aus, sodass jeder Gedächtniseintrag zeigt, welcher Assistent ihn schrieb; eine Vorliebe, die nur Codex braucht, wird mit dem Geltungsbereich `instance:codex` gespeichert, globale Einträge liest dagegen auch Claude Code. Seine Skills sind die Codex-Anpassungen in [[codex-skills]], installiert von [[codex-skillsctl]]. Im Terminal zeichnet [[codex-pbar]] die Fortschrittszeile und [[codex-status-line]] zeigt Nutzungskontingente und Kontextgröße.

## Where it sits in the pipeline
Zwischen [[giovanni]] und den Projekt-Repositories, parallel zu [[claude-code]]. Er spricht nie direkt mit anderen Assistenten: Alles Gemeinsame läuft über [[workflow-memory]] oder die Repositories.

## Who receives its output
Die Projekt-Repositories, das Gedächtnisprotokoll [[events-log]] und der Wiki-Inhalt ([[wiki-content]]).
