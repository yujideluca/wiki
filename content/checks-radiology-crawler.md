---
id: checks-radiology-crawler
title: radiology-crawler: checkers and rules
aliases: [radiology crawler checks, radiology-report-matcher checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [radiology-crawler:tools/quality_gate.sh, radiology-crawler:pipeline-check.toml, radiology-crawler:CLAUDE.md, radiology-crawler:tools/check_dependencies.py, radiology-crawler:tests/test_cli_help.py, radiology-crawler:pipeline-check.version]
reviewed: 2026-11-09T17:25Z
---

## What it is
These are the checkers of the radiology crawler repository (`radiology-crawler`, named `radiology-report-matcher` in its config), the Python tools that collect and analyse public radiology text for the planned report matcher ([[radiology-report-matcher]], [[radiopaedia-crawler]]).

## What it does
The gate has four steps: (0) `check_dependencies.py`: every third-party import appears in `requirements.txt` (or in `requirements-optional.txt` when it is used only inside a try block with a fallback), and every `pip install` in a workflow is `pip install -r requirements.txt` (principle 11, added after a CI (continuous integration) run failed on a missing package); (1) `compileall` and the tests with pytest, among them `tests/test_cli_help.py`, which runs every runnable script in `analysis/` and `tools/` with `--help` and with an unknown option and fails when one does real work (exit code other than 0 for `--help` or 2 for the unknown option, or a tracked file changed; added 2026-11-06 after `--help` overwrote a report); (2) requirement traceability (AN, CW, DP, LG, TL, WS groups); (3) fitness limits: no Python file over 800 lines, the gate at most 1200 seconds. Rules in `CLAUDE.md`, each with the tests that check it: the crawler obeys `robots.txt` (CW-1 to CW-3); each Codex call is a fresh session under 250,000 tokens (TL-2, TL-5); no personal or patient data in the repository or logs; downloaded pages and databases never go into git; the status of the statistical analysis is kept in `docs/analysis-status.json`.

## How it does it
CI installs from `requirements.txt` and runs `pipeline-check --mode ci` (60 minutes at most), at the version pinned in `pipeline-check.version` (v0.8.0 since 2026-11-07, before v0.7.0, v0.6.0, v0.5.0 and v0.4.0). Its `pipeline-check.toml` has no GitHub section, so branch protection is not read there. Three ADRs exist.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
