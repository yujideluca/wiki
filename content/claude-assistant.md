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
sources: [home:.local/bin/claude-assistant, home:.config/systemd/user/claude-assistant.service, ralexandria:tools/upload-progress.sh]
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the small background service that keeps the [[remote-assistant]] alive. It is a "systemd user service" ([systemd](https://en.wikipedia.org/wiki/Systemd) is the Linux program that starts background services and restarts them if they stop). It was set up on 2026-10-10. The service is named `claude-assistant.service` and runs the script `~/.local/bin/claude-assistant start`.

## What it does
It starts a dedicated [tmux](https://github.com/tmux/tmux/wiki) server (tmux is a "terminal multiplexer": a program that keeps a terminal session running even when no window is showing it). Inside it, in a session called `assistant`, it runs `claude remote-control --name yuji-nitro-assistant` in a restart loop from the folder `~/assistant`. Remote Control is the feature that lets Giovanni talk to this Claude session from the Claude app on the phone. A KDE autostart entry also opens a Konsole window (the KDE terminal) attached to that session, so Giovanni can watch it.

## How it does it
Before each launch the loop waits until the network can resolve names: it runs `getent hosts api.anthropic.com` and retries until it succeeds. This is needed because at boot the service starts before the Wi-Fi is connected, and without a working [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) (Domain Name System, which turns names into network addresses) the launch would fail. tmux is a user-space install. To check it: `systemctl --user status claude-assistant`, and to see the screen: `tmux -L claude capture-pane -p -t assistant`.

**Known limit (2026-11-28): no upload tools by default.** In a Claude Code session that was not started in a terminal (Remote Control, as here, the assistant service, or `claude -p`) the upload tools `Artifact` and `ArtifactData` are switched off by default (seen with Claude Code 2.1.332). The environment variable `CLAUDE_CODE_ARTIFACT=1` switches them on. The Ralexandria project works around this with `tools/upload-progress.sh`, which starts a helper session with the variable set for one run ([[ralexandria]], requirement OR-7). The service's own configuration was not changed: a change of the assistant session's own settings was refused by the permission check. Whether to set the variable for the service itself is open for Giovanni to decide.

## Where it sits in the pipeline
It runs on the [[acer-nitro]] and is enabled at boot (the user's "linger" is on, so no login is needed).

## Who receives its output
The [[remote-assistant]].
