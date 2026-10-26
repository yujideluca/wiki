---
id: remote-assistant
lang: de
source_hash: 2a75b28e07de
title: Remote-Assistent
---

## What it is
Der Remote-Assistent ist eine Claude-Code-Sitzung, die ständig auf dem Laptop läuft und die [[giovanni]] über die Funktion Remote Control aus der Claude-App auf dem Handy erreichen kann. In der App erscheint sie als `yuji-nitro-assistant`. Man kann sie sich als zweite Tür in denselben Laptop vorstellen: dasselbe Claude, dieselben Repositories, aber von überall erreichbar.

## What it does
Er erledigt kurze Aufgaben auf dem Laptop, während Giovanni nicht davorsitzt. Er folgt denselben Regeln wie [[claude-code]] und schreibt unter dem Instanznamen `assistant` ins gemeinsame Gedächtnis, damit dieses erkennen kann, wer was geschrieben hat.

## How it does it
Der Dienst [[claude-assistant]] hält ihn am Leben: Eine tmux-Sitzung (ein Terminal, das ohne Fenster weiterläuft) führt in einer Neustart-Schleife `claude remote-control` aus dem Ordner `~/assistant` aus. Dieser Ordner hat eine eigene CLAUDE.md (eine Textdatei mit dauerhaften Anweisungen, die Claude Code beim Start liest), die kurze, auf dem Handy gut lesbare Antworten verlangt. Seinen Berechtigungsmodus (wie viel Claude ohne Nachfrage tun darf) hat Giovanni persönlich festgelegt.

## Where it sits in the pipeline
Er ist ein zweiter Eingang in denselben Laptop und dieselben Projekt-Repositories wie Claude Code; der Unterschied liegt nur darin, wie Giovanni zu ihm kommt.

## Who receives its output
Dieselben Empfänger wie bei [[claude-code]]: die Projekt-Repositories und das Gedächtnisprotokoll [[events-log]] (Einträge tragen die Markierung `MEM_INSTANCE=assistant`).

## Notes

### Codex-Fernsteuerung
Codex ist ein weiterer Programmierassistent auf diesem Laptop. Sein eigener Dienst `codex-remote-tmux.service` verwendet systemd, das Linux-Programm zur Verwaltung von Hintergrunddiensten, um `~/.local/bin/codex-remote-tmux start` auszuführen. Das Skript hält mit tmux ein Terminal ohne sichtbares Fenster am Laufen. Es verwendet den eigenen tmux-Socket `codex-remote` und die Sitzung `remote`; gestartet wird im persönlichen Ordner.

Die Aktion `run` führt wiederholt `codex remote-control --no-daemon` aus. Endet dieser Befehl, auch mit einem Fehler, wartet das Skript vor dem nächsten Versuch 15 Sekunden. Der Dienst enthält `Restart=always` und `RestartSec=15`. Es gibt zwei getrennte Wiederholungsebenen: Das Skript wiederholt den Befehl, systemd startet den Dienst neu. `start` lässt eine vorhandene Sitzung unverändert; `attach` öffnet ihr Terminal; `stop` beendet diese Sitzung. Ohne Argument verbindet sich das Skript mit dem Terminal.

Das Installationsskript `~/Documents/Codex/2026-10-25/i-w/outputs/install-codex-remote.sh` sichert vorhandene Skript- und Dienstdateien, schreibt sie, prüft ihre Syntax, lädt systemd neu und aktiviert und startet den Dienst für das Standardziel des Benutzers. Der im Skript angegebene Kopplungsbefehl lautet `codex remote-control pair`; das Terminal lässt sich mit `codex-remote-tmux attach` öffnen.

Bei dieser Prüfung stimmten das installierte Skript und der Dienst mit dem Installationsskript überein. Laufender Dienst und Handyverbindung wurden nicht bestätigt: Die Sandbox verweigerte den Zugriff auf den Benutzerdienst-Bus und den tmux-Socket. Der Dienst wurde weder neu gestartet noch geändert. Das Codex-Skript setzt Claudes Kennzeichnung `MEM_INSTANCE=assistant` nicht.
