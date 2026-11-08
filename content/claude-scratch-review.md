---
id: claude-scratch-review
title: claude-scratch-review (scratch folder review)
aliases: [claude-scratch-review.timer, scratch review, scratch folders]
kind: service
project: laptop-setup
status: active
location: home:.local/bin/claude-scratch-review
fed_by: [acer-nitro]
feeds: []
sources: [home:.local/bin/claude-scratch-review, home:.local/bin/claude-scratch-act, home:.local/bin/claude-scratch-keep, home:.local/bin/claude-scratch-drop, home:.config/systemd/user/claude-scratch-review.service, home:.config/systemd/user/claude-scratch-review.timer]
since: 2026-11-05
reviewed: 2026-11-05T19:50Z
---

## What it is
This is a daily job that keeps old scratch folders from filling the laptop's memory. Claude Code writes its temporary work (scripts, test output, browser profiles) into a "scratchpad" folder under `/tmp/claude-1000/`. On the [[acer-nitro]] `/tmp` is a "tmpfs" (a folder that lives in RAM, the computer's fast working memory, instead of on the disk), so every file in it uses memory. On 2026-11-05 one old session folder held about 5 GB there. The job runs as a "systemd user timer" ([systemd](https://en.wikipedia.org/wiki/Systemd) is the Linux program that starts background jobs on a schedule) named `claude-scratch-review.timer`.

## What it does
Once a day (04:30, plus a random delay of up to 10 minutes, and a catch-up run if the laptop was off) it looks for session folders in `/tmp/claude-1000/` whose newest file is more than 3 days old and that no running process is using. It then starts a headless Claude (`claude -p`, Claude run without a chat window, model Sonnet) and gives it the list. For each folder Claude decides: keep it, which moves the folder to the archive on the SSD (solid-state drive, a disk without moving parts), or drop it, which deletes it. Claude is told to keep a folder when it holds work worth having later (scripts, results, reports, notes, anything another project refers to) and to delete only regenerable material (caches, browser profiles, `node_modules`, logs), and to keep when unsure, because a deletion cannot be undone.

## How it does it
The script `claude-scratch-review` builds the list (the "manifest", `~/.local/state/claude-scratch/manifest.txt`) and writes the question for Claude to `prompt.txt` in the same folder. A process counts as "using" a folder when its working directory is inside it or when `lsof` (a tool that lists open files) shows an open file there. Claude may only read files and run two helper commands, `claude-scratch-keep <folder>` and `claude-scratch-drop <folder>`; both call `claude-scratch-act`. That helper refuses a folder that is not in today's manifest, is outside `/tmp/claude-1000/<project>/<session>`, is not a plain directory, or is in use. The reason for this design is that Claude decides, but cannot delete anything the script did not offer. Keep copies the folder, compares the byte size of the copy and only then removes the original; the archive name is `<project>__<session>`. The archive is `claude-scratch/archive/` on the spare 512 GB drive mounted at `/run/media/yuji/c202ac7d-57a0-4474-9091-b25ed7af6220`, or `~/.local/share/claude-scratch-archive` when that drive is not mounted. Since 2026-11-08 the drive has an entry in `/etc/fstab` (the list of drives mounted at boot), so it is mounted at every start; the fallback folder is used only if the drive is missing. Every action is logged in `~/.local/state/claude-scratch/log.txt` and Claude's own summary in `last-run.txt`. The folder can be checked without involving Claude: `claude-scratch-review --dry` prints the list and stops.

The same day the timer was set up, 75 `bench-profile-*` folders (about 5.1 GB) in one session's scratchpad were moved once by hand to `claude-scratch/sessions/18bdee0e/scratchpad/` on the spare drive, leaving a symbolic link (a pointer to another place) at each old path. One folder that was in use was left in place.

A test on a made-up folder tree, run before the timer was enabled, deleted a folder holding only a log and `node_modules`, kept one holding notes and a script, and skipped a folder with a running process and a folder newer than 3 days. The first real run, started by hand through the service unit on 2026-11-05, reviewed 32 folders: it kept 2 (study-plan notes, and Haiku batch outputs that an open analysis step uses) and deleted 30 (25 empty, 5 regenerable or already applied). Claude's first attempt, one loop that dropped every folder at once, was blocked by the permission system, and Claude then called the helper once per folder. One deletion, a 94 MB download, rested on a match of the data set's name with a copy in `~/dev/merlin-data/raw`, not on a comparison of contents. The run started by the timer itself (first due 2026-11-06 about 04:35) is not verified yet. An unattended run needs a valid Claude login; `claude setup-token` creates a long-lived token for this case.

## Where it sits in the pipeline
It runs on the [[acer-nitro]] as part of [[laptop-setup]], next to the 30 GB swap file (disk space the system uses as overflow memory) described on the laptop page. Both exist to stop scratch files and memory pressure from freezing the laptop.

## Who receives its output
[[giovanni]], through the archive folder and the log files; no other part of the system reads them.
