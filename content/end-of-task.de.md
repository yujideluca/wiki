---
id: end-of-task
lang: de
source_hash: a93720e775ec
title: Ende einer Aufgabe (Wiki-Aktualisierungskette)
aliases: [Aktualisierungskette]
---

## What it is
Was Claude jedes Mal tut, wenn es eine Aufgabe beendet, damit Gedächtnis und Wiki nie hinter dem Gebauten zurückbleiben (von Giovanni am 22.10.2026 entschieden: die Wiki-Aktualisierung hängt an `mem use`).

## What it does
Aktualisiert die Seiten für das Geänderte (neue, geänderte, stillgelegte Begriffe, mit Übersetzungen), veröffentlicht sie durch die Prüfungen und meldet dann, welche Gedächtniseinträge die Arbeit geprägt haben.

## How it does it
Eine Regel in [[global-claude-md]]; die Prüfungen in [[wiki-check]]; das Sicherheitsnetz [[wiki-hook-stop]].

## Where it sits in the pipeline
Der letzte Schritt jeder Programmieraufgabe in jedem Projekt.

## Who receives its output
[[wiki-content]], [[github]] und [[events-log]].

## Steps
1. Die Arbeit der Aufgabe ist erledigt und geprüft ([[skill-verification-before-completion]]).
2. Claude aktualisiert oder erstellt die englischen Seiten in `~/dev/wiki/content` für das Geänderte, dann die Versionen de und pt-BR ([[wiki-content]]).
3. Was über die Seitenschwelle gewachsen ist, bekommt eine eigene Seite (Beförderungsregel, [[wiki-check]]).
4. `wiki publish -m "…"` prüft lokal, baut, committet nur content/ und pusht ([[wiki-cli]]).
5. Die laufende Seite liefert die neuen Daten sofort aus ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "wie"` meldet die genutzten Gedächtniseinträge ([[mem-use]]).
7. Am Ende der Runde bestätigt [[wiki-hook-stop]], dass nichts vergessen wurde, und [[hook-stop]] pusht die Gedächtnisereignisse.
