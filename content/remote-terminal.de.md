---
id: remote-terminal
lang: de
source_hash: 2befda912399
title: remote-terminal-Einrichtung (SSH + Tailscale)
---

## What it is
`~/dev/remote-terminal/setup-sudo.sh`: die einmalige, wiederholbare Einrichtung, um vom Handy aus das Terminal des Laptops zu erreichen.

## What it does
Installiert OpenSSH-Server, [[tailscale]] und tmux aus offiziellen Repositorys; konfiguriert SSH nur mit Schlüsseln, nur Benutzer `yuji`, kein root und keine Passwörter; fügt den öffentlichen Schlüssel des Handys hinzu, falls angegeben.

## How it does it
Bash, von Giovanni mit sudo ausgeführt (`sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`); `set -euxo pipefail` und `sshd -t` vor dem Neustart. Seit 2026-10-24 ist es ein privates GitHub-Repository (`yujideluca/remote-terminal`) mit Tor, CI und der Pre-Push-Prüfung von [[pipeline-check]].

## Where it sits in the pipeline
Die Grundlage des Fernzugriffs auf den [[acer-nitro]].

## Who receives its output
[[tailscale]] und der SSH-Dienst.
