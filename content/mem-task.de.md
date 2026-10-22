---
id: mem-task
lang: de
source_hash: 43266564fb16
title: mem task (offene Punkte)
aliases: [offener Punkt]
---

## What it is
Wie ein unerledigtes Ziel oder bekanntes Problem vor Giovanni bleibt, bis es erledigt ist: `mem task --check WIE [--category K] "Text"`.

## What it does
Legt ein `task`-Ereignis an (`was offen ist | check: wie man prüft, ob es noch gilt`). Es erscheint zu Beginn jedes Chats, bis Giovanni entscheidet: gelöst (`mem done`), geparkt (`mem archive`, zurück mit `mem reopen`) oder gelöscht (`mem forget`). Die Regeln stehen in [[mem-pendency]].

## How it does it
Die Kommandozeile lehnt eine Aufgabe ohne Prüfung ab. Bevor Claude an einen Punkt erinnert, führt es dessen Prüfung aus; gilt er nicht mehr, schließt Claude ihn stattdessen.

## Where it sits in the pipeline
Am Ende einer Sitzung für alles, was noch offen ist.

## Who receives its output
[[events-log]], danach das [[session-brief]] jedes Chats.
