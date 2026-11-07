---
id: tmp-junk
title: Leftover test folders in /tmp, and the rule that stops them
aliases: [tmp junk, scratch folders, scratch-ok]
kind: decision
project: none
status: active
since: 2026-11-07
location: status-quo:crates/scratch.rs
fed_by: []
feeds: []
sources: [status-quo:crates/scratch.rs, status-quo:tools/quality_gate.sh, pipeline-check:tests/common/mod.rs, pipeline-check:tools/quality_gate.sh, QuizApp:tools/quality_gate.sh, QuizApp:app/src/test/java/dev/yuji/quiz/data/ContentUpdaterTest.kt, wiki-bench:map_bench.py]
reviewed: 2026-11-07T18:36Z
---

## What it is
A rule for automated tests in Giovanni's projects: a test never makes a temporary folder by hand. It takes the folder from a small helper that deletes it when the test ends. Each project's quality gate (the script that decides whether a change may go in) checks this rule. Every line that still makes a temporary folder by hand fails the gate unless it carries the comment `scratch-ok:` saying why that is safe.

## What it does
It keeps `/tmp` from filling up. On the laptop `/tmp` is a *tmpfs*, a file system held in memory (RAM), so every leftover file takes memory. The system service `systemd-tmpfiles` clears only files older than 10 days (the rule `q /tmp 1777 root root 10d`). The laptop had been running for 9 days, so nothing had been cleared yet.

On 2026-11-07 `/tmp` held about 6,000 entries and used 5.4 GB of the 12 GB of memory set aside for it. The sources were:

- **Benchmark browser profiles (2.3 GB).** `wiki-bench/map_bench.py` started Chrome with a fresh profile folder per run. Since 2026-11-06 it removes that folder at the end (`shutil.rmtree` in a `finally` block, so it also runs after an error). The 76 profiles left over are all older than that fix ([[map-benchmark]]).
- **Claude Code's own scratch folder (1.1 GB),** `/tmp/claude-1000`, which also held 12 old benchmark profiles.
- **QuizApp unit tests (208 MB, 420 folders `content…`).** `ContentUpdaterTest` made one folder per test with `Files.createTempDirectory` and never removed it.
- **pipeline-check tests (41 MB, 1,411 folders `pc-…`)** and **Status Quo tests (543 folders `sq-…`).** Each test built `/tmp/<name>-<process number>` by hand. The process number changes on every run, so a folder that was not removed was never reused or removed later. Some tests never removed their folder, and the others removed it only when they passed.
- **About 3,000 `agent-guard-…` folders (30 MB)** from tests run on 2026-11-03 and 2026-11-04. No project on the laptop still contains that code, so these do not come back.

Chrome's own `com.google.Chrome.*` folders and `wl-copy-buffer` files (from the clipboard tool) are empty or tiny.

## How it does it
The cause was the same everywhere: the test code built its own folder path and relied on removing it at the end. A failed test skips its last lines, and some tests never removed the folder at all. The fix ties removal to the helper's lifetime, so no line at the end of a test is needed:

- **Status Quo:** `crates/scratch.rs` defines `Scratch`. Every crate's tests include this one file through `#[path = "../../scratch.rs"]`, so no extra crate or library is needed. `Scratch::new("prefix")` creates `/tmp/prefix-<process>-<counter>`. When the value goes out of scope, Rust runs its `Drop` code, which removes the folder. Rust also does this while a failed assertion unwinds, so failed tests clean up too. Gate step 1b fails on any other `temp_dir()` line without `scratch-ok:`. Three lines carry it: a path that is never created, an existing folder, and the Windows setup program, whose unpacked copy must stay after the installer exits.
- **pipeline-check:** the same `Scratch` lives in `tests/common/mod.rs`, and gate step 0 applies the same rule.
- **QuizApp (Kotlin):** `ContentUpdaterTest` removes its folder in an `@After` method, and `UpdateClientTest` uses JUnit's `TemporaryFolder` rule. The gate fails on any `createTempDirectory` or `createTempFile` in test sources without `scratch-ok:`.

Setting the environment variable `KEEP_SCRATCH=1` keeps the Rust test folders so that a failure can be inspected. Each rule was checked by planting a stray line, which the gate refused, and by counting the folders in `/tmp` before and after a full test run: the count did not change.

## Where it sits in the pipeline
The rule is part of the quality gates in [[checks-status-quo]], [[checks-pipeline-check]] and [[quizapp-quality-gate]]. Those gates run before every push and in continuous integration (CI, the automatic checks on GitHub). The workflow-memory preference `tests.scratch-folders` records the rule for new code in any project.

## Who receives its output
Developers and agents writing tests: a gate failure names the file and line that makes a temporary folder by hand. The laptop gains back the memory that the leftovers used.
