---
id: user-space-tools
lang: de
source_hash: 010b8b5afe5c
title: Werkzeuge im Benutzerbereich (~/.local)
---

## What it is
Die ohne sudo in `~/.local` installierten Zusatzwerkzeuge: Node 22 und npm, uv, pyright, kotlin-lsp, rclone, ein tmux im Benutzerbereich, Elm 0.19.1 (mit elm-test und elm-format) und die Skripte `mem`, `tg-send`, `claude-assistant` und `wiki`.

## What it does
Geben Claude Code Sprachserver (pyright, kotlin-lsp für die Plugins), Bauwerkzeuge und Helfer. Ausnahme Elixir 1.18 / Erlang OTP 27: von Giovanni mit apt für das Wiki installiert.

## How it does it
Wrapper im `PATH` unter `~/.local/bin`; pyright liegt in `~/.local/share/pyright-pkg` (kein venv möglich), kotlin-lsp in `~/.local/opt/kotlin-lsp`. Pfade und Update-Schritte stehen in [[claude-auto-memory]].

## Where it sits in the pipeline
Unter der Arbeit jedes Projekts.

## Who receives its output
[[claude-code]], [[claude-assistant]] und der Wiki-Build ([[wiki-build]]).
