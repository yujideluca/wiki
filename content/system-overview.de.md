---
id: system-overview
lang: de
source_hash: a920ee143759
title: Das ganze System auf einen Blick
---

## What it is
Diese Seite ist das große Bild von Giovannis Systemen: ein Diagramm, das eine Bitte verfolgt, von Giovannis Frage bis Arbeit, Wiki und Gedächtnis auf dem neuesten Stand sind. Jeder Kasten verweist auf die Seite, die ihn erklärt; das Diagramm ist also auch ein Inhaltsverzeichnis des Wikis.

## Flow
trigger t1: Giovanni bittet um etwas | [[giovanni]]
decide d1: Welchen Assistenten nutzt Giovanni?
step s1: Claude Code, im Laptop-Terminal | [[claude-code]]
step s2: Codex, im Laptop-Terminal | [[codex]]
step s3: Der Dauer-Assistent, vom Handy | [[remote-assistant]]
step s4: Die Claude-App auf claude.ai | [[claude-app]]
step s5: Jeder Chat beginnt mit dem Lesen der gemeinsamen Gedächtnis-Zusammenfassung | [[chat-start]], [[workflow-memory]]
step s6: Ein Skill wird geladen, wenn die Anfrage zu seiner Beschreibung passt | [[skills]]
step s7: Die Arbeit geschieht in einem Projekt: Quiz-Apps, Wiki, Werkzeuge | [[quizapp]], [[wiki]]
step s8: Ein Quality Gate und die automatischen Prüfungen müssen bestehen | [[maintenance-pipeline]], [[quizapp-quality-gate]]
decide d2: Ist es eine Änderung an der Android-App?
step s9: Erst Beta, stabil nur auf Giovannis Wort | [[quizapp-release]]
step s10: Ende der Aufgabe: Wiki-Seiten in drei Sprachen aktualisiert | [[end-of-task]]
step s11: Die Gedächtniseinträge, die die Arbeit geprägt haben, werden gemeldet | [[mem]]
product p1: Eine funktionierende App auf Giovannis Handy | [[phone]]
product p2: Ein Wiki, das erklärt, wie alles zusammenpasst | [[wiki]]
product p3: Gedächtnis, das jeder künftige Chat zuerst liest | [[events-log]]

t1 -> d1
d1 -Claude Code-> s1
d1 -Codex-> s2
d1 -Handy-> s3
d1 -claude.ai-> s4
s1 -> s5
s2 -> s5
s3 -> s5
s4 -> s5
s5 -> s6
s6 -> s7
s7 -> s8
s8 -> d2
d2 -ja-> s9
d2 -nein-> s10
s9 -> s10
s9 -> p1
s10 -> s11
s10 -> p2
s11 -> p3

## What it does
Es zeigt der Reihe nach, welcher Assistent die Bitte übernimmt ([[claude-code]], [[codex]], der [[remote-assistant]] oder die [[claude-app]]), was jeder zuerst liest ([[workflow-memory]]), wie ein Skill dazukommt ([[skills]]), wo die Arbeit geschieht (ein Projekt wie [[quizapp]] oder das [[wiki]]), was bestehen muss, bevor etwas als fertig gilt ([[maintenance-pipeline]]), und was am Ende zurückbleibt. Für die Kette eines einzelnen Konzepts öffnet man dessen eigene Seite und liest das Flussdiagramm.

## How it does it
Es ist ein handgeschriebener Flow-Abschnitt wie auf jeder Konzeptseite ([[wiki-flow-view]]), absichtlich kurz gehalten: Er nennt die wichtigsten Stationen und überlässt die Einzelheiten den verlinkten Seiten. Die Karte ([[wiki]]) zeigt dieselben Seiten als Punkte und Verbindungen; diese Seite zeigt sie als Weg in der Zeit.

## Where it sits in the pipeline
Sie steht über allen anderen Seiten als Einstieg für Leser, die noch nicht wissen, welche Seite sie öffnen sollen.

## Who receives its output
[[giovanni]] und alle Neuen, die verstehen müssen, wie die Teile zusammenpassen.
