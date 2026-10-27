---
id: laptop-setup
lang: de
source_hash: 1c96429c2c86
title: Laptop-Einrichtung
---

## What it is
Die „Laptop-Einrichtung“ ist die Summe von allem, was auf dem Laptop ([[acer-nitro]]) installiert und konfiguriert ist, damit die Claude-Assistenten arbeiten können. Es ist kein einzelnes Programm, sondern ein Werkzeugkasten: Einstellungen für [[claude-code]], der Hintergrund-Assistent, Hilfswerkzeuge, die Android-Build-Werkzeuge und die Möglichkeit, den Laptop vom Handy aus zu erreichen.

## Flow
trigger t1: Die Assistenten brauchen ein Werkzeug oder eine Einstellung auf dem Laptop | [[acer-nitro]]
decide d1: Braucht der Schritt Administratorrechte?
step s1: Claude installiert es in den eigenen Ordnern des Benutzers | [[user-space-tools]]
step s2: Der Befehl wird Giovanni zum Ausführen übergeben | [[giovanni]]
step s3: Die dauerhafte Tatsache wird im Gedächtnis festgehalten | [[claude-auto-memory]], [[workflow-memory]]
step s4: Claude-Code-Einstellungen und globale Anweisungen | [[claude-code-settings]], [[global-claude-md]]
step s5: Der dauerhaft laufende Assistent und die Statusleiste | [[claude-assistant]], [[pbar]]
step s6: Android-Build-Werkzeuge und Fernzugriff | [[android-toolchain]], [[remote-terminal]]
step s7: machine-bootstrap erfasst die Einrichtung | [[machine-bootstrap]]
product p1: Ein Laptop, bereit für Claude Code, den Fernassistenten und jedes Projekt | [[claude-code]]
product p2: Eine festgehaltene Einrichtung, die nach einer Neuinstallation wiederhergestellt werden kann

t1 -> d1
d1 -nein-> s1
d1 -ja-> s2
s1 -> s3
s2 -> s3
s3 -> s4
s3 -> s5
s3 -> s6
s4 -> p1
s5 -> p1
s6 -> p1
s3 -> s7
s7 -> p2

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

Codex’ globale Anweisungsdatei [[global-codex-agents]] beschreibt Aufgabenfortschritt, Nachweise, Berichte und Abschlussarbeiten bei Änderungen am echten System.
