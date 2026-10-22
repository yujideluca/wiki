---
id: claude-assistant
lang: de
source_hash: b32979a126fb
title: Dienst claude-assistant
aliases: [Remote-Control-Dienst]
---

## What it is
Der systemd-Benutzerdienst, der den [[remote-assistant]] am Laufen hält (eingerichtet am 10.10.2026): `claude-assistant.service` → `~/.local/bin/claude-assistant start`.

## What it does
Startet einen eigenen tmux-Server (Socket `claude`, Sitzung `assistant`), der `claude remote-control --name yuji-nitro-assistant` in einer Neustart-Schleife aus `~/assistant` ausführt. Ein KDE-Autostart-Eintrag öffnet ein angehängtes Konsole-Fenster.

## How it does it
Die Schleife wartet vor jedem Start auf DNS (`getent hosts api.anthropic.com`), weil der Dienst beim Booten vor dem WLAN startet. tmux ist im Benutzerbereich installiert. Prüfen mit `systemctl --user status claude-assistant` und `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
Auf dem [[acer-nitro]], beim Booten aktiv (Linger an).

## Who receives its output
[[remote-assistant]].
