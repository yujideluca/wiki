---
id: checker-catalog
title: Catalog of all checkers and which project uses them
aliases: [list of checkers, checks matrix, rules catalog]
kind: data
project: none
status: active
location: pipeline-check:src
fed_by: []
feeds: []
sources: [pipeline-check:src/lib.rs, pipeline-check:src/traceability.rs, pipeline-check:src/shellcheck.rs, QuizApp:tools/quality_gate.sh, QuizWeb:tools/quality_gate.sh, wiki:tools/quality_gate.sh, workflow-memory:tools/quality_gate.sh, pipeline-check:tools/quality_gate.sh, codex-pbar:tools/quality_gate.sh, codex-skills:tools/quality_gate.sh, machine-bootstrap:tools/quality_gate.sh, remote-terminal:tools/quality_gate.sh, processing-sketches:tools/quality_gate.sh, radiology-crawler:tools/quality_gate.sh, status-quo:tools/quality_gate.sh, project-template:tools/quality_gate.sh, QuizApp:pipeline-check.toml, QuizWeb:pipeline-check.toml, wiki:pipeline-check.toml, workflow-memory:pipeline-check.toml, codex-pbar:pipeline-check.toml, machine-bootstrap:pipeline-check.toml, processing-sketches:pipeline-check.toml, remote-terminal:pipeline-check.toml, radiology-crawler:pipeline-check.toml, status-quo:pipeline-check.toml, pipeline-check:docs/REQUIREMENTS.md]
reviewed: 2026-11-09T20:56Z
---

## What it is
A checker is any automatic test, scan or limit that can fail a change. This page lists every shared checker once, says what it looks for, and shows which of the 13 projects use it. The terms (gate, traceability, mutation, fitness function) are explained in [[quality-gate-explained]]. Rules that belong to only one project are on its own page, reached from [[code-security-pipeline]].

## What it does
Shared checkers (run by [[pipeline-check]]):
- **Project gate**: runs `tools/quality_gate.sh` once (all projects).
- **Requirement traceability** (`--traceability`, [[check-traceability]]): used by [[checks-quizapp]], [[checks-wiki]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]], [[checks-status-quo]] and [[checks-project-template]]. It is not used by [[checks-quizweb]] (its promises live in QuizApp's list and are read from the web tests, see below), [[checks-workflow-memory]], [[checks-remote-terminal]] or [[checks-processing-sketches]].
- **Fitness limits** (`[[fitness]]` in `pipeline-check.toml`): a cap on the lines of each source file (`max_file_lines`), a size cap on one named file (`file_size`, used for the APK, the Android Package, in [[checks-quizapp]]) or a gate-duration cap (`gate_seconds`), with a warning from 80 % and a failure at 100 %. Every project except [[checks-pipeline-check]] sets at least the gate-duration cap (300 s in [[checks-quizweb]], [[checks-workflow-memory]], [[checks-remote-terminal]] and [[checks-processing-sketches]]; 1200 s elsewhere).
- **Architecture imports** (`[architecture]`): forbidden packages in the pure folders. Active only in [[checks-quizapp]] (`core/src` may not import `android` or `androidx`) and [[checks-codex-pbar]] (`src/codex_pbar` may not import `requests`, `urllib` or `socket`).
- **ShellCheck** (`[shellcheck]`): 12 projects list `tools/hooks/pre-push` ([[checks-pipeline-check]] lists `consumer/pre-push` instead); every `.sh` file tracked by git is also checked.
- **GitHub state** (`[github]`, local mode only): last CI (continuous integration) run green and branch protection requiring the job ([[branch-protection-explained]]). Configured in [[checks-quizapp]], [[checks-quizweb]] (job `test`), [[checks-wiki]], [[checks-workflow-memory]] and [[checks-codex-pbar]] (both with an exception), [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]] and [[checks-status-quo]] (no exception; the repository is public since 2026-11-06 and its `main` requires the job `gate`, read with `gh api` on 2026-11-06); absent in the others. An exception is the setting `protection_exception = "reason"` in `[github]` (since pipeline-check v0.5.0, requirement PC-16): a missing protection is then reported as `aviso` (warning) with that reason instead of `falha` (failure), never as `ok`.
- **DORA (DevOps Research and Assessment) figures** (`[dora]`): delivery metrics from git, reported but never failing; set in nine projects.
- **Pre-push guard** (`[pre_push]`, [[branch-protection-explained]]): every project except [[checks-pipeline-check]].

Checkers inside a project's own gate:
- **Scratch-folder rule** ([[tmp-junk]], since 2026-11-07): [[checks-status-quo]], [[checks-pipeline-check]] and [[checks-quizapp]] fail when a test makes a temporary folder by hand instead of using the self-deleting helper (`crates/scratch.rs`, `tests/common/mod.rs`, JUnit `TemporaryFolder`), unless the line says `scratch-ok:` and why.
- **Mutation check**: [[mutation-check]] in [[checks-quizapp]] (`tools/mutation_check.py`, run only with `tools/quality_gate.sh --mutation` and in the weekly CI run), `mutants.py` in [[checks-pipeline-check]], `tools/mutation_check.py` in [[checks-codex-pbar]] and [[checks-codex-skills]].
- **Coverage thresholds**: 90 % of lines in the logic packages and no file below 80 % in [[checks-quizapp]]; at least 85 % in [[checks-codex-pbar]].
- **Content rules**: `wiki check` in [[checks-wiki]]; the event validator in [[checks-workflow-memory]]; `mb scan` in [[checks-machine-bootstrap]]; `skillsctl check` in [[checks-codex-skills]]; `content_manifest.py --check` and, since 2026-11-06, `check_fsp_cases.py` (the 34-step template of the simulated FSP exam cases, FSP being the Fachsprachprüfung, the German medical-language exam; [[check-fsp-cases]]) in the gate of [[checks-quizapp]] (its web-sync check runs at `promote` time, not in the gate).
- **Declared dependencies**: `check_dependencies.py` in [[checks-radiology-crawler]].
- **Rust rules and desktop test**: [[checks-status-quo]] runs formatting, Clippy (the Rust linter) with warnings denied, the workspace tests, its own boundary detector `tools/rust_architecture.rs` and resource checker `tools/resource_check.rs` (each with a self-test), traceability with a check that `docs/TRACEABILITY.md` is committed up to date, and the fitness limit. An optional step 6 runs the desktop end-to-end test `tools/ui_e2e.sh`, only when `STATUS_QUO_E2E=1` is set and the screen is declared free with `STATUS_QUO_E2E_SCREEN_IS_FREE=1`; without them the gate skips it.

## How it does it
`pipeline-check.toml` decides which sections exist; a project without a section simply does not get that checker. A `falha` fails the run, an `aviso` does not, and a check that could not run is `pulado`. [[security-layers]] groups the checkers that protect against leaks.

## Where it sits in the pipeline
It sits next to [[quality-gate-explained]] in step 3 of [[code-security-pipeline]].

## Who receives its output
Readers who want to know "which check protects this?" and the skill [[skill-revisao-manutencao]], which reads the same numbers.
