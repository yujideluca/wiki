---
id: claude-assistant
title: claude-assistant service
aliases: [claude-assistant.service, Remote Control service]
kind: service
project: laptop-setup
status: active
location: home:.local/bin/claude-assistant
fed_by: [user-space-tools]
feeds: [remote-assistant]
sources: [home:.local/bin/claude-assistant, home:.config/systemd/user/claude-assistant.service]
---

## What it is
The systemd user service that keeps the [[remote-assistant]] running (set up 2026-10-10): `claude-assistant.service` → `~/.local/bin/claude-assistant start`.

## What it does
Starts a dedicated tmux server (socket `claude`, session `assistant`) running `claude remote-control --name yuji-nitro-assistant` in a restart loop from `~/assistant`. A KDE autostart entry opens a Konsole window attached to it.

## How it does it
The run loop waits for DNS (`getent hosts api.anthropic.com`) before each launch, because at boot the service starts before Wi-Fi. tmux is a user-space install. Check with `systemctl --user status claude-assistant` and `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
On the [[acer-nitro]], enabled at boot (linger on).

## Who receives its output
[[remote-assistant]].
