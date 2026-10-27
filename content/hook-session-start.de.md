---
id: hook-session-start
lang: de
source_hash: 595edec48d32
title: SessionStart-Hook (mem hook-session-start)
---

## What it is
Ein Hook ist ein kleines Programm, das [[claude-code]] automatisch ausführt, wenn ein bestimmtes Ereignis eintritt ([Hooks erklärt](https://docs.claude.com/en/docs/claude-code/hooks-guide)). Dieser läuft, wenn ein Chat beginnt: `python3 ~/dev/workflow-memory/bin/mem hook-session-start`, mit einem Zeitlimit von 40 Sekunden. Seine Aufgabe ist, dem neuen Chat sein Gedächtnis mitzugeben.

## What it does
Er lädt die neueste Version des Gedächtnisses von GitHub herunter, fasst die gespeicherten Ereignisse zum aktuellen Stand zusammen und gibt den [[session-brief]] für das aktuelle Projekt aus (das Projekt wird aus dem Namen des Ordners abgeleitet, in dem der Chat geöffnet wurde). Was ein Hook in diesem Moment ausgibt, wird dem Modell vorangestellt; so „erinnert“ sich Claude an Giovannis Vorlieben.

## How it does it
Er darf nie laut scheitern, denn seine Ausgabe geht direkt in den Kontext des Modells: Eine Fehlermeldung dort würde den Chat verwirren. Fehler werden deshalb in eine Logdatei geschrieben, `~/.local/state/mem/hook.log`. Ist der Laptop offline, greift er auf den zuletzt geladenen Stand zurück, und der Brief weist dann darauf hin, dass das Gedächtnis veraltet sein kann. Der Hook läuft, wenn ein Chat beginnt, nach `/clear` und nach einer Verdichtung (Claude Code kürzt einen langen Chat zu einer Zusammenfassung). Nach `/clear` oder einer Verdichtung gibt er jede Regel auf ihre ersten 110 Zeichen gekürzt aus, um Tokens zu sparen (die Einheit, in der ein Modell liest und abgerechnet wird); der volle Text ist ein `mem search` entfernt. Codex ruft denselben Befehl als `mem --instance codex hook-session-start` auf; daher erreichen Regeln mit dem Geltungsbereich `instance:codex` nur Codex, und reine Codex-Regeln werden in Claude Code nicht mehr geladen.

## Where it sits in the pipeline
Er ist der erste Schritt von [[chat-start]].

## Who receives its output
Der [[session-brief]] und über ihn die Claude-Code-Sitzung.
