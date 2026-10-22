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
A private network between Giovanni's devices (a "tailnet") that works through any router; the laptop is `yuji-nitro.tailed3a22.ts.net` on it.

## What it does
Lets the phone reach the laptop over SSH ([[remote-terminal]]) and, through [[tailscale-funnel]], publishes this wiki on the internet.

## How it does it
Installed from Tailscale's signed apt repository by `setup-sudo.sh`; logged in with Giovanni's account.

## Where it sits in the pipeline
Network layer under remote access and the wiki.

## Who receives its output
[[tailscale-funnel]] and the SSH connection from the phone.
