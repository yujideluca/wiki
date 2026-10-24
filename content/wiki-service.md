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
This is the systemd user unit (a configuration for [systemd](https://en.wikipedia.org/wiki/Systemd), the Linux program that starts and watches background services) that keeps the [[wiki-server]] running on the laptop.

## What it does
It starts the Elixir release at boot (the user's "linger" is on, so no login is needed), restarts it if it stops, and loads the secrets from `~/.config/wiki/oauth.env` and `secret.env`.

## How it does it
To check it, run `systemctl --user status wiki`; to read its logs, run `journalctl --user -u wiki`.

## Where it sits in the pipeline
On the [[acer-nitro]], underneath the [[tailscale-funnel]].

## Who receives its output
The [[wiki-server]].
