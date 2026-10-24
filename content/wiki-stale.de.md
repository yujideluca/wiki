---
id: wiki-stale
lang: de
source_hash: a2609bb04610
title: wiki stale (Seiten hinter ihren Quellen)
---

## What it is
`wiki stale` ist der Befehl, der die Wiki-Seiten auflistet, die veraltet sein könnten, weil sich die beschriebenen Dateien nach der Seite geändert haben. Er ist einer der Befehle von [[wiki-cli]] und teilt sich die Code-Datei mit dem Stop-Hook ([[wiki-hook-stop]]), stellt aber eine andere Frage.

## What it does
Für jede Seite betrachtet er jede im Kopf `sources` genannte Datei (geschrieben `repo:path`). Hat eine davon einen Commit (eine in git gespeicherte Änderung), der neuer ist als der letzte Commit der Seite selbst, wird die Seite als „<Quelle> changed after the page“ aufgelistet. Gibt es nichts aufzulisten, druckt er „no stale pages“.

## How it does it
Er fragt git nach dem Zeitpunkt des letzten Commits der Seite und jeder Quelle und vergleicht die beiden Zeiten. Er schaut nur auf die Zeit, nicht darauf, was die Seite sagt. Jeder spätere Commit der Seite, etwa eine Massenüberarbeitung oder eine Veröffentlichung, lässt die Seite daher als aktuell gelten, auch wenn ihr Text die Änderung nicht erwähnt. Er sieht auch keine neue Datei, die keine Seite abdeckt, weil er nur Dateien verfolgt, die Seiten schon nennen. Der Stop-Hook benutzt einen anderen Test (Änderungen seit der letzten `wiki publish`, plus neue nicht abgedeckte Dateien); die beiden können deshalb voneinander abweichen, wie in [[wiki-hook-stop]] erklärt. Keine Seite trägt ein eigenes Prüfdatum: Keine der 139 Seiten mit Quellen hat ein Feld `reviewed:`, der Befehl kann also „geprüft und richtig“ nicht von „angefasst“ unterscheiden.

## Where it sits in the pipeline
Eine manuelle Prüfung, die Claude zu Beginn von [[skill-wiki-page-writer]] ausführt und immer dann, wenn Giovanni wissen will, wie weit das Wiki hinter dem Code liegt.

## Who receives its output
Wer ihn ausgeführt hat (Claude oder Giovanni), über [[wiki-cli]].
