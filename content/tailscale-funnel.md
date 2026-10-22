---
id: tailscale-funnel
title: Tailscale Funnel (public address)
aliases: [funnel, ts.net address]
kind: service
project: wiki
status: active
fed_by: [tailscale]
feeds: [wiki-server]
reviewed: 2026-10-22
---

## What it is
The Tailscale feature that publishes a port of the laptop on the internet at `https://yuji-nitro.tailed3a22.ts.net`, chosen by Giovanni over buying a domain.

## What it does
Receives HTTPS from anywhere, terminates TLS (the certificate is managed by Tailscale) and forwards to the [[wiki-server]] on 127.0.0.1:4180. No router port is opened.

## How it does it
`tailscale funnel --bg 4180`, persistent across reboots; free, no domain needed. Online only while the laptop is on and awake.

## Where it sits in the pipeline
Between the internet and [[wiki-server]], on top of [[tailscale]].

## Who receives its output
[[wiki-server]].
