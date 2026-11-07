---
id: checks-pipeline-check
title: pipeline-check: checkers and rules
aliases: [pipeline-check checks, checker of the checker]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [pipeline-check:tools/quality_gate.sh, pipeline-check:pipeline-check.toml, pipeline-check:CLAUDE.md, pipeline-check:.github/workflows/quality-gate.yml, pipeline-check:mutants.py, pipeline-check:docs/adr, pipeline-check:tests/common/mod.rs]
reviewed: 2026-11-07T18:35Z
---

## What it is
These are the checks that guard [[pipeline-check]] itself, the Rust program that measures all the other projects (own repository, `yujideluca/pipeline-check`). The program cannot rely on a pinned copy of itself, so it has the leanest wiring.

## What it does
The gate has three steps, after a first check (step 0, since 2026-11-07) that every test folder deletes itself: tests take their folders from `Scratch` in `tests/common/mod.rs`, which removes the folder when the test ends, also when it fails (set `KEEP_SCRATCH=1` to keep them), and any other `temp_dir()` line fails the gate unless it says `scratch-ok:` and why. Before that, each test built a `/tmp/name-PID` folder by hand and never removed it, and 1,411 folders had piled up ([[tmp-junk]]). The steps: (1) `cargo test`, with test files for end-to-end runs, the pre-push mode, ShellCheck, traceability and a bug-hunt set; (2) requirement traceability by running its own `--traceability` over `src` and `tests` (the PC requirements) with the committed matrix; (3) a hand-made mutation check: `mutants.py` plants faults and the gate fails if any one survives. Its principles: the program measures and a skill judges (ADR-0002 (an architecture decision record)), and a tool used by more than one project lives once and is consumed by pinned version (ADR-0003).

## How it does it
The CI (continuous integration) job `gate` runs `tools/quality_gate.sh` directly (30 minutes at most). Its `pipeline-check.toml` sets no fitness limits, no GitHub section and no pre-push guard; it has the traceability and ShellCheck sections. Three ADRs exist in its `docs/adr`.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
