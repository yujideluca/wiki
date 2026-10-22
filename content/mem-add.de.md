---
id: mem-add
lang: de
source_hash: f2f175d2603e
title: mem add (Vorliebe oder Fakt festhalten)
aliases: [Eintrag hinzufügen]
---

## What it is
Der Befehl, der einen neuen Eintrag festhält: Vorliebe, Fakt, Entscheidung, Aufgabe oder Notiz.

## What it does
`mem add --type pref --owner user --key thema "die Regel"` schreibt ein Ereignis; ein neuerer Eintrag mit demselben Schlüssel ersetzt den älteren (automatisch als `supersedes` markiert), sodass eine von Giovanni geänderte Regel aktualisiert und nicht verdoppelt wird.

## How it does it
Vor dem Schreiben von [[mem-validator]] geprüft; Text höchstens 1200 Zeichen; Besitzer `user` heißt Giovannis eigene Worte, die der [[mem-harvester]] nie überschreiben darf.

## Where it sits in the pipeline
Immer, wenn Giovanni Claude korrigiert oder eine dauerhafte Vorliebe nennt (Regel der globalen CLAUDE.md).

## Who receives its output
[[events-log]].
