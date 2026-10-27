---
id: mem-harvester
lang: de
source_hash: 79ffe59f2902
title: Vorlieben-Harvester (harvest.py)
---

## What it is
Der Harvester („to harvest“ heißt ernten) sammelt Vorlieben aus Giovannis eigenen Worten in seinen Nachrichten auf, damit eine einmal gesagte Regel nicht verloren geht, nur weil niemand `mem add` ausgeführt hat. Er liegt in `mem/harvest.py`.

## What it does
Nur der eigene Nachrichtentext des Benutzers zählt (nie Werkzeugausgaben oder Claudes Text), auf Englisch und Portugiesisch, und nur Sätze, die eine Regel aussprechen und eine Handlung nennen. Standardmäßig gilt eine geerntete Vorliebe nur für das aktuelle Projekt; eine Gewohnheit, die in zwei Projekten auftaucht, oder eine, die als „in all meinen Projekten“ formuliert ist, wird global (dieser Schritt heißt `promote`).

## How it does it
Die Ereignis-IDs sind deterministisch (dieselbe Eingabe ergibt immer dieselbe ID), sodass ein wiederholter Hook-Aufruf dieselbe Datei schreibt statt eines Duplikats. Ein geernteter Eintrag überschreibt nie einen mit `owner: user` (Giovannis eigene festgehaltene Worte); stattdessen wird er zu einem Vorschlag in der Prüfdatei, über den Giovanni entscheidet. Text wird ignoriert, wenn die ganze Nachricht länger als 1500 Zeichen ist (ein eingefügtes Dokument oder ein von einem Programm geschriebener Prompt, keine kurze Vorliebe) und wenn ein Satz wie eine Überschrift oder ein nummerierter Listenpunkt beginnt. Das kam hinzu, nachdem erzeugte Vorschlags-Prompts von Codex als 17 falsche Vorlieben gespeichert worden waren.

## Where it sits in the pipeline
Wird von [[hook-prompt]] bei jeder Nachricht aufgerufen, die Giovanni an Claude Code sendet.

## Who receives its output
[[events-log]].
