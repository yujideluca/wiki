---
id: codex-status-line
lang: de
source_hash: 4b6bfd83fb91
title: Native Codex-Statuszeile
---

## What it is
Die native Statuszeile zeigt die Nutzung im Codex-Terminal. Sie ergänzt die getrennte Zeile für den Aufgabenfortschritt in [[laptop-setup]].

## What it does
Sie zeigt die verbleibenden Prozentwerte des Fünfstunden- und Wochenkontingents, die im aktuellen Kontext verwendeten Tokens und die Kontextfenstergröße. Tokens sind die vom Modell gezählten Texteinheiten. Das Kontextfenster bestimmt, wie viel Text eine Anfrage aufnehmen kann.

## How it does it
Die Liste `tui.status_line` in `~/.codex/config.toml` enthält `five-hour-limit`, `weekly-limit`, `used-tokens`, `context-window-size` und `task-progress`. Ein neues Terminal lädt diese Einstellungen. Kontextwerte erscheinen, sobald eine Anfrage Nutzungsdaten meldet.

## Where it sits in the pipeline
Sie läuft innerhalb von Codex oberhalb der getrennten Fortschrittszeile.

## Who receives its output
Giovanni liest die Anzeige.

## Notes
Ein Terminaltest am 2026-10-25 mit Codex 0.164.0 zeigte `5h 44% left · weekly 76% left · 10.5K used · 475K window`. Ein zweites neues Terminal bestätigte die gespeicherte Konfiguration ohne Kommandozeilenüberschreibungen. Das Neuladen in bereits laufenden Terminals wurde nicht bestätigt.

Mit `tui.fullscreen_transcript = false` nutzt der Gesprächsverlauf den Rückscrollbereich des Terminals. Ein Terminaltest bestätigte, dass die dauerhafte doppelte Kontingentwarnung über der Eingabe entfällt und beide Kontingentfelder erhalten bleiben. Die Startwarnung bleibt im Verlauf.
