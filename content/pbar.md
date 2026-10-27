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
reviewed: 2026-10-27T01:45Z
---

## What it is
`pbar.py` draws the status line of Claude Code on the laptop: the single line of text at the bottom of the terminal. While a command is running it looks like the progress bar that the `apt` package installer draws. It works only locally: it uses no network and no model tokens (the units in which AI usage is measured), so it costs nothing.

## Architecture
### Context
person g: Giovanni — reads the line at the bottom of the terminal | [[giovanni]]
external cc: Claude Code — shows the status line | [[claude-code]]
external cs: Claude Code settings — start both parts | [[claude-code-settings]]
system p: pbar.py — a progress bar and status line, all local
external pr: Running programs — the Linux /proc listing

g -reads the line in-> cc
cs -start-> p
cc -asks for the line from-> p
p -scans-> pr

### Containers
external cs: Claude Code settings | [[claude-code-settings]]
external cc: Claude Code | [[claude-code]]
container lp: Check loop — finds the running command and learns durations
container ln: line command — prints one status line as wide as the terminal
store hi: history.json — typical durations of earlier runs
external pr: Running programs (/proc)

cs -starts-> lp
cs -registers-> ln
cc -calls-> ln
lp -scans-> pr
lp -learns durations in-> hi
ln -reads durations from-> hi

## What it does
While a shell command runs it shows `Progress: [ 45%]` and a bar, estimated from how long that same program took on earlier runs. When nothing is running it shows the folder, the git branch, the model, the cost, how much of the context window is used and the usage of the 5-hour limit with its reset time.

## How it does it
There are two parts. A check loop scans `/proc` (the Linux listing of running programs) for the program each Claude Code command runs and learns typical durations, kept in `~/.local/share/claude-pbar/history.json`. The second part, `line`, is the command that Claude Code calls to get the status line ([documentation](https://docs.claude.com/en/docs/claude-code/statusline)); it prints one line as wide as the terminal. Both are started from [[claude-code-settings]].

## Where it sits in the pipeline
At the bottom of every Claude Code terminal.

## Who receives its output
Giovanni, watching the terminal.

The Codex companion [[codex-pbar]] adapts this display for Codex sessions.
