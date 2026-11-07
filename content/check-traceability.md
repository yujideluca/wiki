---
id: check-traceability
title: pipeline-check --traceability
aliases: [traceability gate, REQ tags check, check_traceability.py]
kind: script
project: project-template
status: active
location: pipeline-check:src/traceability.rs
fed_by: [quizapp-requirements, wiki-requirements]
feeds: [quizapp-quality-gate, template-quality-gate]
sources: [pipeline-check:src/traceability.rs, pipeline-check:tests/traceability.rs, pipeline-check:DESIGN.md, pipeline-check:docs/REQUIREMENTS.md]
reviewed: 2026-11-07T23:39Z
---

## What it is
Requirement traceability means being able to follow every promise a program makes to the test that checks it. This check is shared by all projects: every requirement has a test, and every test tag names a real requirement.

## What it does
It reads the requirement IDs from `docs/REQUIREMENTS.md`, collects the `REQ <ID>` tags (comments such as `REQ GR-1`) from the test folders, and fails if a requirement has no tagged test or a tag names a requirement that does not exist. It writes `docs/TRACEABILITY.md`, a table that maps each requirement to its test files.

An ID is exactly two capital letters, a dash and a number, such as `AN-29`. Since version v0.7.0 the check never skips anything without a message (requirements PC-17 and PC-18, 2026-11-07):

- Every table row of the requirements file must be the header (first cell `ID`), the separator line, or a requirement with an ID and a text. Any other row, a row with empty text, and an ID listed twice fail, with the line number. A `|` written as `\|` or inside backticks stays part of the text.
- A tag is the word `REQ` and the IDs, as the first word of a comment, also a comment after code on the same line (`#[test] // REQ SQ-5`), or as the first word of a string such as a docstring or a test name (`"""REQ PB-9: ..."""`, `describe "REQ AR-1: ..."`). IDs are separated by spaces, commas or semicolons, and a repeated `REQ` continues the list (`# REQ AN-33; REQ AN-35`). Punctuation right after an ID ends it (`REQ AB-1: what it checks`).
- Any other `REQ` or `req` followed by something shaped like an ID (outside backticks and outside strings), a `REQ` with no ID, and an ID of another shape (`AN-V2-1`, `C4-CLIN-1`, `AB-1a`) fail, named with file and line.
- A configured test folder that does not exist is exit 2 (an input problem), not an empty pass.

Why: radiology's V2 requirements were named `AN-V2-1..3`. The old parser skipped them without a message, the regenerated table lost them, and the gate failed later at the table comparison, far from the cause. An audit of all projects then found tags after code (status-quo, QuizApp), in docstrings (codex-pbar), in Elm test names (the wiki) and after a second `REQ` that were also never read. All twelve projects pin v0.8.0 (v0.7.0 plus PC-19, see [[pipeline-check]]) since 2026-11-07.

## How it does it
It is a subcommand of the [[pipeline-check]] program (written in Rust, option `--traceability`, available since version v0.3.1). Every project runs it through its own pinned runner script `tools/pipeline-check.sh`; it replaced `check_traceability.py`, which used to be copied into each repository. Each project lists its test folders, file extensions and an optional label in a `[traceability]` section of `pipeline-check.toml` (QuizApp: Kotlin and JavaScript, with the web twin's tests labelled `web`; the wiki: Elixir and Elm).

## Where it sits in the pipeline
Step 2 of every quality gate.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]] and [[wiki-quality-gate]].
