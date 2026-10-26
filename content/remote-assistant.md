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
reviewed: 2026-10-26T18:04Z
---

## What it is
The remote assistant is a Claude Code session that runs all the time on the laptop, and that [[giovanni]] can reach from the Claude app on the phone through a feature called Remote Control. In the app it appears as `yuji-nitro-assistant`. Think of it as a second door into the same laptop: the same Claude, the same repositories, but reachable from anywhere.

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

On this review, the installed script and service matched the installer. Live service state and phone connectivity were not verified: the sandbox denied access to the user-service bus and tmux socket. The service was not restarted or changed. The Codex script does not set Claude's `MEM_INSTANCE=assistant` marker.
