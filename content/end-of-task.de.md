---
id: end-of-task
lang: de
source_hash: 5521ba05f6ea
title: Ende einer Aufgabe (Wiki-Aktualisierungskette)
---

## What it is
Diese Seite beschreibt, was Claude jedes Mal tut, wenn eine Aufgabe fertig ist, damit Gedächtnis und Wiki nie hinter dem zurückbleiben, was tatsächlich gebaut wurde. Giovanni hat am 2026-10-22 entschieden, dass die Wiki-Aktualisierung an den Bericht `mem use` gekoppelt ist.

## Flow
trigger t1: Claude beendet eine Programmieraufgabe | [[claude-code]]
trigger t2: Claude will nach Codeänderungen aufhören, ohne zu veröffentlichen | [[wiki-hook-stop]]
step s1: Belegt die Arbeit durch laufende Prüfungen | [[skill-verification-before-completion]]
step s2: Schreibt oder aktualisiert die englischen Seiten, dann die deutschen und portugiesischen | [[wiki-content]]
step s3: Gibt allem, was seinen Platz sprengt, eine eigene Seite | [[wiki-check]]
decide d1: Besteht die Inhaltsprüfung?
step s3b: Behebt, was die Prüfung meldet
step s4: Führt wiki publish aus: prüft, baut die Seite, committet content/, lädt hoch | [[wiki-cli]]
step s5: Die Live-Seite liefert die neuen Seiten sofort aus | [[wiki-site]]
step s6: Meldet, welche Gedächtniseinträge die Arbeit geprägt haben | [[mem-use]]
product p1: Ein Wiki, das dem Gebauten entspricht | [[wiki]]
product p2: Die auf GitHub gespeicherten Seiten | [[github]]
product p3: Gedächtnisnutzung im Protokoll festgehalten | [[events-log]]

t1 -> s1
s1 -> s2
t2 -> s2
s2 -> s3
s3 -> d1
d1 -ja-> s4
d1 -nein-> s3b
s3b -> s4
s4 -> s5
s4 -> p2
s5 -> p1
s5 -> s6
s6 -> p3

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
4. `wiki publish -m "…"` prüft den Inhalt, baut die Seite, committet nur den Ordner `content/` und lädt ihn hoch ([[wiki-cli]]). Die Sitzung ergänzt `--co-author "Name <email>"` mit ihrer eigenen Zuschreibungszeile oder lässt es weg.
5. Die Live-Seite liefert die neuen Daten sofort aus ([[wiki-site]], [[wiki-router]]).
6. `mem use REF… --note "how"` meldet die verwendeten Gedächtniseinträge ([[mem-use]]).
7. Wenn der Durchgang endet, bestätigt [[wiki-hook-stop]], dass nichts vergessen wurde, und [[hook-stop]] lädt die Gedächtnisereignisse hoch.
