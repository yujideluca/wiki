---
id: hook-prompt
lang: de
source_hash: 58369d16ec08
title: UserPromptSubmit-Hook (mem hook-prompt)
---

## What it is
Der Claude-Code-Hook, der bei jeder Nachricht von Giovanni läuft: `mem hook-prompt` (Zeitlimit 10 s).

## What it does
Gibt den Nachrichtentext an [[mem-harvester]], der jede genannte Vorliebe festhält. Gibt nichts aus.

## How it does it
Fehler gehen ins Hook-Protokoll; es endet immer mit 0 und kann so nie eine Nachricht blockieren.

## Where it sits in the pipeline
Zwischen Giovannis Nachricht und dem Modell.

## Who receives its output
[[mem-harvester]].
