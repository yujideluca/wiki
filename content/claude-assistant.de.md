---
id: claude-assistant
lang: de
source_hash: 3a342a0d50f2
title: Dienst claude-assistant
---

## What it is
Das ist der kleine Hintergrunddienst, der den [[remote-assistant]] am Leben hält. Er ist ein „systemd-Benutzerdienst“ ([systemd](https://en.wikipedia.org/wiki/Systemd) ist das Linux-Programm, das Hintergrunddienste startet und neu startet, wenn sie anhalten). Eingerichtet wurde er am 2026-10-10. Der Dienst heißt `claude-assistant.service` und führt das Skript `~/.local/bin/claude-assistant start` aus.

## What it does
Er startet einen eigenen [tmux](https://github.com/tmux/tmux/wiki)-Server (tmux ist ein „Terminal-Multiplexer“: ein Programm, das eine Terminalsitzung weiterlaufen lässt, auch wenn kein Fenster sie anzeigt). Darin führt er in einer Sitzung namens `assistant` in einer Neustart-Schleife `claude remote-control --name yuji-nitro-assistant` aus dem Ordner `~/assistant` aus. Remote Control ist die Funktion, mit der Giovanni vom Handy aus in der Claude-App mit dieser Claude-Sitzung sprechen kann. Ein KDE-Autostart-Eintrag öffnet außerdem ein Konsole-Fenster (das KDE-Terminal), das mit dieser Sitzung verbunden ist, damit Giovanni zusehen kann.

## How it does it
Vor jedem Start wartet die Schleife, bis das Netzwerk Namen auflösen kann: Sie führt `getent hosts api.anthropic.com` aus und wiederholt das bis zum Erfolg. Das ist nötig, weil der Dienst beim Hochfahren startet, bevor das WLAN verbunden ist; ohne funktionierendes [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) (Domain Name System, das Namen in Netzwerkadressen übersetzt) würde der Start scheitern. tmux ist eine User-Space-Installation. Prüfen: `systemctl --user status claude-assistant`; den Bildschirm ansehen: `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
Er läuft auf dem [[acer-nitro]] und ist beim Hochfahren aktiviert („Linger“ des Benutzers ist an, es braucht also keine Anmeldung).

## Who receives its output
Der [[remote-assistant]].
