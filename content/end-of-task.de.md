---
id: end-of-task
lang: de
source_hash: 883c3c32604a
title: Ende einer Aufgabe (Wiki-Aktualisierungskette)
---

## What it is
Diese Seite beschreibt, was Claude jedes Mal tut, wenn eine Aufgabe fertig ist, damit Gedächtnis und Wiki nie hinter dem zurückbleiben, was tatsächlich gebaut wurde. Giovanni hat am 2026-10-22 entschieden, dass die Wiki-Aktualisierung an den Bericht `mem use` gekoppelt ist.

## What it does
Claude aktualisiert die Wiki-Seiten zu allem, was sich geändert hat (neue, geänderte oder stillgelegte Dinge, jeweils mit deutscher und portugiesischer Übersetzung), veröffentlicht sie durch die Inhaltsprüfungen und meldet dann, welche Gedächtniseinträge die Arbeit geprägt haben.

## How it does it
Die Regel steht in [[global-claude-md]]; die Prüfungen, die das Veröffentlichen absichern, stehen in [[wiki-check]]; und ein Sicherheitsnetz, [[wiki-hook-stop]], erinnert Claude, falls es das vergessen hat.

## Where it sits in the pipeline
Es ist der letzte Schritt jeder Programmieraufgabe in jedem Projekt.

## Who receives its output
Der Wiki-Inhalt ([[wiki-content]]), [[github]] (wo das Wiki gespeichert ist) und das Gedächtnisprotokoll [[events-log]].

## Steps
1. Die Arbeit der Aufgabe ist erledigt und durch ausgeführte Prüfungen belegt ([[skill-verification-before-completion]]).
2. Claude aktualisiert oder erstellt die englischen Seiten in `~/dev/wiki/content` für das, was sich geändert hat, danach die deutschen und brasilianisch-portugiesischen Fassungen ([[wiki-content]]). Eine Seite, die mit ihren Quellen verglichen und für richtig befunden wurde, bekommt ihren `reviewed`-Zeitpunkt auf die aktuelle UTC-Zeit gesetzt; das nimmt sie in [[wiki-stale]] aus der Liste.
3. Alles, was die Seitenschwelle überschritten hat, bekommt eine eigene Seite (die Beförderungsregel, durchgesetzt von [[wiki-check]]).
4. `wiki publish -m "…"` prüft den Inhalt, baut die Seite, committet nur den Ordner `content/` und lädt ihn hoch ([[wiki-cli]]).
5. Die Live-Seite liefert die neuen Daten sofort aus ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` meldet die verwendeten Gedächtniseinträge ([[mem-use]]).
7. Wenn der Durchgang endet, bestätigt [[wiki-hook-stop]], dass nichts vergessen wurde, und [[hook-stop]] lädt die Gedächtnisereignisse hoch.
