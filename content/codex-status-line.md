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
reviewed: 2026-11-06T22:03Z
---

## What it is
Codex is OpenAI's coding assistant that runs in a terminal, the counterpart of [[claude-code]] on this laptop. Its native status line is the usage display built into the Codex terminal screen. It complements the separate task-progress row ([[codex-pbar]]) in the [[laptop-setup]].

## What it does
It shows the percentages remaining in the five-hour and weekly allowances, tokens used in the current context, and context-window size. Tokens are the text units counted by the model. The context window is how much text one request can hold.

## How it does it
Codex's settings file is `~/.codex/config.toml`, written in TOML (a plain-text settings format of `key = value` lines under `[section]` headings). In its `[tui]` section (TUI, terminal user interface, the screen Codex draws in the terminal) the `status_line` list contains `five-hour-limit`, `weekly-limit`, `used-tokens`, `context-window-size` and `task-progress`. The global Codex instructions ([[global-codex-agents]]) tell Codex to keep these fields. A new terminal loads these settings. Context values appear after a request reports usage.

## Where it sits in the pipeline
It runs inside Codex, above the separate task-progress footer.

## Who receives its output
Giovanni reads the display.

## Notes
A terminal test on 2026-10-25 with Codex 0.164.0 displayed `5h 44% left · weekly 76% left · 10.5K used · 475K window`. A second fresh terminal verified the saved configuration without command-line overrides. Existing terminal processes have not been verified to reload the configuration.

With `tui.fullscreen_transcript = true`, Codex places the input and native status line at the bottom immediately; scrolling is handled inside Codex. Scrollback mode (`false`) starts them near the top and moves them down as output fills the terminal, separating them from the fixed task-progress footer. A comparison on Codex 0.164.0 placed the budget fields on row 13 of 52 in scrollback mode and row 51 in fullscreen mode, with no prompt sent. Fullscreen also retained the bottom position at 70 columns by 24 rows. Reopen the terminal view to apply the saved setting. Fullscreen can show Codex’s additional low-budget warning above the input.
