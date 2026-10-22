---
id: session-brief
lang: de
source_hash: 2b6add466f4b
title: Sitzungs-Briefing (Gedächtnis beim Chatstart)
aliases: [Briefing]
---

## What it is
Der Textblock, den ein Claude-Code-Chat zuerst sieht: „Memory (workflow-memory)…“ mit Giovannis festen Vorlieben (jede mit ihrem #Code), offenen Punkten und wie man festhält, meldet und Rückmeldung gibt.

## What it does
Setzt Voreinstellungen für die Sitzung (es erlaubt nie etwas); Vorrang: aktuelle Anweisung > Regeldatei des Repos > Projektgedächtnis > Profil.

## How it does it
Ausgegeben von [[hook-session-start]] aus [[memory-fold]] und [[mem-pendency]], innerhalb der Budgets; sagt „memory may be stale“, wenn das Holen fehlschlug.

## Where it sits in the pipeline
Die erste Eingabe jeder Claude-Code-Sitzung ([[chat-start]]).

## Who receives its output
[[claude-code]] und [[remote-assistant]].
