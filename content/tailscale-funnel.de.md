---
id: tailscale-funnel
lang: de
source_hash: 2e96d8b2d9ad
title: Tailscale Funnel (öffentliche Adresse)
---

## What it is
[Tailscale Funnel](https://tailscale.com/kb/1223/funnel) ist die Tailscale-Funktion, die einen Port des Laptops aus dem gesamten Internet erreichbar macht, unter der Adresse `https://yuji-nitro.tailed3a22.ts.net`. Ein „Port“ ist eine nummerierte Tür eines Computers, an der ein Programm lauscht. Giovanni hat sich für Funnel statt für den Kauf eines Domainnamens entschieden.

## What it does
Es nimmt sicheren Webverkehr (HTTPS, Hypertext Transfer Protocol Secure) von überall entgegen, übernimmt die Verschlüsselung (TLS, Transport Layer Security; das Zertifikat verwaltet Tailscale selbst) und leitet die Anfrage an den [[wiki-server]] auf Adresse 127.0.0.1, Port 4180 weiter. Am Heimrouter muss kein Port geöffnet werden.

## How it does it
Der Befehl `tailscale funnel --bg 4180` richtet es ein, und es bleibt über Neustarts hinweg bestehen. Es ist kostenlos und braucht keine Domain. Die Adresse funktioniert nur, solange der Laptop an und wach ist.

## Where it sits in the pipeline
Zwischen dem Internet und dem [[wiki-server]], auf [[tailscale]] aufgesetzt.

## Who receives its output
Der [[wiki-server]].
