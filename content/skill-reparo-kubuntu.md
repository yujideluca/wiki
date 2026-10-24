---
id: skill-reparo-kubuntu
title: Skill: reparo-kubuntu (laptop repair)
aliases: [reparo-kubuntu]
kind: skill
project: skills
status: active
location: home:.claude/skills/reparo-kubuntu
fed_by: []
feeds: []
sources: [home:.claude/skills/reparo-kubuntu/SKILL.md]
reviewed: 2026-10-22T16:33Z
---

## What it is
The skill "reparo-kubuntu" ("Kubuntu repair") diagnoses and fixes problems of Giovanni's laptop (an Acer Nitro running Kubuntu 24.04 with the Plasma 5.27 desktop, the X11 display system and an Nvidia graphics card) and makes the fixes survive reboots. It is written in Portuguese. Its description says exactly that. Its role is "domain": it owns the diagnosis and fix flow on his Linux; it defers to [[skill-browser-automacao-segura]] if a browser is used; and it honours the language of the message and the depth flags `!!`, `***` and `...`. The version for Claude Code is edited only there; the Claude app keeps its own version ([[claude-ai-skills]]).

## What it does
It covers display, driver, audio, network, desktop and boot problems, step by step, with the commands that need administrator rights (`sudo`) handed to Giovanni to run with the `!` prefix. Its method comes from Google's "Effective Troubleshooting" ([SRE book](https://sre.google/sre-book/effective-troubleshooting/); SRE is site reliability engineering) and the Ubuntu seven-step troubleshooting: stabilise and preserve evidence → examine → hypotheses ordered by probability → one change at a time → fix → retest after a reboot → document. The traps are chasing an irrelevant symptom, an unsafe change during testing and assuming the old cause has returned.

## How it does it
A `SKILL.md` in `~/.claude/skills/reparo-kubuntu`; Claude loads it when a request matches its description.

## Where it sits in the pipeline
Maintenance of the laptop itself.

## Who receives its output
The [[acer-nitro]].

## Steps
0. **Format.** Conclusion first: the main hypothesis plus the next step. With `!!`: up to 5 lines (hypothesis, 1 test, 1 fix, how to verify). Every answer that proposes a fix ends with **Verify** (what to check after restarting) and **Undo** (how to revert).
1. **Stabilise and collect, changing nothing.** Claude Code runs on the laptop itself, so run the commands yourself without asking Giovanni to paste anything. One block collects the system version, kernel, Plasma version, session type, Nvidia driver version, the user and system journal warnings and errors of this boot, recent crash dumps and the recent package-manager history, and saves them to `~/diag_<date>_<time>.txt`. Commands with `sudo` ask for a password: give Giovanni the line to run with `! sudo ...`. Ask only what the log cannot answer: what changed (update, configuration, theme) and whether it is reproducible.
2. **Symptom → first hypothesis → safe test** (from his history). Black screen, no panel, or plasmashell or krunner crashing → crash of plasmashell (a font-library fault, or a missing theme) → `coredumpctl info plasmashell`, `systemctl --user restart plasma-plasmashell`. Crash in libfontconfig → corrupted font cache or a badly matched web font → `fc-cache -r -v`, `fc-match sans`. Accented capitals or odd keyboard → the Fcitx input method plus layout and model (`pc104alt`, `br`) → `fcitx5-diagnose`, `setxkbmap -query`. Touchpad without configuration → module or driver (libinput versus synaptics, an XCTECH receiver) → `xinput list`, `journalctl -k | grep -i touch`. Slow boot → `NetworkManager-wait-online` or fstab → `systemd-analyze blame | head`, `systemd-analyze critical-chain`. Flicker → Nvidia driver versus kernel → `ubuntu-drivers devices`, `dkms status`.
3. **Change safely.** One change at a time, saying what it proves. Before editing, make a dated backup (`cp -a`). Never `rm -rf` in `~/.config` or `/etc`: move things to a quarantine folder instead. Before touching a driver or the kernel, take a snapshot (Timeshift) if available. Explain `sudo` commands in one line and let him run them with `! sudo ...`; without sudo, run them yourself and show the relevant output.
4. **Make it permanent (his priority).** A fix becomes a script `~/fixes/<name>.sh` (idempotent, with a final check). If it must run every session, make a user systemd unit `~/.config/systemd/user/<name>.service` (`Type=oneshot`, `After=graphical-session.target` and, if it touches Plasma, `After=plasma-plasmashell.service`, `ExecStart=%h/fixes/<name>.sh`, `WantedBy=graphical-session.target`) and enable it with `systemctl --user enable <name>`. A Plasma environment variable goes into `~/.config/plasma-workspace/env/`.
5. **Retest and record.** Reboot, run the block of step 1 again and compare with the previous one. Record the cause, the fix and how to undo it in `~/fixes/LEIAME.md`.
