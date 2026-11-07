---
id: checks-machine-bootstrap
title: machine-bootstrap: checkers and rules
aliases: [machine-bootstrap checks, restore checks]
kind: decision
project: machine-bootstrap
status: active
fed_by: []
feeds: []
sources: [machine-bootstrap:tools/quality_gate.sh, machine-bootstrap:pipeline-check.toml, machine-bootstrap:CLAUDE.md, machine-bootstrap:mb/scan.py, machine-bootstrap:tools/vm-test.sh, machine-bootstrap:docs/adr]
reviewed: 2026-11-07T23:42Z
---

## What it is
These are the checkers of [[machine-bootstrap]], the tool that records Giovanni's laptop setup and rebuilds it on a new machine. A mistake here can leak secrets or destroy a restore, so its rules are the strictest on privacy.

## What it does
The gate runs: the unit tests (capture, config, plan, scan, secrets, state, notify, data backup, bootstrap, VM proof); ShellCheck on `bootstrap.sh`; `python3 -m mb scan`, which scans every file under `state/` for secrets; requirement traceability (MB-1 to MB-16); and the fitness limits (no Python file over 300 lines in `mb`, the gate at most 1200 seconds). Rules: planning is pure and only `execute` with a runner changes the system; nothing secret goes into git (allow-list plus scanner, ADR-0004 (an architecture decision record)); secrets go only through the encrypted archive (ADR-0005); after changing a recipe, `plan.py` or `bootstrap.sh`, the whole restore is proven on a clean virtual machine with `tools/vm-test.sh` (about an hour) and the result is written in the decision log (MB-15). Unit tests prove logic; only the VM proves a restore.

## How it does it
CI (continuous integration) runs `pipeline-check --mode ci` (60 minutes at most). The repository is public, and the decision log records that the CI job `gate` is required on `main`, with administrators included, and that force pushes and branch deletion are refused (2026-10-26). Five ADRs exist.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
