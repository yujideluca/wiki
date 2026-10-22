---
id: wiki-service
title: wiki.service (systemd)
aliases: [wiki service]
kind: service
project: wiki
status: active
location: home:.config/systemd/user/wiki.service
fed_by: [google-oauth-client]
feeds: [wiki-server]
sources: [wiki:tools/wiki.service]
---

## What it is
The systemd user unit that keeps the [[wiki-server]] running on the laptop.

## What it does
Starts the Elixir release at boot (linger is on, so no login is needed), restarts it if it stops, and loads the secrets from `~/.config/wiki/oauth.env` and `secret.env`.

## How it does it
`systemctl --user status wiki` to check; logs with `journalctl --user -u wiki`.

## Where it sits in the pipeline
On the [[acer-nitro]], under [[tailscale-funnel]].

## Who receives its output
[[wiki-server]].
