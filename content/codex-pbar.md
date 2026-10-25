---
id: codex-pbar
title: Codex Status companion
aliases: [Codex progress bar]
kind: project
project: codex-pbar
status: active
location: codex-pbar:src/codex_pbar
fed_by: []
feeds: []
sources: [codex-pbar:src/codex_pbar/core.py, codex-pbar:src/codex_pbar/reader.py, codex-pbar:src/codex_pbar/app.py, codex-pbar:src/codex_pbar/desktop.py, codex-pbar:tools/install.py, codex-pbar:tools/quality_gate.sh, codex-pbar:README.md]
reviewed: 2026-10-25T14:46Z
---

## What it is
Codex Status is a small desktop window that helps Giovanni see what Codex is doing and how much conversation capacity and account allowance remain. Its source is in `~/dev/codex-pbar`, with a [GitHub repository](https://github.com/yujideluca/codex-pbar). It adapts the drawing helpers from the Claude status bar [[pbar]]. Start with the repository's `README.md` for installation and commands.

## What it does
It shows the project folder, version-control branch (the separate line of development), model, active tool calls, approximate context occupancy (the conversation information sent in the last model request), account usage windows (the periods over which a quota is measured) and their reset times. It keeps sessions separate. A time bar uses at least three previous successful calls with the same project and hashed arguments; a hash is a fingerprint that avoids storing the original arguments. It estimates a tool call's duration, not completion of the whole task. Unknown values stay unknown, and no new events for fifteen minutes marks a session stale.

## How it does it
Python reads Codex's local session files one complete record at a time. The format depends on the Codex version; this reader was tested with version 0.164.0. It ignores unknown records and counts malformed or oversized ones. It never opens credentials or makes model or network requests. Private local files under `~/.local/share/codex-pbar` hold display status and hashed duration history; they contain no prompts, original arguments or tool outputs.

PySide6, a Python window library, draws the companion. A user service, a background program managed by Linux's systemd service manager, starts with the graphical desktop and restarts after a crash. It shows the window when a Codex backend (the background program that runs a conversation) starts or a new turn begins. Closing hides it; the **Codex Status** menu entry or `codex-pbar --show` reopens it. `codex-pbar --json` prints local diagnostics without a window. The installer preserves Codex settings and approval rules. The quality gate, the automated check that decides whether a change passes, runs tests, coverage, nine controlled fault injections (deliberate bugs that tests must catch), a window render and requirement traceability (each promise is linked to a test) through [[pipeline-check]]. Approval waiting is not inferred, and a shell process may outlive the tool call that started it.

## Where it sits in the pipeline
It runs beside Codex on the laptop as part of [[laptop-setup]]. `systemctl --user status codex-pbar` checks the service; `systemctl --user disable --now codex-pbar` stops it and disables startup. Keep the clone at its installed path or rerun `tools/install.py` after moving it.

## Who receives its output
Giovanni reads the desktop window. Codex can read the local diagnostic command when investigating a problem. Session data is not sent to GitHub.
