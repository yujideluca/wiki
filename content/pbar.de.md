---
id: pbar
lang: de
source_hash: 533620cc5c3f
title: pbar.py (Statuszeile)
aliases: [Fortschrittsbalken]
---

## What it is
Die Statuszeile von Claude Code auf dem Laptop: ein Fortschrittsbalken im Stil der Installationsanzeige von apt. Nur lokal: kein Netz, keine Modell-Tokens.

## What it does
Während ein Shell-Befehl läuft, zeigt sie `Progress: [ 45%]` und einen Balken, geschätzt aus der früheren Laufzeit dieses Programms; läuft nichts, zeigt sie Ordner, Git-Branch, Modell, Kosten, belegten Kontext und 5-Stunden-Nutzung mit Rücksetzzeit.

## How it does it
Zwei Teile: eine Prüfschleife, die `/proc` nach dem Programm jedes Claude-Code-Befehls durchsucht und Laufzeiten lernt (`~/.local/share/claude-pbar/history.json`), und `line`, der statusLine-Befehl, der eine Zeile in Terminalbreite ausgibt. Gestartet über [[claude-code-settings]].

## Where it sits in the pipeline
Am unteren Rand jedes Claude-Code-Terminals.

## Who receives its output
Giovanni, der aufs Terminal schaut.
