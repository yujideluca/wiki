---
id: acer-nitro
title: The laptop (Acer Nitro, yuji-nitro)
aliases: [laptop, yuji-nitro, Kubuntu]
kind: external
project: laptop-setup
status: active
fed_by: []
feeds: [machine-bootstrap]
reviewed: 2026-10-24
---

## What it is
This is Giovanni's laptop: an Acer Nitro with an Nvidia graphics card, running [Kubuntu](https://kubuntu.org/) (a version of the [Linux](https://en.wikipedia.org/wiki/Linux) operating system with the KDE Plasma desktop). On the network it is called `yuji-nitro`. Almost everything in this wiki lives on it: the project folders in `~/dev` (the `~` means Giovanni's home folder), the Claude programs, and the web server of this wiki.

## What it does
It is the machine where the work happens. It runs [[claude-code]] (the AI assistant that writes the code), the always-on [[claude-assistant]], the builds and tests of every project, and the server of this wiki ([[wiki-service]]). When the laptop is off or asleep, none of these run, so this wiki is unreachable then.

## How it does it
The user account has "linger" switched on. Normally a user's background programs stop when they log out; with linger they keep running without anyone logged in, which is what lets the services above start at boot. Problems with the laptop itself (screen, drivers, sound, network) are handled with the skill [[skill-reparo-kubuntu]], and each fix is made permanent so it survives a restart. The desktop runs on [Wayland](https://wayland.freedesktop.org/) (the system that draws windows on screen) with Plasma 6 and four virtual desktops (separate work areas). Win+1…4 switch to a desktop, and Win+Shift+1…4 send the focused window to it. On Giovanni's Brazilian keyboard layout the second set must be saved as Win+!, Win+@, Win+# and Win+$, because Shift+1…4 types those symbols; they live in KDE's file `~/.config/kglobalshortcutsrc`.

## Where it sits in the pipeline
The "pipeline" in this wiki is the chain of steps work passes through. The laptop is the ground floor under all of it: the project [[laptop-setup]] describes what is installed on it, and everything else runs on top. The tool [[machine-bootstrap]] records this laptop's setup so it can be rebuilt after a reinstall.

## Who receives its output
Every Claude instance that runs locally (see [[claude-code]] and [[remote-assistant]]), and every project that is built on it.
