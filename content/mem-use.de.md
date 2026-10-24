---
id: mem-use
lang: de
source_hash: 974978c215d4
title: mem use (melden, welche Einträge eine Aufgabe geprägt haben)
---

## What it is
`mem use REF1,REF2 --note "wie"` ist der Bericht am Ende einer Aufgabe. Er nennt die Gedächtniseinträge (anhand ihres kurzen `#code`), die die Arbeit geprägt haben, und sagt in wenigen Worten, wie.

## What it does
Jede gemeldete Nutzung lässt den Eintrag langsamer verblassen: Seine „Halbwertszeit“ (die Zeit, nach der sich sein Gewicht im Brief halbiert) wird um den Faktor `1 + log2(1 + Nutzungen)` gestreckt. Regeln, die wirklich genutzt werden, bleiben so im Brief, ungenutzte fallen allmählich heraus. Bei einem offenen Punkt hält er außerdem fest, wann und wie er zuletzt geprüft wurde. Er ist auch der Punkt, an dem die Wiki-Aktualisierung ausgelöst wird ([[end-of-task]]).

## How it does it
Er schreibt ein `use`-Ereignis, das die Einträge als `target: ref1, ref2` aufführt, plus eine kurze Notizzeile (die Notiz hat eine Längenbegrenzung).

## Where it sits in the pipeline
Der allerletzte Schritt jeder Aufgabe, direkt nach `wiki publish`.

## Who receives its output
Das Gedächtnisprotokoll [[events-log]]; [[memory-fold]] zählt die Nutzungen, wenn es die Einträge für den Brief ordnet.
