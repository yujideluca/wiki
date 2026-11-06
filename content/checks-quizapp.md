---
id: checks-quizapp
title: QuizApp: checkers and rules
aliases: [german-quiz checks, QuizApp gate]
kind: decision
project: quizapp
status: active
fed_by: []
feeds: []
sources: [QuizApp:tools/quality_gate.sh, QuizApp:tools/check_fsp_cases.py, QuizApp:pipeline-check.toml, QuizApp:CLAUDE.md, QuizApp:.github/workflows/quality-gate.yml, QuizApp:tools/check_coverage.py, QuizApp:tools/mutation_check.py, QuizApp:tools/check_tests_updated.sh, QuizApp:tools/check_web_sync.sh]
reviewed: 2026-11-06T23:20Z
---

## What it is
These are the checkers and rules of [[quizapp]], the Android study app (repository `german-quiz`, folder `QuizApp`). It has the largest gate of all projects and the only ones that protect a release going to a phone.

## What it does
The gate has seven steps plus an optional eighth, in this order: (1) core and app tests with coverage; (2) coverage thresholds, 90 % of lines in the logic packages and no file below 80 % (`tools/check_coverage.py`); (3) the web twin's tests; (4) the shared conformance vectors `scheduler` and `daily_bar` must be byte-identical in app and web ([[quizweb-conformance]]); (5) requirement traceability, which also fails when the regenerated `docs/TRACEABILITY.md` is not committed; (6) Android lint, where errors fail; (7) fitness functions, the question-pool manifest check ([[content-manifest]]) and, since 2026-11-06, the template check of the simulated FSP exam cases ([[check-fsp-cases]]; FSP is the Fachsprachprüfung, the German medical-language exam); a time cap of 1200 seconds ends the gate; (8) with `--mutation`, planted faults in the scheduler, grader, queue, session, stores and web twin must all be caught: 43 faults in the app and 9 in the web twin on 2026-11-06, one change each, restored after the run ([[mutation-check]]). The last change to this list (2026-11-06, commit 50ab2a6) added 7 app faults for the FSP case grading and play ([[fsp-case]]); the change before it (2026-11-02, commit 5667133) rewrote the web daily-goal fault so that it matches the guarded line `goal > 0 ? clamp(answered / goal, 0, 1)`.

Limits in `pipeline-check.toml`: no Kotlin file over 400 lines (in `core/src` and `app/src`), the release APK (Android package) at most 3,000,000 bytes, the gate at most 1200 seconds, and no import of `android` or `androidx` in the module `core` (the pure-core rule, ADR-0009 (an architecture decision record)). Release rules: a version may be promoted from beta to stable only after the gate with mutation and `tools/check_tests_updated.sh` (code changed, so a test must have changed too, ADR-0011), and `tools/check_web_sync.sh` confirms the web twin matches ([[check-web-sync]], [[check-tests-updated]]). The text check `check_errors_languagetool.py` has its own page ([[check-errors-languagetool]]). The spacing rules (ADR-0007) come first and are guarded by named tests. Fourteen ADRs are listed in [[quizapp-adrs]].

## How it does it
CI (continuous integration) runs the same gate through `pipeline-check` on every push and pull request, and every Monday with the mutation check ([[quizapp-ci]]). It checks out the web branch `web-<versionName>` when it exists, otherwise `main`. The CI job `gate` is a required check on `main` ([[maintenance-pipeline]]). More detail: [[quizapp-quality-gate]], [[quizapp-requirements]].

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
