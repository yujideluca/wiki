---
id: mem
lang: de
source_hash: cc93e389c143
title: mem (Gedächtnisbefehl)
---

## What it is
`mem` ist das Kommandozeilenwerkzeug von [[workflow-memory]] (ein Kommandozeilenwerkzeug ist ein Programm, das man startet, indem man seinen Namen und seine Optionen in ein Terminal tippt). Damit lesen und schreiben [[claude-code]] und der [[remote-assistant]] das gemeinsame Gedächtnis. Es ist in Python 3 geschrieben und braucht nur die Standardbibliothek von Python.

## What it does
Es schreibt pro Änderung eine neue Ereignisdatei ([[mem-add]], [[mem-use]], [[mem-task]] sowie Feedback, Vergessen, Erledigt, Beanspruchen und Ähnliches), gibt den Brief aus, durchsucht das Gedächtnis ([[mem-search]]), prüft Dateien auf Probleme, erzeugt die lesbaren Dateien in [[memory-views]], synchronisiert mit GitHub und installiert seine eigenen Claude-Code-Hooks.

## How it does it
Die Datei `mem/cli.py` liest die Kommandozeile und ruft die Module auf: `events.py` (Ereignisdateien schreiben und lesen), [[memory-fold]] (`core.py`), [[mem-validator]], [[mem-harvester]], [[mem-pendency]], `search.py`, `project.py`, [[mem-sync]] und `install.py`.

## Where it sits in the pipeline
Es ist die Tür, durch die auf dem Laptop ins Gedächtnis geschrieben wird. Auch die Hooks rufen es auf, als `mem hook-session-start`, `mem hook-prompt` und `mem hook-stop`.

## Who receives its output
[[events-log]] (die neuen Dateien) und das Terminal (Brief, Suchergebnisse).

## Functions
- `mem add --type pref --owner user --key topic "rule"`: eine Korrektur oder dauerhafte Vorliebe festhalten
- `mem feedback REF wrong|stale|helpful|not_helpful`: einen Eintrag bewerten
- `mem forget REF`, `mem done REF`, `mem archive REF`, `mem reopen REF`: löschen, erledigen, parken, zurückholen
- `mem claim REF`: eine Aufgabe beanspruchen (die früheste Beanspruchung gewinnt)
- `mem pending`, `mem scope`: offene Punkte auflisten und eingrenzen
- `mem brief`, `mem search "words"`: den Brief ausgeben, Volltextsuche
- `mem check`, `mem quarantine`, `mem dismiss`: Gültigkeit der Ereignisdateien
- `mem promote`, `mem compact [--apply]`: Gewohnheiten global machen; alte Einträge zusammenfassen
- `mem build [--check]`: die Ansichten neu erzeugen
- `mem sync [--pull] [--push]`, `mem install-hooks`
