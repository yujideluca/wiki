---
id: pbar
title: pbar.py (status line)
aliases: [status line, progress bar]
kind: program
project: laptop-setup
status: active
location: home:.claude/tools/pbar.py
fed_by: [claude-code-settings]
feeds: []
sources: [home:.claude/tools/pbar.py]
---

## What it is
The status line of Claude Code on the laptop: a progress bar drawn the way apt draws its install progress. Local only: no network, no model tokens.

## What it does
While a shell command runs, shows `Progress: [ 45%]` and a bar, estimated from how long that program took before; when nothing runs, shows folder, git branch, model, cost, context used and 5-hour usage with its reset time.

## How it does it
Two parts: a check loop that scans `/proc` for the program each Claude Code command runs and learns durations (`~/.local/share/claude-pbar/history.json`), and `line`, the statusLine command, which prints one line as wide as the terminal. Started by [[claude-code-settings]].

## Where it sits in the pipeline
At the bottom of every Claude Code terminal.

## Who receives its output
Giovanni, watching the terminal.
