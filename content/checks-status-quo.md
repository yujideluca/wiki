---
id: checks-status-quo
title: status-quo: checkers and rules
aliases: [status-quo checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [status-quo:tools/quality_gate.sh, status-quo:pipeline-check.toml, status-quo:CLAUDE.md, status-quo:docs/REQUIREMENTS.md, status-quo:.github/workflows/quality-gate.yml, status-quo:tools/rust_architecture.rs, status-quo:docs/TESTES-AUTOMATIZADOS.md, status-quo:docs/TRACEABILITY.md, status-quo:docs/MAINTENANCE.md, status-quo:crates/widgets/tests/models.rs, status-quo:tools/ui_e2e.sh, status-quo:crates/desktop/tests/desktop_e2e.rs, status-quo:crates/desktop/tests/e2e/manual-baseline.json]
reviewed: 2026-11-02T17:01Z
---

## What it is
These are the checkers of the repository `status-quo` (see [[status-quo-design]] and [[status-quo-layout]]), a Rust workspace started from [[project-template]]. It lives in the private GitHub repository `yujideluca/status-quo`. The continuous integration (CI) run (the `gate` job) passed on every commit pushed so far, the latest on 2026-11-02 (read with `gh run list`). Branch protection cannot be enabled on a private repository on the free plan (GitHub answers HTTP 403 "Upgrade to GitHub Pro or make this repository public"), so the `protecao-de-branch` check of `pipeline-check` is expected to keep failing; its exact report state was not verified.

## What it does
The gate (`tools/quality_gate.sh`) runs five steps in order: Rust formatting (`cargo fmt --check`), compiler diagnostics with warnings denied (clippy) plus the whole test suite, a project-specific boundary check (`tools/rust_architecture.rs`, which also self-tests `tools/resource_check.rs`), requirement traceability (it also fails when the regenerated `docs/TRACEABILITY.md` differs from the committed copy), and the fitness limit on gate duration (1200 seconds). The CI run of the latest pushed commit passed; a local gate run of the uncommitted working tree was not verified for this page.

An optional sixth step runs only when the variable `STATUS_QUO_E2E=1` is set: `tools/ui_e2e.sh`, the desktop end-to-end test of the real tray (it pauses the live tray, drives a private copy with a virtual mouse and writes `build/e2e/report.json`). It is optional because it needs a Wayland session, a writable `/dev/uinput` and `spectacle`, so a normal run and the continuous integration (CI) run (which has no desktop) leave it out; the script itself skips with a stated reason when a need is missing. The test is not part of the five-step definition of passing: it complements the gate by checking what no unit test can, and `docs/MAINTENANCE.md` section 7 asks for it before closing a major tray update and before a release. A real run on 2026-11-02 passed 22 checks. Its idle CPU gate is a 2% ceiling, while the 1% target of SQ-23 (the idle-cost requirement) is recorded as data and still missed (1.30% of one core). Details: [[status-quo]].

The boundary check exists because the shared checker (`pipeline-check` v0.4.0) only scans Java and Kotlin. It rejects graphical, file, process or network dependencies in the three portable packages, allows only the egui interface library in the reusable tray, and has its own self-tests that plant defects and require them to be rejected. All 29 requirements (SQ group; SQ-29 is in the uncommitted working tree at review time) in `docs/REQUIREMENTS.md` have a test tagged with a standalone `// REQ SQ-n` comment; the scan covers `.rs` files under `crates` and `tools`. The wording of SQ-29 was replaced on 2026-11-02 (Edit tray as a free canvas, decision ADR-0005 (architecture decision record), see [[status-quo]]); its tag is in `crates/core/tests/behavior.rs`, `crates/tray/src/layout.rs`, `crates/tray/tests/layout.rs`, `crates/desktop/src/host/layer.rs` and `crates/desktop/tests/desktop_e2e.rs`, and `docs/TRACEABILITY.md` lists `behavior.rs, desktop_e2e.rs, layer.rs, layout.rs` for it. The gate was not run for this page update. A tag proves a test exists, not that the real desktop behaves correctly, so window stacking, login startup and the resource limits need separate observation (idle CPU was 2.05% of one core in the first five-minute run, 1.08% over 60 seconds and 1.30% over 20 seconds in later runs, against a 1% target).

## How it does it
CI (continuous integration) uses the standard workflow (`pipeline-check --mode ci`, 60 minutes at most) and adds a browser build for the `wasm32` target. `pipeline-check.toml` names the project, points at the repository `yujideluca/status-quo`, requires the check called `gate` on `main`, and lists `tools/hooks/pre-push` for the shell checker. Five ADRs (architecture decision records) exist, plus a blank template `docs/adr/0000-template.md`: 0001 (record decisions), 0002 (portable Rust widgets), 0003 (the program measures, the skill judges), 0004 (host compatibility layer) and 0005 (free canvas layout, in the working tree and not yet committed).

Three documents in `docs/` support the checks. `TRACEABILITY.md` is generated by `pipeline-check --traceability`: one row per requirement with the test files that carry its tag (for example SQ-8 lists `lifecycle.rs`, `models.rs`, `workers.rs`). `TESTES-AUTOMATIZADOS.md`, written in Portuguese, is the record of the bug-finding tests: a table of risks (configuration, contract, view models in `crates/widgets/tests/models.rs`, persistence, sources, transport, tray, boundary checker, browser reuse) against the test file and the behavior it must show, then the first five-minute resource runs (2.05% of one core, 115 MiB) and the host compatibility observations. It states that no coverage percentage or mutation score has been recorded; the only mutation-style evidence is a planted-defect run of the boundary checker. `MAINTENANCE.md` holds the debt, monthly review and `pipeline-check` method of the template.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
