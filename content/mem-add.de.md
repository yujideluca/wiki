---
id: mem-add
lang: de
source_hash: 9c81f1250714
title: mem add (Vorliebe oder Fakt festhalten)
---

## What it is
`mem add` ist der Befehl, der einen neuen Eintrag im Gedächtnis festhält: eine Vorliebe, einen Fakt, eine Entscheidung, eine Aufgabe oder eine Notiz. Claude führt ihn aus, wenn Giovanni es korrigiert oder eine dauerhafte Vorliebe äußert.

## What it does
`mem add --type pref --owner user --key topic "die Regel"` schreibt eine Ereignisdatei. Jeder Eintrag hat einen `key`, einen kurzen Namen für sein Thema. Ein neuerer Eintrag mit demselben Key ersetzt den älteren: Der neue wird automatisch als Ablösung des alten markiert, sodass eine von Giovanni geänderte Regel aktualisiert statt verdoppelt wird.

## How it does it
Der Eintrag wird vor dem Schreiben von [[mem-validator]] geprüft, und der Text darf höchstens 1200 Zeichen lang sein. Das Feld `owner` ist wichtig: `user` heißt, die Worte stammen von Giovanni selbst, und der automatische [[mem-harvester]] darf sie nie überschreiben.

## Where it sits in the pipeline
Wird benutzt, wenn Giovanni Claude korrigiert oder eine dauerhafte Vorliebe äußert (eine Regel in den globalen Anweisungen, [[global-claude-md]]).

## Who receives its output
[[events-log]].
