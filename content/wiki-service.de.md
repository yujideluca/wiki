---
id: wiki-service
lang: de
source_hash: 9bdbf96d15ac
title: wiki.service (systemd)
---

## What it is
Das ist die systemd-Benutzereinheit (eine Konfiguration für [systemd](https://en.wikipedia.org/wiki/Systemd), das Linux-Programm, das Hintergrunddienste startet und überwacht), die den [[wiki-server]] auf dem Laptop am Laufen hält.

## What it does
Sie startet das Elixir-Release beim Hochfahren („Linger“ des Benutzers ist an, es braucht also keine Anmeldung), startet es neu, wenn es anhält, und lädt die Geheimnisse aus `~/.config/wiki/oauth.env` und `secret.env`.

## How it does it
Zum Prüfen `systemctl --user status wiki` ausführen; um die Logs zu lesen `journalctl --user -u wiki`.

## Where it sits in the pipeline
Auf dem [[acer-nitro]], unter dem [[tailscale-funnel]].

## Who receives its output
Der [[wiki-server]].
