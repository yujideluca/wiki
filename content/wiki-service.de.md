---
id: wiki-service
lang: de
source_hash: 538b5e944626
title: wiki.service (systemd)
---

## What it is
Die systemd-Benutzereinheit, die den [[wiki-server]] auf dem Laptop am Laufen hält.

## What it does
Startet das Elixir-Release beim Booten (Linger ist an, keine Anmeldung nötig), startet es neu, wenn es stoppt, und lädt die Geheimnisse aus `~/.config/wiki/oauth.env` und `secret.env`.

## How it does it
Prüfen mit `systemctl --user status wiki`; Protokolle mit `journalctl --user -u wiki`.

## Where it sits in the pipeline
Auf dem [[acer-nitro]], unter [[tailscale-funnel]].

## Who receives its output
[[wiki-server]].
