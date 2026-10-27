---
id: pbar
lang: de
source_hash: 924b86b526fe
title: pbar.py (Statuszeile)
---

## What it is
`pbar.py` zeichnet die Statuszeile von Claude Code auf dem Laptop: die einzelne Textzeile am unteren Rand des Terminals. Während ein Befehl läuft, sieht sie aus wie der Fortschrittsbalken des Paketinstallers `apt`. Sie arbeitet nur lokal: Sie nutzt kein Netzwerk und keine Modell-Tokens (die Einheiten, in denen KI-Nutzung gemessen wird), kostet also nichts.

## Architecture
### Kontext
person g: Giovanni — liest die Zeile am unteren Terminalrand | [[giovanni]]
external cc: Claude Code — zeigt die Statuszeile | [[claude-code]]
external cs: Claude-Code-Einstellungen — starten beide Teile | [[claude-code-settings]]
system p: pbar.py — Fortschrittsbalken und Statuszeile, alles lokal
external pr: Laufende Programme — die Linux-Liste /proc

g -liest die Zeile in-> cc
cs -starten-> p
cc -fragt die Zeile ab bei-> p
p -durchsucht-> pr

### Container
external cs: Claude-Code-Einstellungen | [[claude-code-settings]]
external cc: Claude Code | [[claude-code]]
container lp: Prüfschleife — findet den laufenden Befehl und lernt Dauern
container ln: Befehl line — gibt eine Statuszeile in Terminalbreite aus
store hi: history.json — typische Dauern früherer Läufe
external pr: Laufende Programme (/proc)

cs -startet-> lp
cs -registriert-> ln
cc -ruft auf-> ln
lp -durchsucht-> pr
lp -lernt Dauern in-> hi
ln -liest Dauern aus-> hi

## What it does
Während ein Shell-Befehl läuft, zeigt sie `Progress: [ 45%]` und einen Balken, geschätzt aus der Dauer, die dasselbe Programm bei früheren Läufen brauchte. Läuft nichts, zeigt sie Ordner, Git-Branch, Modell, Kosten, wie viel des Kontextfensters belegt ist und die Nutzung des 5-Stunden-Limits mit dem Zeitpunkt des Zurücksetzens.

## How it does it
Es gibt zwei Teile. Eine Prüfschleife durchsucht `/proc` (die Linux-Liste der laufenden Programme) nach dem Programm, das jeder Claude-Code-Befehl startet, und lernt typische Dauern, gespeichert in `~/.local/share/claude-pbar/history.json`. Der zweite Teil, `line`, ist der Befehl, den Claude Code für die Statuszeile aufruft ([Dokumentation](https://docs.claude.com/en/docs/claude-code/statusline)); er gibt eine Zeile in der Breite des Terminals aus. Beide werden aus [[claude-code-settings]] gestartet.

## Where it sits in the pipeline
Am unteren Rand jedes Claude-Code-Terminals.

## Who receives its output
Giovanni, der das Terminal beobachtet.

Die Codex-Begleitanzeige [[codex-pbar]] passt diese Anzeige an Codex-Sitzungen an.
