---
id: workflow-memory
lang: de
source_hash: ad81192bd3bb
title: workflow-memory (gemeinsames Gedächtnis)
aliases: [Gedächtnis]
---

## What it is
Das gemeinsame, langlebige Gedächtnis aller Claude-Instanzen, die Giovanni nutzt. Privates Repo `yujideluca/workflow-memory`, Ordner `~/dev/workflow-memory`. Es ersetzte das stillgelegte claude-workflow-backup-Protokoll ([[retired-workflow-pipeline]]).

## What it does
Bewahrt Vorlieben, Fakten, Entscheidungen und offene Punkte und zeigt die relevanten zu Beginn jedes Chats ([[session-brief]]). Es ist die einzige Schnittstelle zwischen den Claude-Instanzen (ADR-0003, [[memory-adrs]]).

## How it does it
Das Protokoll ist das Gedächtnis: Jeder Eintrag ist eine neue, nie bearbeitete Datei in [[events-log]]. [[memory-fold]] berechnet den aktuellen Zustand (die neueste Regel pro Schlüssel gewinnt). [[mem-action]] erzeugt [[memory-views]] auf GitHub neu. Claude Code schreibt mit [[mem]] und seinen Hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); die Claude-App schreibt über [[mem-github-connector]]. Nur Python-Standardbibliothek; [[mem-validator]] hält Geheimnisse und Kontaktdaten fern.

## Where it sits in the pipeline
Unter allen anderen Projekten: Sie lesen ihre Voreinstellungen daraus und melden mit `mem use` zurück.

## Who receives its output
Jede Claude-Instanz über das Briefing; [[giovanni]] über [[memory-views]] (REVIEW.md).
