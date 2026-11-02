---
id: checks-status-quo
title: status-quo: checkers and rules
aliases: [status-quo checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [status-quo:tools/quality_gate.sh, status-quo:pipeline-check.toml, status-quo:CLAUDE.md, status-quo:docs/REQUIREMENTS.md]
reviewed: 2026-11-02T10:44Z
---

## What it is
These are the checkers of the repository `status-quo` (see [[status-quo-design]] and [[status-quo-layout]]), a Rust workspace started from [[project-template]]. At the time of writing it had no commits, so its checks are partly the template's unfilled placeholders.

## What it does
The gate still holds the template step `echo "TODO: build and run the test suite"`, so no tests run yet; the traceability step and the fitness step are real. It has 25 requirements (SQ group) in `docs/REQUIREMENTS.md`. Its `pipeline-check.toml` still names the project `<project name>` and sets only the gate-duration cap (1200 seconds). Its `CLAUDE.md` principle 2 ('logic is framework-free') still has the placeholder `<name the pure module/package>`. These are gaps to fill, not rules in force.

## How it does it
CI (continuous integration) uses the standard workflow (`pipeline-check --mode ci`, 60 minutes at most). It has no GitHub section in its config. Two ADRs (0001 and 0003) exist.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
