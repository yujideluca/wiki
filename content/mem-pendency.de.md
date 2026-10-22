---
id: mem-pendency
lang: de
source_hash: 233324a439b0
title: Offene Punkte: Regeln (pendency.py)
---

## What it is
Die Regeln für offene Punkte ([[mem-task]]): ein eigener Gedächtnisfluss mit eigenem Budget.

## What it does
Nichts verfällt: Ein Punkt erscheint in jedem Chat, bis er gelöst, geparkt oder gelöscht ist. Standardmäßig überall sichtbar; nur wenn Giovanni es sagt, wird ein Punkt oder eine Kategorie projektabhängig (`mem scope project:X`). Budget 2.000 Tokens, getrennt vom Briefing; ein Punkt höchstens 500 Zeichen; die zuletzt aktiven zuerst.

## How it does it
Der Sitzungsstart sagt immer, wie man festhält, löst, parkt, löscht und eingrenzt; werden Punkte gezeigt, kommt die Prüfregel dazu (vor dem Erinnern die Prüfung ausführen; gilt er nicht mehr, schließen; ungeprüft, „ungeprüft“ sagen). Entstanden, nachdem am 20.10.2026 ein Punkt aus der Erinnerung an das Gespräch als offen gemeldet wurde, obwohl er schon erledigt war.

## Where it sits in the pipeline
Teil des Briefings, das [[hook-session-start]] baut.

## Who receives its output
[[session-brief]].
