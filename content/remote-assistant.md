---
id: remote-assistant
title: Remote assistant
aliases: [claude-assistant, assistant]
kind: actor
project: none
status: active
fed_by: [claude-assistant, giovanni, global-claude-md, session-brief]
feeds: [mem]
sources: [home:.local/bin/claude-assistant, home:.config/systemd/user/claude-assistant.service, home:assistant/CLAUDE.md, home:.local/bin/codex-remote-tmux, home:.config/systemd/user/codex-remote-tmux.service, home:Documents/Codex/2026-10-25/i-w/outputs/install-codex-remote.sh]
reviewed: 2026-10-26T18:16Z
---

## What it is
The remote assistant is a Claude Code session that runs all the time on the laptop, and that [[giovanni]] can reach from the Claude app on the phone through a feature called Remote Control. In the app it appears as `yuji-nitro-assistant`. Think of it as a second door into the same laptop: the same Claude, the same repositories, but reachable from anywhere.

## Flow
trigger t1: The laptop starts, or the assistant session ends | [[claude-assistant]]
step s1: The service restarts a tmux session running claude remote-control in ~/assistant
step s2: The session reads its own CLAUDE.md and the memory brief | [[session-brief]], [[global-claude-md]]
trigger t2: Giovanni sends a message from the Claude app on the phone | [[giovanni]]
step s3: Remote Control carries the message to the session yuji-nitro-assistant
step s4: Does the short task on the laptop, with the same rules as Claude Code | [[claude-code]]
step s5: Replies briefly, so it reads well on a phone
product p1: A short reply on Giovanni's phone
product p2: Changes in the project repositories
product p3: Memory entries tagged with the instance name assistant | [[events-log]]

t1 -> s1
s1 -> s2
s2 -> s4
t2 -> s3
s3 -> s4
s4 -> s5
s4 -> p2
s4 -> p3
s5 -> p1

## What it does
It does short tasks on the laptop while Giovanni is away from it. It follows the same rules as [[claude-code]] and writes to the shared memory under the instance name `assistant`, so the memory can tell who wrote what.

## How it does it
The [[claude-assistant]] service keeps it alive: a tmux session (a terminal that keeps running without a window) runs `claude remote-control` in a restart loop from the folder `~/assistant`. That folder has its own CLAUDE.md (a text file of standing instructions that Claude Code reads at start) which asks for short replies that read well on a phone. Its permission mode (how much Claude may do without asking) was chosen by Giovanni personally.

## Where it sits in the pipeline
It is a second entrance to the same laptop and the same project repositories as Claude Code; the difference is only how Giovanni gets to it.

## Who receives its output
The same recipients as [[claude-code]]: the project repositories and the memory log [[events-log]] (entries are tagged with `MEM_INSTANCE=assistant`).

## Notes

### Codex remote control
Codex is another programming assistant on this laptop. Its separate `codex-remote-tmux.service` uses systemd, the Linux program that manages background services, to start `~/.local/bin/codex-remote-tmux start`. The script keeps a terminal running without a visible window through tmux. It uses the dedicated tmux socket `codex-remote` and session `remote`, starting in the home folder.

The `run` action repeatedly calls `codex remote-control --no-daemon`. When that command exits, even with an error, the script waits 15 seconds before trying again. The service declares `Restart=always` and `RestartSec=15`. These are separate retry layers: the script retries the command, and systemd restarts the service. `start` leaves an existing session alone; `attach` opens its terminal; `stop` ends that session. With no argument the script attaches.

The installer at `~/Documents/Codex/2026-10-25/i-w/outputs/install-codex-remote.sh` backs up existing script and service files, writes them, checks their syntax, reloads systemd and enables and starts the service for the user's default target. The source command for pairing is `codex remote-control pair`; the terminal can be opened with `codex-remote-tmux attach`.

Live verification on 2026-10-26 found the service enabled and active, with tmux session `remote`, but the command was failing every 15 seconds: `socket parent must be owned by the user or root and prevent other users from replacing socket entries`. Codex created its temporary socket directory with group-write permission (mode `0775`). The launcher and installer now set `umask 077`, a creation mask that keeps new files and directories private to their owner. After restarting only this service, the tmux terminal reported `This machine is available for remote control as yuji-nitro.` and the `codex remote-control --no-daemon` process stayed running. The service remains enabled. Phone connectivity was not tested. The Codex script does not set Claude's `MEM_INSTANCE=assistant` marker.
