---
id: hook-stop
lang: de
source_hash: 12ac2c848f9a
title: Stop-Hook (mem hook-stop)
---

## What it is
Der Claude-Code-Hook des Gedächtnisses, der läuft, wenn Claude eine Runde beendet: `mem hook-stop` (Zeitlimit 40 s).

## What it does
Pusht neue Gedächtnisereignisse zu GitHub, damit die Claude-App und die nächste Sitzung sie sehen.

## How it does it
Ruft `push` von [[mem-sync]] auf; offline committet es lokal und pusht später; Fehler gehen ins Hook-Protokoll. Er läuft neben dem eigenen Stop-Hook des Wikis ([[wiki-hook-stop]]).

## Where it sits in the pipeline
Ende jeder Runde.

## Who receives its output
[[mem-sync]] → [[github]].
