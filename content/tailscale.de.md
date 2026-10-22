---
id: tailscale
lang: de
source_hash: b0656788e52a
title: Tailscale
---

## What it is
Ein privates Netz zwischen Giovannis Geräten (ein „Tailnet“), das durch jeden Router funktioniert; der Laptop ist darin `yuji-nitro.tailed3a22.ts.net`.

## What it does
Lässt das Handy per SSH auf den Laptop zugreifen ([[remote-terminal]]) und veröffentlicht über [[tailscale-funnel]] dieses Wiki im Internet.

## How it does it
Aus dem signierten apt-Repository von Tailscale per `setup-sudo.sh` installiert; mit Giovannis Konto angemeldet.

## Where it sits in the pipeline
Netzwerkschicht unter Fernzugriff und Wiki.

## Who receives its output
[[tailscale-funnel]] und die SSH-Verbindung vom Handy.
