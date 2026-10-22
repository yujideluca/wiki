---
id: remote-terminal
title: remote-terminal setup (SSH + Tailscale)
aliases: [setup-sudo.sh, phone terminal]
kind: script
project: laptop-setup
status: active
location: remote-terminal:setup-sudo.sh
fed_by: []
feeds: [tailscale]
sources: [remote-terminal:setup-sudo.sh]
---

## What it is
`~/dev/remote-terminal/setup-sudo.sh`: the one-time, re-runnable setup for reaching the laptop's terminal from the phone.

## What it does
Installs OpenSSH server, [[tailscale]] and tmux from official repositories; configures SSH for keys only, only user `yuji`, no root and no passwords; adds the phone's public key if given.

## How it does it
Bash run with sudo by Giovanni (`sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`); `set -euxo pipefail` and `sshd -t` before restarting.

## Where it sits in the pipeline
The base of remote access to the [[acer-nitro]].

## Who receives its output
[[tailscale]] and the SSH service.
