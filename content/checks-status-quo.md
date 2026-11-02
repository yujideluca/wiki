---
id: checks-status-quo
title: status-quo: checkers and rules
aliases: [status-quo checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [status-quo:tools/quality_gate.sh, status-quo:pipeline-check.toml, status-quo:CLAUDE.md, status-quo:docs/REQUIREMENTS.md, status-quo:.github/workflows/quality-gate.yml, status-quo:tools/rust_architecture.rs]
reviewed: 2026-11-02T13:48Z
---

## What it is
These are the checkers of the repository `status-quo` (see [[status-quo-design]] and [[status-quo-layout]]), a Rust workspace started from [[project-template]]. It lives in the private GitHub repository `yujideluca/status-quo`. The continuous-integration run on its first commit passed on 2026-11-02; branch protection cannot be enabled on a private repository on the free plan, so the `protecao-de-branch` check keeps failing.

## What it does
The gate (`tools/quality_gate.sh`) runs five steps in order: Rust formatting (`cargo fmt --check`), compiler diagnostics with warnings denied (clippy) plus the whole test suite, a project-specific boundary check (`tools/rust_architecture.rs`), requirement traceability, and the fitness limit on gate duration (1200 seconds). On 2026-11-02 all five passed.

The boundary check exists because the shared checker (`pipeline-check` v0.4.0) only scans Java and Kotlin. It rejects graphical, file, process or network dependencies in the three portable packages, allows only the egui interface library in the reusable tray, and has its own self-tests that plant defects and require them to be rejected. All 27 requirements (SQ group) in `docs/REQUIREMENTS.md` have a test tagged with a standalone `// REQ SQ-n` comment; the scan covers `.rs` files under `crates` and `tools`. A tag proves a test exists, not that the real desktop behaves correctly, so window stacking, login startup and the resource limits need separate observation (idle CPU is currently 2.05% of one core against a 1% target).

## How it does it
CI (continuous integration) uses the standard workflow (`pipeline-check --mode ci`, 60 minutes at most) and adds a browser build for the `wasm32` target. `pipeline-check.toml` names the project, points at the repository `yujideluca/status-quo`, requires the check called `gate` on `main`, and lists `tools/hooks/pre-push` for the shell checker. Four ADRs (architecture decision records) exist: 0001 (record decisions), 0002 (portable Rust widgets), 0003 (the program measures, the skill judges) and 0004 (host compatibility layer).

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
