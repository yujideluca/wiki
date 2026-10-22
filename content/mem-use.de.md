---
id: mem-use
lang: de
source_hash: a6e7acb3fc35
title: mem use (melden, welche Einträge eine Aufgabe geprägt haben)
---

## What it is
Der Bericht am Ende einer Aufgabe: `mem use REF1,REF2 --note "wie"`, mit den Gedächtniseinträgen (nach ihrem #Code), die die Arbeit geprägt haben.

## What it does
Jede Nutzung verlängert die Halbwertszeit eines Eintrags um `1 + log2(1 + Nutzungen)`, sodass genutzte Regeln im Briefing bleiben; bei einem offenen Punkt hält sie fest, wann und wie er zuletzt geprüft wurde. Sie ist auch der Auslöser der Wiki-Aktualisierung ([[end-of-task]]).

## How it does it
Schreibt ein `use`-Ereignis mit `target: ref1, ref2` und einer kurzen Zeile (die Notiz hat eine Längengrenze).

## Where it sits in the pipeline
Der letzte Schritt jeder Aufgabe, direkt nach `wiki publish`.

## Who receives its output
[[events-log]]; [[memory-fold]] zählt die Nutzungen beim Ranking des Briefings.
