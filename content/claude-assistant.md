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
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the small background service that keeps the [[remote-assistant]] alive. It is a "systemd user service" ([systemd](https://en.wikipedia.org/wiki/Systemd) is the Linux program that starts background services and restarts them if they stop). It was set up on 2026-10-10. The service is named `claude-assistant.service` and runs the script `~/.local/bin/claude-assistant start`.

## What it does
It starts a dedicated [tmux](https://github.com/tmux/tmux/wiki) server (tmux is a "terminal multiplexer": a program that keeps a terminal session running even when no window is showing it). Inside it, in a session called `assistant`, it runs `claude remote-control --name yuji-nitro-assistant` in a restart loop from the folder `~/assistant`. Remote Control is the feature that lets Giovanni talk to this Claude session from the Claude app on the phone. A KDE autostart entry also opens a Konsole window (the KDE terminal) attached to that session, so Giovanni can watch it.

## How it does it
Before each launch the loop waits until the network can resolve names: it runs `getent hosts api.anthropic.com` and retries until it succeeds. This is needed because at boot the service starts before the Wi-Fi is connected, and without a working [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) (Domain Name System, which turns names into network addresses) the launch would fail. tmux is a user-space install. To check it: `systemctl --user status claude-assistant`, and to see the screen: `tmux -L claude capture-pane -p -t assistant`.

## Where it sits in the pipeline
It runs on the [[acer-nitro]] and is enabled at boot (the user's "linger" is on, so no login is needed).

## Who receives its output
The [[remote-assistant]].
