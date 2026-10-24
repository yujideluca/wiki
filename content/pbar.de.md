---
id: pbar
lang: de
source_hash: 87fde8bdca73
title: pbar.py (Statuszeile)
---

## What it is
`pbar.py` zeichnet die Statuszeile von Claude Code auf dem Laptop: die einzelne Textzeile am unteren Rand des Terminals. Während ein Befehl läuft, sieht sie aus wie der Fortschrittsbalken des Paketinstallers `apt`. Sie arbeitet nur lokal: Sie nutzt kein Netzwerk und keine Modell-Tokens (die Einheiten, in denen KI-Nutzung gemessen wird), kostet also nichts.

## What it does
Während ein Shell-Befehl läuft, zeigt sie `Progress: [ 45%]` und einen Balken, geschätzt aus der Dauer, die dasselbe Programm bei früheren Läufen brauchte. Läuft nichts, zeigt sie Ordner, Git-Branch, Modell, Kosten, wie viel des Kontextfensters belegt ist und die Nutzung des 5-Stunden-Limits mit dem Zeitpunkt des Zurücksetzens.

## How it does it
Es gibt zwei Teile. Eine Prüfschleife durchsucht `/proc` (die Linux-Liste der laufenden Programme) nach dem Programm, das jeder Claude-Code-Befehl startet, und lernt typische Dauern, gespeichert in `~/.local/share/claude-pbar/history.json`. Der zweite Teil, `line`, ist der Befehl, den Claude Code für die Statuszeile aufruft ([Dokumentation](https://docs.claude.com/en/docs/claude-code/statusline)); er gibt eine Zeile in der Breite des Terminals aus. Beide werden aus [[claude-code-settings]] gestartet.

## Where it sits in the pipeline
Am unteren Rand jedes Claude-Code-Terminals.

## Who receives its output
Giovanni, der das Terminal beobachtet.
