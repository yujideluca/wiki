---
id: codex-status-line
lang: de
source_hash: 62df6c20d581
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

Mit `tui.fullscreen_transcript = true` setzt Codex Eingabe und native Statuszeile sofort an den unteren Rand; der Verlauf wird innerhalb von Codex gescrollt. Im Rückscrollmodus (`false`) beginnen beide oben und wandern mit wachsender Ausgabe nach unten, getrennt von der festen Fortschrittszeile. Ein Vergleich mit Codex 0.164.0 zeigte die Kontingentwerte in Zeile 13 von 52 im Rückscrollmodus und in Zeile 51 im Vollbildmodus, ohne eine Anfrage zu senden. Auch bei 70 Spalten und 24 Zeilen blieb die Anzeige im Vollbildmodus unten. Die Terminalansicht muss neu geöffnet werden, damit die gespeicherte Einstellung gilt. Im Vollbildmodus kann Codex über der Eingabe eine zusätzliche Kontingentwarnung anzeigen.
