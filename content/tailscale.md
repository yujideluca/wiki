---
id: tailscale
title: Tailscale
aliases: [tailnet, VPN]
kind: service
project: laptop-setup
status: active
fed_by: [remote-terminal]
feeds: [tailscale-funnel]
reviewed: 2026-10-22
---

## What it is
[Tailscale](https://tailscale.com/) creates a private network between Giovanni's own devices, called a "tailnet" (a kind of [virtual private network](https://en.wikipedia.org/wiki/Virtual_private_network), VPN: an encrypted link that makes distant devices behave as if they were on the same local network). It works through any home router without special settings. On it, the laptop is reachable as `yuji-nitro.tailed3a22.ts.net`.

## What it does
It lets the phone reach the laptop over SSH (Secure Shell, an encrypted remote login; see [[remote-terminal]]), and through its Funnel feature ([[tailscale-funnel]]) it publishes this wiki on the internet.

## How it does it
It was installed from Tailscale's signed apt repository by the script `setup-sudo.sh`, and the laptop is logged in with Giovanni's account.

## Where it sits in the pipeline
The network layer underneath remote access and the wiki.

## Who receives its output
[[tailscale-funnel]] and the SSH connection from the phone.
