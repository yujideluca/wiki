---
id: claude-auto-memory
lang: de
source_hash: beb58ec2ef19
title: Auto-Gedächtnis von Claude Code
---

## What it is
Das eigene kleine Dateigedächtnis von Claude Code für Sitzungen im Home-Ordner: ein Fakt pro Datei plus der Index `MEMORY.md`, in jede solche Sitzung geladen.

## What it does
Enthält laptopspezifische Notizen: wie man den Fernassistenten prüft, das German-Quiz-Projekt, Pfade der Werkzeuge im Benutzerbereich, die Regel zum Debuggen nach dem Programmieren, dass der deutsch-gespraech-Hinweis nicht für Claude Code ist und dass die alte Pipeline stillgelegt ist.

## How it does it
Von Claude Code im Gedächtnisformat geschrieben (Kopfteil + Fakt + warum + wie anwenden). Gemeinsame Regeln für alle Instanzen gehören stattdessen in [[workflow-memory]].

## Where it sits in the pipeline
Bei [[chat-start]] neben [[global-claude-md]] geladen.

## Who receives its output
[[claude-code]].
