---
id: mem-harvester
lang: de
source_hash: 70527e6145e4
title: Vorlieben-Sammler (harvest.py)
aliases: [Sammler]
---

## What it is
Sammelt Vorlieben aus Giovannis eigenen Worten in den Eingaben, damit eine einmal gesagte Regel nicht verloren geht.

## What it does
Nur der Eingabetext des Nutzers zählt (nie Werkzeugausgaben oder Claudes Text), Englisch und Portugiesisch, nur Sätze, die eine Regel aufstellen und eine Handlung nennen. Standardbereich ist das Projekt; eine Gewohnheit aus zwei Projekten oder mit „in allen meinen Projekten“ wird global (`promote`).

## How it does it
Deterministische Ereignis-IDs, sodass ein wiederholter Hook-Aufruf dieselbe Datei schreibt. Ein gesammelter Eintrag überschreibt nie einen mit `owner: user`; er wird stattdessen ein Vorschlag in REVIEW.

## Where it sits in the pipeline
Aufgerufen von [[hook-prompt]] bei jeder Nachricht, die Giovanni an Claude Code schickt.

## Who receives its output
[[events-log]].
