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
reviewed: 2026-11-25T22:16Z
---

## What it is
Codex is OpenAI's coding assistant that runs in a terminal, the counterpart of [[claude-code]] on this laptop. Its native status line is the usage display built into the Codex terminal screen. It complements the separate task-progress row ([[codex-pbar]]) in the [[laptop-setup]].

## What it does
It shows the percentages remaining in the five-hour and weekly allowances, tokens used in the current context (`used-tokens`), and the context-window size, next to the task-progress row. Tokens are the text units counted by the model. The context window is how much text one request can hold.

## How it does it
Codex's settings file is `~/.codex/config.toml`, written in TOML (a plain-text settings format of `key = value` lines under `[section]` headings). In its `[tui]` section (TUI, terminal user interface, the screen Codex draws in the terminal) the `status_line` list contains `five-hour-limit`, `weekly-limit`, `used-tokens`, `context-window-size` and `task-progress` (checked on 2026-11-25). This matches the four usage values required by the global Codex instructions ([[global-codex-agents]]). A new terminal loads these settings. Context values appear after a request reports usage.

## Where it sits in the pipeline
It runs inside Codex, above the separate task-progress footer.

## Who receives its output
Giovanni reads the display.

## Notes
A capture of the running Codex 0.171.0 terminal on 2026-11-25 displayed `5h 89% left · weekly 25% left · 59.4K used · 258K window`. A second capture after further activity displayed `5h 83% left · weekly 24% left · 71.7K used · 258K window`. A capture later that day, after the settings file was rewritten, still displayed all four values: `5h 97% left · weekly 10% left · 293K used · 475K window`. The saved configuration and actual display both include the tokens-used field; no setting change was needed. The current native identifier is `used-tokens`.

A terminal test on 2026-10-25 with Codex 0.164.0, when the list still held `used-tokens`, displayed `5h 44% left · weekly 76% left · 10.5K used · 475K window`. A second fresh terminal verified the saved configuration without command-line overrides. Existing terminal processes have not been verified to reload the configuration.

With `tui.fullscreen_transcript = true`, Codex places the input and native status line at the bottom immediately; scrolling is handled inside Codex. Scrollback mode (`false`) starts them near the top and moves them down as output fills the terminal, separating them from the fixed task-progress footer. A comparison on Codex 0.164.0 placed the budget fields on row 13 of 52 in scrollback mode and row 51 in fullscreen mode, with no prompt sent. Fullscreen also retained the bottom position at 70 columns by 24 rows. Reopen the terminal view to apply the saved setting. Fullscreen can show Codex’s additional low-budget warning above the input.
