---
id: events-log
lang: de
source_hash: a0bce5147cc8
title: events/ (das Gedächtnisprotokoll)
aliases: [Ereignisdateien]
---

## What it is
Das Gedächtnis selbst: eine Markdown-Datei pro Ereignis in `events/YYYY/MM/`, benannt `<Zeit>-<Instanz>-<6 Zeichen>.md` (der Name ist die ID; sein letzter Teil ist der #Code im Briefing).

## What it does
Enthält jede Vorliebe, jeden Fakt, jede Entscheidung, Aufgabe, Notiz und jedes Steuerereignis (feedback, claim, done, forget, use, archive, reopen, rescope). Dateien werden nie bearbeitet oder gelöscht, daher geraten Schreibende nie in Konflikt (ADR-0002).

## How it does it
Ein Kopfteil (`type`, `scope`, `key`, `owner`, `instance`, `ts`, optional `supersedes`, `target`, `signal`, `category`) und ein bis zwei Sätze. Der CI-Job `append-only` lehnt Änderungen ab; ungültige Dateien verschiebt [[mem-validator]] nach `quarantine/`.

## Where it sits in the pipeline
Geschrieben von [[mem]] (Laptop) und [[mem-github-connector]] (Claude-App); gelesen von [[memory-fold]].

## Who receives its output
[[memory-fold]] und [[mem-action]].
