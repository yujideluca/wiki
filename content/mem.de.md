---
id: mem
lang: de
source_hash: ed035e7c48fb
title: mem (Gedächtnis-Befehl)
---

## What it is
Das Kommandozeilenwerkzeug von [[workflow-memory]]: So lesen und schreiben Claude Code und der Assistent das gemeinsame Gedächtnis. Python 3, nur Standardbibliothek.

## What it does
Schreibt pro Änderung eine neue Ereignisdatei ([[mem-add]], [[mem-use]], [[mem-task]], feedback, forget, done, claim…), gibt das Briefing aus, sucht ([[mem-search]]), prüft, baut [[memory-views]], gleicht mit GitHub ab und installiert seine eigenen Claude-Code-Hooks.

## How it does it
`mem/cli.py` liest den Befehl und ruft die Module auf: `events.py` (Dateien schreiben/lesen), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]], `install.py`.

## Where it sits in the pipeline
Die Schreibtür des Gedächtnisses auf dem Laptop; die Hooks rufen es als `mem hook-session-start`, `hook-prompt`, `hook-stop` auf.

## Who receives its output
[[events-log]] (neue Dateien) und das Terminal (Briefing, Suchergebnisse).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: record a correction or lasting preference
- `mem feedback REF wrong|stale|helpful|not_helpful`: rate an entry
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: close, solve, park, bring back
- `mem claim REF`: claim a task (earliest claim wins)
- `mem pending`, `mem scope`: list and scope open items
- `mem brief`, `mem search "words"`: print the brief, full-text search
- `mem check`, `mem quarantine`, `mem dismiss`: validity of event files
- `mem promote`, `mem compact [--apply]`: global habits; digest cold entries
- `mem build [--check]`: regenerate views
- `mem sync [--pull] [--push]`, `mem install-hooks`
