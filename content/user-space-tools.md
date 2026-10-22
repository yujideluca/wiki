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
---

## What it is
The extra tools installed without sudo in `~/.local`: Node 22 and npm, uv, pyright, kotlin-lsp, rclone, a user-space tmux, Elm 0.19.1 (with elm-test and elm-format), and the scripts `mem`, `tg-send`, `claude-assistant` and `wiki`.

## What it does
Give Claude Code language servers (pyright, kotlin-lsp for the plugins), build tools and helpers. Elixir 1.18 / Erlang OTP 27 are the exception: installed with apt by Giovanni for the wiki.

## How it does it
Wrappers on `PATH` in `~/.local/bin`; pyright lives in `~/.local/share/pyright-pkg` (no venv possible), kotlin-lsp in `~/.local/opt/kotlin-lsp`. Paths and upgrade steps are kept in [[claude-auto-memory]].

## Where it sits in the pipeline
Under the work of every project.

## Who receives its output
[[claude-code]], [[claude-assistant]] and the wiki build ([[wiki-build]]).
