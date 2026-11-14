---
id: checks-radiology-crawler
title: radiology-crawler: checkers and rules
aliases: [radiology crawler checks, radiology-report-matcher checks]
kind: decision
project: none
status: active
fed_by: []
feeds: []
sources: [radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:tests/test_web.py, radiology-crawler:tests/test_real_reports.py, radiology-crawler:tools/quality_gate.sh, radiology-crawler:pipeline-check.toml, radiology-crawler:CLAUDE.md, radiology-crawler:tools/check_dependencies.py, radiology-crawler:tests/test_cli_help.py, radiology-crawler:pipeline-check.version]
reviewed: 2026-11-14T23:13Z
---

## What it is
These are the checkers of the radiology crawler repository (`radiology-crawler`, named `radiology-report-matcher` in its config), the Python tools that collect and analyse public radiology text for the planned report matcher ([[radiology-report-matcher]], [[radiopaedia-crawler]]).

## What it does
The gate has five steps; the four listed here, and step 1b for the website, which the last update below describes: (0) `check_dependencies.py`: every third-party import appears in `requirements.txt` (or in `requirements-optional.txt` when it is used only inside a try block with a fallback), and every `pip install` in a workflow is `pip install -r requirements.txt` (rule in `CLAUDE.md`, added after a CI (continuous integration) run failed on a missing package); (1) `compileall` and the tests with pytest, among them `tests/test_cli_help.py`, which runs every runnable script in `analysis/` and `tools/` with `--help` and with an unknown option and fails when one does real work (exit code other than 0 for `--help` or 2 for the unknown option, or a tracked file changed; added 2026-11-06 after `--help` overwrote a report); (2) requirement traceability (AN, CW, DP, FA, TC, TL, WS groups); (3) fitness limits: no Python file over 800 lines, the gate at most 1200 seconds. Rules in `CLAUDE.md`, each with the tests that check it: the crawler obeys `robots.txt` (CW-1 to CW-3); each Codex call is a fresh session under 250,000 tokens (TL-2, TL-5); no personal or patient data in the repository or logs; downloaded pages and databases never go into git; the status of the statistical analysis is kept in `docs/plan.json`.

## How it does it
CI installs from `requirements.txt` and runs `pipeline-check --mode ci` (60 minutes at most), at the version pinned in `pipeline-check.version` (v0.8.0 since 2026-11-07, before v0.7.0, v0.6.0, v0.5.0 and v0.4.0). Its `pipeline-check.toml` has no GitHub section, so branch protection is not read there. Eleven files are in `docs/adr/` (architecture decision records, ADRs: short notes that keep the reasons for one structural decision).

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.

Update 2026-11-09: the gate also compiles the new `assistant/` package, and two requirements (AN-61, FA-4) are tested by `tests/test_finding_inventory.py`; the four gate steps are unchanged.

Update 2026-11-14: the gate now runs 355 tests and 98 requirements, all covered by tagged tests. The finding assistant added tests for the engine, scorer, segmenter, synonym lexicon and learned matcher (`tests/test_assistant_engine.py`, `tests/test_assistant_matcher.py`), and the batched rewrite tests in `tests/test_fabricate.py`. One test guards the training policy: the matcher refuses any row that is not from the tuning half (requirement AN-66). The principle on case text (CLAUDE.md, principle 13) was amended for the finding assistant; the four gate steps are unchanged.

Update 2026-11-14 (later): the gate now runs 363 tests and 101 requirements; `tests/test_assistant_dialog.py` covers FA-2, FA-3 and AN-67 (the dialog and its simulated-user scorer).

Update 2026-11-14 (reorganisation): the gate now runs 175 tests and 58 requirements. The code of the old diagnosis ranker moved to the folder `legacy/` with its 19 test files and 44 requirement rows, which the gate no longer runs or checks; the four gate steps are unchanged.

Update 2026-11-14 (website and real-report fact-check): the gate has a fifth step, "1b website", between the Python tests and the traceability step. It checks the first slice of the assistant's website ([[radiology-website]]): `mix format --check-formatted` and `mix test` for the back end written in Elixir (`mix` is Elixir's build tool), a compile of the page written in Elm, and `elm-test` for the page's tests. Where `mix`, `elm` or `elm-test` is not installed, that part is skipped and the gate prints a line starting with `NOTICE:` that says what was skipped, so a skip is never silent. The CI workflow now installs Elixir 1.18 with OTP (Open Telecom Platform, Elixir's runtime) 27 and Elm 0.19.1 with elm-test, so the step runs on GitHub. Step 1 also compiles `web/bridge`. The traceability step reads requirement tags only from the folder `tests/` (`pipeline-check.toml`), so the nine website requirements WS-6 to WS-14 are covered there by `tests/test_web.py`; the Elixir and Elm tests carry the same tags but are not counted. The three requirements of the literature fact-check of real reports, AN-76 to AN-78, are covered by six tests in `tests/test_real_reports.py` ([[radiology-real-report-factcheck]]). Numbers of the CI run on commit `600af44`: 215 Python tests, 11 Elixir tests and 10 Elm tests passed; `docs/REQUIREMENTS.md` has 75 rows.

Update 2026-11-14 (commit `7bbdaaa`): in the continuous-integration run on this commit the gate passed with 265 Python tests, 11 ExUnit tests and 14 Elm tests, and the traceability step counted 102 requirements. The new rows cover the second slice of the website (WS-15 to WS-20), the descriptor schemas and related diagnoses, and the held-out batch of real reports. The rules file `CLAUDE.md` now tells every session to commit by path, after two commits that day carried another session's staged files ([[radiology-report-matcher]]).
