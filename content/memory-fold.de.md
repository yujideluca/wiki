---
id: memory-fold
lang: de
source_hash: 80b7998a6f55
title: Die Faltung (core.py)
---

## What it is
„Die Faltung“ (fold) ist die einzelne Funktion im Herzen von [[workflow-memory]]: Sie nimmt das gesamte Ereignisprotokoll und „faltet“ es zum aktuellen Stand zusammen (wie das Zusammenfalten einer langen Liste zu einem Ergebnis). In der Programmiersprache ist es eine [reine Funktion](https://en.wikipedia.org/wiki/Pure_function): Dieselbe Eingabe ergibt immer dieselbe Ausgabe, und sie verändert sonst nichts. Sie liegt in `mem/core.py`.

## What it does
Für jedes Thema (Scope plus Key) gewinnt die jüngste Entscheidung; dieselbe Entscheidung noch einmal liefert zusätzliche Belege; eine Verneinung zählt als Änderung; `forget` und `done` schließen ihr Ziel; Feedback ändert, wie prominent ein Eintrag ist (`wrong` nimmt ihn aus dem Brief und legt ihn Giovanni zur Prüfung vor). Ein Ereignis des automatischen [[mem-harvester]] überschreibt nie Giovannis eigene Worte. Geben zwei Schreiber demselben Key innerhalb von 24 Stunden verschiedene Texte, entsteht ein Konflikt, den Giovanni sieht, keine stille Zusammenführung. Danach ordnet sie die Einträge für den Brief: Vorlieben verblassen nie; andere Typen verblassen mit einer Halbwertszeit (die Zeit, nach der das Gewicht sich halbiert): 180 Tage für Entscheidungen und Fakten, 7 Tage für Notizen, gestreckt durch jede gemeldete Nutzung ([[mem-use]]).

## How it does it
Das Ergebnis hängt nicht von der Reihenfolge ab, in der Ereignisse eintreffen, und ist [idempotent](https://en.wikipedia.org/wiki/Idempotence) (ein Duplikat anzuwenden ändert nichts); beides ist getestet. Ereignisse werden nach Zeit und dann ID sortiert, Duplikate zählen einmal. Die Funktion `brief()` passt die Einträge in ein Budget von 2.900 Zeichen (`BRIEF_BUDGET`) ein; mit etwa 1.100 Zeichen festem Anleitungstext ist der ganze Brief etwa 4.000 Zeichen lang, das sind 2,5 % des am 2026-10-19 gemessenen mittleren ersten Durchgangs (44.860 Token); die Zahlen wurden mit `scripts/calibrate.py` kalibriert.

## Where it sits in the pipeline
Zwischen [[events-log]] und allem, was Gedächtnis anzeigt.

## Who receives its output
Der [[session-brief]] (über [[hook-session-start]]) und [[memory-views]] (über [[mem-action]]).
