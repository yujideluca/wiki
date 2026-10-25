---
id: codex-status-line
title: Codex native status line
kind: reference
project: none
status: active
location: home:.codex/config.toml
fed_by: []
feeds: []
sources: [home:.codex/config.toml, home:AGENTS.md, home:.codex/AGENTS.md]
reviewed: 2026-10-25T20:55Z
---

## What it is
The native status line is the usage display inside the Codex terminal. It complements the separate task-progress row in the [[laptop-setup]].

## What it does
It shows the percentages remaining in the five-hour and weekly allowances, tokens used in the current context, and context-window size. Tokens are the text units counted by the model. The context window is how much text one request can hold.

## How it does it
The `tui.status_line` list in `~/.codex/config.toml` contains `five-hour-limit`, `weekly-limit`, `used-tokens`, `context-window-size` and `task-progress`. A new terminal loads these settings. Context values appear after a request reports usage.

## Where it sits in the pipeline
It runs inside Codex, above the separate task-progress footer.

## Who receives its output
Giovanni reads the display.

## Notes
A terminal test on 2026-10-25 with Codex 0.164.0 displayed `5h 44% left · weekly 76% left · 10.5K used · 475K window`. A second fresh terminal verified the saved configuration without command-line overrides. Existing terminal processes have not been verified to reload the configuration.
