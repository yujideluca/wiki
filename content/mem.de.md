---
id: mem
lang: de
source_hash: 1b470cac0e2a
title: mem (Gedächtnisbefehl)
---

## What it is
`mem` ist das Kommandozeilenwerkzeug von [[workflow-memory]] (ein Kommandozeilenwerkzeug ist ein Programm, das man startet, indem man seinen Namen und seine Optionen in ein Terminal tippt). Damit lesen und schreiben [[claude-code]] und der [[remote-assistant]] das gemeinsame Gedächtnis. Es ist in Python 3 geschrieben und braucht nur die Standardbibliothek von Python.

## Architecture
### Kontext
person g: Giovanni — führt es ab und zu von Hand aus | [[giovanni]]
person c: Claude Code — schreibt Ereignisse und liest die Kurzfassung | [[claude-code]]
person x: Codex — dasselbe, mit eigenem Bereich | [[codex]]
person r: Remote-Assistent — dasselbe, vom Handy | [[remote-assistant]]
system m: mem — der Gedächtnisbefehl
external e: Ereignisprotokoll — die Dateien, die es liest und schreibt | [[events-log]]
external h: GitHub — wo das Gedächtnis abgeglichen wird | [[github]]

g -führt aus-> m
c -führt aus-> m
x -führt aus-> m
r -führt aus-> m
m -liest und ergänzt-> e
m -gleicht ab mit-> h

### Container
person u: Giovanni oder ein Assistent
container cl: cli.py — liest die Befehlszeile und ruft die Module auf
container ev: Ereignisse — Ereignisdateien schreiben und lesen
container fo: Faltung — macht aus dem Protokoll die aktuellen Einträge | [[memory-fold]]
container ck: Prüfungen — Prüfer, Sammler und Pendenzen | [[mem-validator]], [[mem-harvester]]
container se: Suche — findet Einträge über Wörter | [[mem-search]]
container sy: Abgleich und Installer — GitHub-Pull und -Push, Claude-Code-Hooks | [[mem-sync]]
store lg: Ereignisprotokoll — eine Datei pro Ereignis | [[events-log]]
store vw: Ansichten — die lesbaren Dateien, die es baut | [[memory-views]]

u -führt aus-> cl
cl -ruft auf-> ev
cl -ruft auf-> fo
cl -ruft auf-> ck
cl -ruft auf-> se
cl -ruft auf-> sy
ev -schreibt und liest-> lg
fo -schreibt-> vw

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
