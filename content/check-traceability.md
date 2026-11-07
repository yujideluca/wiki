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
sources: [pipeline-check:src/traceability.rs, pipeline-check:tests/traceability.rs, pipeline-check:DESIGN.md]
reviewed: 2026-11-07T22:47Z
---

## What it is
Requirement traceability means being able to follow every promise a program makes to the test that checks it. This check is shared by all projects: every requirement has a test, and every test tag names a real requirement.

## What it does
It reads the requirement IDs from `docs/REQUIREMENTS.md`, collects the `REQ <ID>` tags (comments such as `REQ GR-1`) from the test folders, and fails if a requirement has no tagged test or a tag names a requirement that does not exist. It writes `docs/TRACEABILITY.md`, a table that maps each requirement to its test files.

An ID is exactly two capital letters, a dash and a number, such as `AN-29`. Since version v0.6.0 (requirement PC-17, 2026-11-07) a first table cell or a word after `REQ ` that looks like an ID but has another shape (`AN-V2-1`, `C4-CLIN-1`, `AB-1a`) fails the check, and the message names it and the expected shape. Before, such an ID was skipped without a message, so its requirement and its tests were never checked: this happened to radiology's V2 rows, and the gate failed later at the matrix comparison, far from the cause. Punctuation right after an ID, as in `REQ AB-1: what it checks`, ends the ID and is allowed.

## How it does it
It is a subcommand of the [[pipeline-check]] program (written in Rust, option `--traceability`, available since version v0.3.1). Every project runs it through its own pinned runner script `tools/pipeline-check.sh`; it replaced `check_traceability.py`, which used to be copied into each repository. Each project lists its test folders, file extensions and an optional label in a `[traceability]` section of `pipeline-check.toml` (QuizApp: Kotlin and JavaScript, with the web twin's tests labelled `web`; the wiki: Elixir and Elm).

## Where it sits in the pipeline
Step 2 of every quality gate.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]] and [[wiki-quality-gate]].
