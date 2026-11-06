---
id: user-space-tools
title: User-space tools (~/.local)
aliases: [~/.local/bin, pyright, kotlin-lsp, uv, rclone, node, elm, elixir]
kind: program
project: laptop-setup
status: active
location: home:.local/bin
fed_by: []
feeds: [claude-assistant]
sources: [home:.local/bin]
reviewed: 2026-11-06T22:03Z
---

## What it is
"User-space" means installed in the user's own folders instead of the system folders, so no administrator rights are needed. This page covers the extra tools Giovanni's laptop has in `~/.local`: [Node.js](https://nodejs.org/) 22 (22.23.3, in `~/.local/opt`) with npm (JavaScript runtime and its package installer), [uv](https://docs.astral.sh/uv/) (a fast Python package tool), pyright (a Python type checker), kotlin-lsp (a helper that explains Kotlin code to editors), rclone (copies files to cloud storage), a copy of tmux 3.6a (a terminal that keeps running without a window; the Ubuntu package unpacked without administrator rights, started by a small wrapper script), shellcheck 0.11.0 (a checker for shell scripts, used by [[pipeline-check]]), [Elm](https://elm-lang.org/) 0.19.1 with elm-test and elm-format, and the scripts `mem`, `tg-send`, `claude-assistant` and `wiki`. The same folder also holds the command `claude` (a link to the installed version of Claude Code, 2.1.319 at this review, which updates itself), `codex` (a link to Codex's own installed program, 0.166.0 at this review, in `~/.codex/packages/standalone`; see [[codex-pbar]] for why this matters to the terminal footer), and three Codex helper scripts: `codex-task-progress`, which sets the counter of the terminal footer ([[codex-pbar]]); `codex-pbar`, which now only prints that the separate Codex Status window is disabled and exits with an error; and `codex-remote-tmux` for the always-on Codex remote session ([[remote-assistant]]). `wiki` is a link to the wiki's command, built in `~/dev/wiki/server/wiki`.

Also in `~/.local/bin` since 2026-11-05: `claude-scratch-review`, `claude-scratch-act`, `claude-scratch-keep` and `claude-scratch-drop`, the scripts of the daily scratch-folder review ([[claude-scratch-review]]), and `status-quo`, the program of the desktop tray ([[status-quo]]), together with several `status-quo.bak-*`, `status-quo.before-status-quo` and `status-quo.prev` copies of earlier builds. Four empty folders (`.agents`, `.aws`, `.codex`, `.git`, all from 2026-10-25) also sit in `~/.local/bin`; what created them was not verified.

## Architecture
### Context
person c: Claude Code — uses the tools while it works | [[claude-code]]
system u: User-space tools — extra programs in ~/.local, no administrator rights
external a: Remote assistant — runs inside a copy of tmux from here | [[claude-assistant]]

c -uses tools from-> u
u -supports-> a

### Containers
person c: Claude Code | [[claude-code]]
container bi: ~/.local/bin — small wrapper scripts on the search path
container nd: Node.js 22 with npm — JavaScript runtime and installer
container uv: uv — a fast Python package tool
container py: pyright — a Python type checker
container kt: kotlin-lsp — explains Kotlin code to editors
container rc: rclone — copies files to cloud storage
container tm: tmux — a copy kept in user space
store nt: Notes — exact paths and upgrade steps | [[claude-auto-memory]]

c -runs-> bi
bi -starts-> nd
bi -starts-> uv
bi -starts-> py
bi -starts-> kt
bi -starts-> rc
bi -starts-> tm
c -reads the upgrade steps in-> nt

## What it does
They give Claude Code language servers (programs that report code errors and definitions through the Language Server Protocol, LSP), build tools and helpers. The exception is [Elixir](https://elixir-lang.org/) 1.18 with Erlang/OTP 27 (OTP is the Open Telecom Platform, Erlang's standard libraries): those were installed with the system package manager `apt` by Giovanni, for the wiki.

## How it does it
Small wrapper scripts on the `PATH` (the list of folders searched for commands) in `~/.local/bin`. pyright lives in `~/.local/share/pyright-pkg` because a virtual environment was not possible, and kotlin-lsp in `~/.local/opt/kotlin-lsp`. The exact paths and upgrade steps are kept in [[claude-auto-memory]].

## Where it sits in the pipeline
Under the work of every project.

## Who receives its output
[[claude-code]], [[claude-assistant]] and the wiki build ([[wiki-build]]).

The installed `codex` launcher and `codex-task-progress` command provide the separate fixed task footer ([[codex-pbar]]). Codex's usage display is configured separately ([[codex-status-line]]).
