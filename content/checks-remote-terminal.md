---
id: checks-remote-terminal
title: remote-terminal: checkers and rules
aliases: [remote-terminal checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [remote-terminal:tools/quality_gate.sh, remote-terminal:pipeline-check.toml, remote-terminal:.github/workflows/quality-gate.yml, remote-terminal:tests/setup-sudo-sandbox.sh]
reviewed: 2026-11-02T10:44Z
---

## What it is
These are the checkers of [[remote-terminal]], a small set of shell scripts (notably `setup-sudo.sh`) for reaching the laptop's terminal remotely. It has the lightest gate of the projects with CI (continuous integration).

## What it does
The gate does three things: `bash -n` (a syntax check without running) on every tracked shell script and the pre-push hook; ShellCheck at warning level on `setup-sudo.sh` and its test (skipped with a message when ShellCheck is not installed); and a sandbox test, `tests/setup-sudo-sandbox.sh`, which runs the sudo setup in an isolated folder. Limits: the gate at most 300 seconds. There is no requirement list and no traceability step.

## How it does it
CI runs `pipeline-check --mode ci` (20 minutes at most). `pipeline-check.toml` names the repository and the required job `gate`. ADRs: none in `docs/adr`; the folder `docs` holds only the bug-finding test record.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
