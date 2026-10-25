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
reviewed: 2026-10-25T02:05Z
---

## What it is
`~/dev/remote-terminal/setup-sudo.sh` is a one-time setup script (it can safely be run again) that makes it possible to open the laptop's terminal from the phone. A terminal is the text window where commands are typed; reaching it remotely means Giovanni can run commands on the laptop from anywhere.

## What it does
It installs three things from official sources: an OpenSSH server (the program that accepts [SSH](https://en.wikipedia.org/wiki/Secure_Shell), Secure Shell, encrypted remote logins), [[tailscale]] (a private network between Giovanni's devices) and tmux (a terminal that keeps running when you disconnect). It then locks SSH down: only keys (no passwords), only the user `yuji`, no root login. If given the phone's public key, it authorises the phone.

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script that Giovanni runs with administrator rights: `sudo bash ~/dev/remote-terminal/setup-sudo.sh ["ssh-ed25519 … phone"]`. It stops at the first error (`set -euxo pipefail`) and checks the SSH configuration with `sshd -t` before restarting the service, so a typo cannot lock Giovanni out. Since 2026-10-24 it is a GitHub repository (`yujideluca/remote-terminal`, public since 2026-10-25) with a quality gate, continuous integration (CI, automatic checks that run on every push) and the [[pipeline-check]] pre-push check. The script is tested in a throwaway sandbox (`tests/setup-sudo-sandbox.sh`, built on bubblewrap, a Linux tool that fakes a private root folder) where apt, systemctl, sshd and tailscale are stand-ins, so nothing on the real system changes; the test covers a bad key, a good key, a second run and running without administrator rights.

## Where it sits in the pipeline
It is the base of all remote access to the [[acer-nitro]].

## Who receives its output
[[tailscale]] and the SSH service.
