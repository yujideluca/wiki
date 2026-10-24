---
id: tailscale
lang: de
source_hash: d41f39d9fb2b
title: Tailscale
---

## What it is
[Tailscale](https://tailscale.com/) erzeugt ein privates Netzwerk zwischen Giovannis eigenen Geräten, ein „Tailnet“ (eine Art [virtuelles privates Netzwerk](https://en.wikipedia.org/wiki/Virtual_private_network), VPN: eine verschlüsselte Verbindung, durch die weit entfernte Geräte sich verhalten, als wären sie im selben lokalen Netz). Es funktioniert hinter jedem Heimrouter ohne Spezialeinstellungen. Darin ist der Laptop als `yuji-nitro.tailed3a22.ts.net` erreichbar.

## What it does
Es lässt das Handy den Laptop über SSH (Secure Shell, eine verschlüsselte Fernanmeldung; siehe [[remote-terminal]]) erreichen und veröffentlicht mit seiner Funktion Funnel ([[tailscale-funnel]]) dieses Wiki im Internet.

## How it does it
Es wurde vom Skript `setup-sudo.sh` aus dem signierten apt-Repository von Tailscale installiert, und der Laptop ist mit Giovannis Konto angemeldet.

## Where it sits in the pipeline
Die Netzwerkschicht unter dem Fernzugriff und dem Wiki.

## Who receives its output
[[tailscale-funnel]] und die SSH-Verbindung vom Handy.
