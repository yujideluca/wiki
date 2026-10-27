---
id: remote-terminal
lang: de
source_hash: c5f05afb3703
title: remote-terminal-Einrichtung (SSH + Tailscale)
---

## What it is
`~/dev/remote-terminal/setup-sudo.sh` ist ein einmaliges Einrichtungsskript (es darf gefahrlos erneut laufen), mit dem man das Terminal des Laptops vom Handy aus öffnen kann. Ein Terminal ist das Textfenster, in dem Befehle eingetippt werden; es aus der Ferne zu erreichen heißt, dass Giovanni von überall Befehle auf dem Laptop ausführen kann.

## What it does
Es installiert drei Dinge aus offiziellen Quellen: einen OpenSSH-Server (das Programm, das [SSH](https://en.wikipedia.org/wiki/Secure_Shell), Secure Shell, verschlüsselte Fernanmeldungen annimmt), [[tailscale]] (ein privates Netzwerk zwischen Giovannis Geräten) und tmux (ein Terminal, das beim Trennen weiterläuft). Danach sperrt es SSH ab: nur Schlüssel (keine Passwörter), nur der Benutzer `yuji`, keine Root-Anmeldung. Wird der öffentliche Schlüssel des Handys mitgegeben, erlaubt es das Handy.

## How it does it
Es ist ein [Bash](https://www.gnu.org/software/bash/)-Skript, das Giovanni mit Administratorrechten ausführt: `sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`. Es hält beim ersten Fehler an (`set -euxo pipefail`) und prüft die SSH-Konfiguration mit `sshd -t`, bevor es den Dienst neu startet, damit ein Tippfehler Giovanni nicht aussperren kann. Seit 2026-10-24 ist es ein GitHub-Repository (`yujideluca/remote-terminal`, seit 2026-10-25 öffentlich) mit Quality Gate, Continuous Integration (CI, automatische Prüfungen bei jedem Push) und der [[pipeline-check]]-Prüfung vor dem Push. Das Skript wird in einer Wegwerf-Sandbox getestet (`tests/setup-sudo-sandbox.sh`, auf Basis von bubblewrap, einem Linux-Werkzeug, das einen privaten Wurzelordner vortäuscht); apt, systemctl, sshd und tailscale sind dort Attrappen, das echte System bleibt unverändert. Geprüft werden ein falscher Schlüssel, ein richtiger Schlüssel, ein zweiter Lauf und der Start ohne Administratorrechte.

## Where it sits in the pipeline
Es ist die Grundlage des gesamten Fernzugriffs auf den [[acer-nitro]].

## Who receives its output
[[tailscale]] und der SSH-Dienst.

## Notes
Am 2026-10-27 verband sich Termux (die Android-Terminal-App) auf dem Motorola edge 50 fusion über dasselbe WLAN mit dem Laptop. Termux hatte zunächst keinen eigenen Anmeldeschlüssel; die Anmeldung scheiterte mit `Permission denied (publickey)`. Auf diesem Handy wurde ein neues Ed25519-Schlüsselpaar erstellt. Nur der öffentliche Teil wurde der Datei `~/.ssh/authorized_keys` des Laptops hinzugefügt, der Liste der zur Anmeldung zugelassenen Schlüssel. Der private Teil bleibt auf dem Handy. Der ältere zugelassene Schlüssel blieb erhalten.

Nach der Anmeldung öffnete `tmux -L codex-status attach-session -t codex-f650038b2a0e` das laufende [[codex]]-Gespräch auf dem Handy. Der Handybildschirm und zwei verbundene Terminal-Clients bestätigten die Verbindung. Der Sitzungsname gilt nur für dieses Gespräch. Diese Prüfung bestätigt den lokalen WLAN-Zugang auf diesem Handy; der Zugang aus einem anderen Netzwerk und die separate Codex-Kopplung wurden nicht verifiziert.
