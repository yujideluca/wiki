---
id: claude-auto-memory
lang: de
source_hash: 93ac45292bea
title: Auto-Gedächtnis von Claude Code
---

## What it is
Claude Code hat ein kleines eigenes Gedächtnis, getrennt vom gemeinsamen. Es ist ein Ordner mit kurzen Textdateien, ein Fakt pro Datei, plus eine Indexdatei namens `MEMORY.md`. Es wird für Chats verwendet, die im Home-Ordner gestartet werden, und der Index wird an den Anfang jedes solchen Chats geladen. Das ist das „Auto-Memory“ aus dem [Claude-Code-Leitfaden zum Gedächtnis](https://docs.claude.com/en/docs/claude-code/memory).

## What it does
Es enthält Notizen, die nur auf diesem Laptop wichtig sind: wie man den Remote-Assistenten prüft, das Projekt German Quiz, wo die User-Space-Werkzeuge installiert sind, die Regel, dass Code vor der Fertigmeldung debuggt werden muss, die Tatsache, dass ein bestimmter Hinweis zu einer Skill für deutsche Gespräche nicht für Claude Code gedacht ist, und dass der Dienst für globale Tastenkürzel des Desktops im Fenstermanager (kwin) lebt, sodass eine falsche Nachricht über DBus (das System, mit dem die Desktop-Programme miteinander sprechen) das Programm zum Zeichnen des Desktops abstürzen lassen kann. Außerdem hält es eine Notiz fest, warum eine Erinnerung des Stop-Hooks des Wikis ([[wiki-hook-stop]]) nicht befolgt wurde, weil die markierten Seiten zur unfertigen Arbeit einer anderen Sitzung gehörten, und eine Notiz zur geplanten Seite für den Radiologie-Befundabgleich (bisherige Entscheidungen, Recherche steht noch aus).

Eine weitere Notiz vom 2026-11-05 verweist auf das Werkzeug und die Methode, um die Geschwindigkeit der Karte dieses Wikis zu messen (das Werkzeug liegt in `~/dev/wiki-bench`, die Methode in `docs/MEASURING-THE-MAP.md` im Wiki-Repository), und nennt die Fallen, die falsche Zahlen lieferten: ein gedrosselter Animations-Frame-Timer, Software-Rendering und Drift der Maschine zwischen den Läufen.

## How it does it
Claude Code schreibt diese Dateien selbst in einem festen Format (eine kleine Kopfzeile, der Fakt, warum er wichtig ist, wie man ihn anwendet). Regeln, die alle Claude-Instanzen teilen müssen, gehören nicht hierher, sondern ins gemeinsame Gedächtnis [[workflow-memory]].

## Where it sits in the pipeline
Wird zu Beginn eines Chats geladen ([[chat-start]]), neben den Anweisungen aus [[global-claude-md]].

## Who receives its output
[[claude-code]].
