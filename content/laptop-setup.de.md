---
id: laptop-setup
lang: de
source_hash: b7433f29aaae
title: Laptop-Einrichtung
---

## What it is
Die „Laptop-Einrichtung“ ist die Summe von allem, was auf dem Laptop ([[acer-nitro]]) installiert und konfiguriert ist, damit die Claude-Assistenten arbeiten können. Es ist kein einzelnes Programm, sondern ein Werkzeugkasten: Einstellungen für [[claude-code]], der Hintergrund-Assistent, Hilfswerkzeuge, die Android-Build-Werkzeuge und die Möglichkeit, den Laptop vom Handy aus zu erreichen.

## What it does
Sie bildet den Boden, auf dem jedes Projekt steht. Die Teile sind: die Einstellungen und Anweisungen von Claude Code ([[claude-code-settings]], [[global-claude-md]]), der dauerhaft laufende Dienst [[claude-assistant]], die Statusleiste [[pbar]], der Telegram-Sender [[tg-send]], die Android-Build-Werkzeuge ([[android-toolchain]]), die zusätzlichen Werkzeuge in `~/.local` ([[user-space-tools]]), das private Netzwerk [[tailscale]] und der sichere Fernzugang [[remote-terminal]].

## How it does it
Die meisten Installationen sind „User-Space“: Sie liegen in den eigenen Ordnern des Benutzers (`~/.local` und `~/dev`) statt in Systemordnern und brauchen deshalb keine Administratorrechte (kein `sudo`, der Befehl, der etwas als Administrator ausführt). Die wenigen Schritte, die Administratorrechte brauchen, übergibt Claude an Giovanni. Dauerhafte Fakten zur Einrichtung stehen in [[claude-auto-memory]] und im gemeinsamen Gedächtnis [[workflow-memory]].

## Where it sits in the pipeline
Unter allen anderen Projekten: [[quizapp]] wird mit seiner Werkzeugkette gebaut, das Wiki läuft als einer ihrer Dienste, und der Assistent lebt in ihrem Dienstmanager (systemd, das Linux-Programm, das Hintergrunddienste startet und überwacht).

## Who receives its output
[[claude-code]], der [[remote-assistant]] und jedes Projekt in `~/dev`.

Die Codex-Begleitanzeige [[codex-pbar]] passt diese Anzeige an Codex-Sitzungen an.

Das Terminal nutzt [[codex-status-line]] für Codex-Nutzungskontingente und Kontextgröße. [[machine-bootstrap]] zeichnet die Einrichtung des Laptops auf und kann sie nach einer Neuinstallation wiederherstellen.
