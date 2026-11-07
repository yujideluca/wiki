---
id: checks-codex-pbar
title: codex-pbar: checkers and rules
aliases: [codex-pbar checks, progress bar checks]
kind: decision
project: codex-pbar
status: active
fed_by: []
feeds: []
sources: [codex-pbar:tools/quality_gate.sh, codex-pbar:pipeline-check.toml, codex-pbar:CLAUDE.md, codex-pbar:tools/mutation_check.py]
reviewed: 2026-11-07T23:42Z
---

## What it is
These are the checkers of [[codex-pbar]], a Python program that shows a persistent progress footer for Codex in the terminal.

## What it does
The gate runs: the unit tests under `coverage` with branch measurement of the core and reader modules, and fails below 85 % (`--fail-under=85`); a project-specific mutation check (`tools/mutation_check.py`) that injects faults such as changing terminal colour codes or the mouse setting into temporary copies of the source and counts a fault as caught when the tests fail on it (the test run for each fault stops at the first failing test, `unittest -f`, which cut this step from about 5 minutes to about 20 seconds on the laptop); a smoke test that starts the application window without a display and saves `build/window.png`, with a throwaway Codex home folder so real data is untouched; requirement traceability (the PB requirements); and the fitness limits. Architecture rule: `src/codex_pbar` may not import `requests`, `urllib` or `socket` (no network code). The gate may take 1200 seconds.

## How it does it
CI (continuous integration) installs the test extras with pip and runs `pipeline-check --mode ci` (60 minutes at most). The repository is private on the free plan, so branch protection is not available: `protection_exception` records this and the local pre-push check stands in ([[branch-protection-explained]]). Five ADRs describe its choices.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
