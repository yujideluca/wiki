---
id: memory-adrs
lang: de
source_hash: 4827125208c7
title: workflow-memory-ADRs
aliases: [Rollen und Grenzen]
---

## What it is
Die festgehaltenen Entscheidungen von [[workflow-memory]]: 0001 Entscheidungen festhalten, 0002 das Ereignisprotokoll, 0003 Rollen von Giovanni und den Claude-Instanzen.

## What it does
ADR-0002: Das Gedächtnis ist ein Nur-Anhängen-Protokoll, gefaltet von einer reinen Funktion, kein Protokoll zwischen Maschinen. ADR-0003: Giovanni entscheidet und genehmigt; [[claude-code]] baut; [[remote-assistant]] erledigt kurze Aufgaben mit denselben Regeln; [[claude-app]] unterhält sich und schreibt nur Gedächtnisereignisse. Die Instanzen sprechen nie direkt miteinander; workflow-memory ist ihre einzige gemeinsame Schnittstelle, und neue Projekte starten aus [[project-template]].

## How it does it
Jedes Prinzip wird durch einen Test oder CI-Job erzwungen, der in der CLAUDE.md des Repos genannt ist.

## Where it sits in the pipeline
Hinter jeder Regel, wer in diesem Wiki was darf.

## Who receives its output
Alle Claude-Instanzen und Giovanni.
