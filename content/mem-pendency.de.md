---
id: mem-pendency
lang: de
source_hash: c56b96c7a701
title: Offene Punkte: Regeln (pendency.py)
---

## What it is
Das sind die Regeln für „offene Punkte“ (siehe [[mem-task]]): unerledigte Ziele und bekannte Probleme, die Giovanni vor Augen gehalten werden. Sie bilden einen eigenen Ablauf im Gedächtnis mit eigenem Größenbudget, sodass eine Flut alter Vorlieben nie einen offenen Punkt verdrängen kann. Der Code steht in `mem/pendency.py`.

## What it does
Nichts verfällt: Ein Punkt wird in jedem Chat gezeigt, bis er erledigt, geparkt oder gelöscht ist. Standardmäßig wird er in jedem Projekt gezeigt; nur wenn Giovanni es sagt, wird ein Punkt oder eine Kategorie auf ein Projekt beschränkt (`mem scope project:X`). Das Budget beträgt 2.000 Token (ein Token ist ein kleines Textstück, etwa drei Viertel eines Wortes), getrennt vom Budget des Briefs; ein Punkt darf höchstens 500 Zeichen haben; die zuletzt aktiven kommen zuerst.

## How it does it
Der Sitzungsstart sagt immer, wie man einen Punkt festhält, löst, parkt, löscht und eingrenzt. Werden Punkte gezeigt, ergänzt er die Prüfregel: Vor der Erinnerung an Giovanni die Prüfung des Punktes ausführen; gilt er nicht mehr, ihn schließen; konnte er nicht geprüft werden, „unchecked“ sagen. Die Regel entstand, nachdem am 2026-10-20 ein Punkt aus der Erinnerung an das Gespräch als offen gemeldet wurde, obwohl er längst erledigt war.

## Where it sits in the pipeline
Teil des Briefs, den [[hook-session-start]] baut.

## Who receives its output
Der [[session-brief]].
