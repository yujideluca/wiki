---
id: backup-ssd
title: Backup of personal files to the external SSD
aliases: [backup-ssd.sh, SSD backup, backup-acer]
kind: script
project: laptop-setup
status: active
location: home:dev/scripts/backup-ssd.sh
fed_by: []
feeds: []
sources: [home:dev/scripts/backup-ssd.sh]
reviewed: 2026-11-27T16:34Z
---

## What it is
`backup-ssd.sh` is a short shell script (a text file of commands that the computer runs one after the other) that copies Giovanni's personal files from the laptop ([[acer-nitro]]) to an external drive: a Kingston 1 TB portable SSD (solid-state drive, a disk with no moving parts) that plugs into a USB (Universal Serial Bus) port. A backup is a second copy of your files kept somewhere else, so that if the laptop breaks, is lost or has its disk wiped, nothing important is gone. The script lives in `~/dev/scripts/` (the `~` means Giovanni's home folder). It belongs to the laptop's setup, see [[laptop-setup]].

## What it does
It copies the chosen files and folders into the folder `backup-acer/home/` on the SSD, keeping the same paths as in the home folder. For example `~/Documents` ends up as `backup-acer/home/Documents`.

What is copied:
- the personal folders Documents, Pictures, Downloads, Desktop, Music, Templates, `archive`, `assistant`, `kde_backup`, `sketchbook` and `dl`;
- secrets and identity: `.ssh` (the keys used to log in to other computers over Secure Shell), `.gnupg` (encryption keys) and the saved passwords of the desktop (`.local/share/keyrings`);
- the settings of Claude Code: its memory (`.claude/projects`), `CLAUDE.md`, `settings.json` and the skills folder;
- the shell settings `.bashrc` and `.profile` (files that set up the command line) and `.gitconfig` (the settings of the Git version-control tool);
- `dev`, the folder with all of Giovanni's software projects;
- one work folder with subtitles for Star Trek: The Next Generation.

What is left out on purpose, because it can be made again or downloaded again:
- build leftovers that a program can regenerate: `node_modules`, `.gradle`, `build/`, `target/`, virtual environments (`.venv`, `venv/`, isolated copies of Python libraries), `__pycache__`, `.cache`, `dev/android-sdk` and `.kotlin`;
- big media that can be downloaded again: the Videos folder (99 GB), the 320 GB Media folder on the laptop's second internal disk and the Games folder (28 GB).

The backup is additive: it never deletes anything on the SSD. If a file is deleted on the laptop, its copy stays in the backup. This protects against deleting something by mistake, but the SSD slowly keeps old files and grows. Every run adds one line to `backup-acer/LOG.txt` on the SSD with the start time, the end time and the exit code of the copy command (0 means success).

## How it does it
To run it, plug in the SSD and start `~/dev/scripts/backup-ssd.sh` by hand. The script first checks that the SSD is mounted (made available as a folder) at `/run/media/yuji/0a34cf43-b7a8-4198-bb85-690e4c0149c4` and writable; if not, it prints a message and stops without doing anything. The SSD uses the btrfs file system (the way the disk organises its files).

The copying itself is done by [rsync](https://en.wikipedia.org/wiki/Rsync), a standard tool that copies only what is new or changed, so a second run is much faster than the first. The options used keep dates, permissions, owners and links (`-a`), keep hard links (`-H`) and keep the relative paths (`-R`); the exclusions above are passed with `--exclude`. The script ends with the same exit code as rsync, so a failure can be noticed.

## Where it sits in the pipeline
It is a manual safety step outside the software projects: it only reads the laptop and writes to the SSD. There is no automatic schedule: it runs only when Giovanni starts it with the SSD plugged in, so the backup is as recent as his last run. Older manual copies already on the SSD (folders such as `documentos`, `documentos contratação` and `fotos`) were left untouched.

First real run, 2026-11-27: 285,716 files, about 47.7 GB, about 2 minutes, exit code 0. Afterwards a checksum comparison (an rsync dry run with `-c`, which compares the content of each file instead of its date and size) of Documents, Pictures, Downloads, `.ssh` and `.gnupg` showed 0 differences. The SSD had 520 GB free afterwards.

## Who receives its output
Giovanni: the copy on the SSD and the line in `backup-acer/LOG.txt`. Nothing else reads them. To get files back, copy them from `backup-acer/home/` on the SSD to the same path in the home folder.
