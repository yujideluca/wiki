---
id: tailscale-funnel
lang: de
source_hash: 4824d15fe304
title: Tailscale Funnel (öffentliche Adresse)
---

## What it is
Die Tailscale-Funktion, die einen Port des Laptops im Internet unter `https://yuji-nitro.tailed3a22.ts.net` veröffentlicht, von Giovanni dem Kauf einer Domain vorgezogen.

## What it does
Nimmt HTTPS von überall an, beendet TLS (das Zertifikat verwaltet Tailscale) und leitet an den [[wiki-server]] auf 127.0.0.1:4180 weiter. Am Router wird kein Port geöffnet.

## How it does it
`tailscale funnel --bg 4180`, bleibt über Neustarts bestehen; kostenlos, keine Domain nötig. Nur online, solange der Laptop an und wach ist.

## Where it sits in the pipeline
Zwischen Internet und [[wiki-server]], auf [[tailscale]] aufbauend.

## Who receives its output
[[wiki-server]].
