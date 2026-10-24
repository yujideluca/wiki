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
`pbar.py` draws the status line of Claude Code on the laptop: the single line of text at the bottom of the terminal. While a command is running it looks like the progress bar that the `apt` package installer draws. It works only locally: it uses no network and no model tokens (the units in which AI usage is measured), so it costs nothing.

## What it does
While a shell command runs it shows `Progress: [ 45%]` and a bar, estimated from how long that same program took on earlier runs. When nothing is running it shows the folder, the git branch, the model, the cost, how much of the context window is used and the usage of the 5-hour limit with its reset time.

## How it does it
There are two parts. A check loop scans `/proc` (the Linux listing of running programs) for the program each Claude Code command runs and learns typical durations, kept in `~/.local/share/claude-pbar/history.json`. The second part, `line`, is the command that Claude Code calls to get the status line ([documentation](https://docs.claude.com/en/docs/claude-code/statusline)); it prints one line as wide as the terminal. Both are started from [[claude-code-settings]].

## Where it sits in the pipeline
At the bottom of every Claude Code terminal.

## Who receives its output
Giovanni, watching the terminal.
