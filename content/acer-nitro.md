---
id: acer-nitro
title: The laptop (Acer Nitro, yuji-nitro)
aliases: [laptop, yuji-nitro, Kubuntu]
kind: external
project: laptop-setup
status: active
fed_by: []
feeds: [machine-bootstrap, claude-scratch-review]
reviewed: 2026-11-08T14:41Z
---

## What it is
This is Giovanni's laptop: an Acer Nitro with an Nvidia graphics card, running [Kubuntu](https://kubuntu.org/) (a version of the [Linux](https://en.wikipedia.org/wiki/Linux) operating system with the KDE Plasma desktop). On the network it is called `yuji-nitro`. Almost everything in this wiki lives on it: the project folders in `~/dev` (the `~` means Giovanni's home folder), the Claude programs, and the web server of this wiki.

Checked on 2026-11-05: the system is Ubuntu 26.04.1 LTS with kernel 7.0.0-38-generic, and the desktop is KDE Plasma 6.6.6 in a Wayland session.

## What it does
It is the machine where the work happens. It runs [[claude-code]] (the AI assistant that writes the code), the always-on [[claude-assistant]], the builds and tests of every project, and the server of this wiki ([[wiki-service]]). When the laptop is off or asleep, none of these run, so this wiki is unreachable then.

## How it does it
The user account has "linger" switched on. Normally a user's background programs stop when they log out; with linger they keep running without anyone logged in, which is what lets the services above start at boot. Problems with the laptop itself (screen, drivers, sound, network) are handled with the skill [[skill-reparo-kubuntu]], and each fix is made permanent so it survives a restart. The desktop runs on [Wayland](https://wayland.freedesktop.org/) (the system that draws windows on screen) with Plasma 6 and four virtual desktops (separate work areas). Win+1…4 switch to a desktop, and Win+Shift+1…4 send the focused window to it. On Giovanni's Brazilian keyboard layout the second set must be saved as Win+!, Win+@, Win+# and Win+$, because Shift+1…4 types those symbols; they live in KDE's file `~/.config/kglobalshortcutsrc`.

The laptop has 23 GB of RAM (the fast working memory) and two SSDs (solid-state drives). The main 1 TB one holds the system, `~/dev` and most Steam games. The second 512 GB one (`/dev/nvme0n1p1`) is mounted at every boot at `/run/media/yuji/c202ac7d-57a0-4474-9091-b25ed7af6220` through a line in `/etc/fstab` (the list of drives mounted at boot), added on 2026-11-08 with the option `nofail`, so the laptop still starts if that drive is missing; the previous file is kept as `/etc/fstab.bak-2026-11-08`. On 2026-11-08 the main drive was 94% full, and Giovanni's films and series were moved to the second drive to free space: `Media/Videos` and `Media/Anime` on that drive. `~/Anime` is now a shortcut (a symbolic link: a small file that points to another folder) to the moved Anime folder, and `~/Videos` holds two shortcuts, "Videos (second drive)" and "Anime (second drive)". Steam (installed as a snap, a sandboxed package that may only reach other drives through its `removable-media` permission, which is on) has a second game library at `SteamLibrary` on that drive, for new games. Some video files were unfinished downloads that are mostly empty space; copying them filled the empty parts with zeros, and `fallocate --dig-holes` (a command that gives empty parts back to the disk) shrank them again. `/tmp` is a "tmpfs", a folder kept in RAM, capped at about 11.6 GB, so Claude's scratch files there use memory; the job [[claude-scratch-review]] moves or deletes old ones. Since 2026-11-05 the swap (disk space used as overflow memory) is one file, `/swapfile`, of 30 GB on the main SSD, with swappiness 30 (how readily the system moves idle memory to swap; the default is 60). It replaced a 512 MB file that was full. The script that made the change is `~/setup-swap-30g.sh` and it needs `sudo`.

## Where it sits in the pipeline
The "pipeline" in this wiki is the chain of steps work passes through. The laptop is the ground floor under all of it: the project [[laptop-setup]] describes what is installed on it, and everything else runs on top. The tool [[machine-bootstrap]] records this laptop's setup so it can be rebuilt after a reinstall.

## Who receives its output
Every Claude instance that runs locally (see [[claude-code]] and [[remote-assistant]]), and every project that is built on it.
