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
reviewed: 2026-10-25T02:07Z
---

## What it is
"User-space" means installed in the user's own folders instead of the system folders, so no administrator rights are needed. This page covers the extra tools Giovanni's laptop has in `~/.local`: [Node.js](https://nodejs.org/) 22 with npm (JavaScript runtime and its package installer), [uv](https://docs.astral.sh/uv/) (a fast Python package tool), pyright (a Python type checker), kotlin-lsp (a helper that explains Kotlin code to editors), rclone (copies files to cloud storage), a copy of tmux (a terminal that keeps running without a window), shellcheck 0.11.0 (a checker for shell scripts, used by [[pipeline-check]]), [Elm](https://elm-lang.org/) 0.19.1 with elm-test and elm-format, and the scripts `mem`, `tg-send`, `claude-assistant` and `wiki`.

## What it does
They give Claude Code language servers (programs that report code errors and definitions through the Language Server Protocol, LSP), build tools and helpers. The exception is [Elixir](https://elixir-lang.org/) 1.18 with Erlang/OTP 27 (OTP is the Open Telecom Platform, Erlang's standard libraries): those were installed with the system package manager `apt` by Giovanni, for the wiki.

## How it does it
Small wrapper scripts on the `PATH` (the list of folders searched for commands) in `~/.local/bin`. pyright lives in `~/.local/share/pyright-pkg` because a virtual environment was not possible, and kotlin-lsp in `~/.local/opt/kotlin-lsp`. The exact paths and upgrade steps are kept in [[claude-auto-memory]].

## Where it sits in the pipeline
Under the work of every project.

## Who receives its output
[[claude-code]], [[claude-assistant]] and the wiki build ([[wiki-build]]).
