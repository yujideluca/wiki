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
[Tailscale Funnel](https://tailscale.com/kb/1223/funnel) is the Tailscale feature that makes a port of the laptop reachable from the whole internet, at the address `https://yuji-nitro.tailed3a22.ts.net`. A "port" is a numbered door on a computer where a program listens. Giovanni chose Funnel instead of buying a domain name.

## What it does
It receives secure web traffic (HTTPS, Hypertext Transfer Protocol Secure) from anywhere, handles the encryption (TLS, Transport Layer Security; the certificate is managed by Tailscale itself) and forwards the request to the [[wiki-server]] on address 127.0.0.1, port 4180. No port has to be opened on the home router.

## How it does it
The command `tailscale funnel --bg 4180` sets it up and it persists across restarts. It is free and needs no domain. The address works only while the laptop is on and awake.

## Where it sits in the pipeline
Between the internet and the [[wiki-server]], on top of [[tailscale]].

## Who receives its output
The [[wiki-server]].
