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
sources: [pipeline-check:src/traceability.rs]
---

## What it is
Requirement traceability means being able to follow every promise a program makes to the test that checks it. This check is shared by all projects: every requirement has a test, and every test tag names a real requirement.

## What it does
It reads the requirement IDs from `docs/REQUIREMENTS.md`, collects the `REQ <ID>` tags (comments such as `REQ GR-1`) from the test folders, and fails if a requirement has no tagged test or a tag names a requirement that does not exist. It writes `docs/TRACEABILITY.md`, a table that maps each requirement to its test files.

## How it does it
It is a subcommand of the [[pipeline-check]] program (written in Rust, option `--traceability`, available since version v0.3.0). Every project runs it through its own pinned runner script `tools/pipeline-check.sh`; it replaced `check_traceability.py`, which used to be copied into each repository. Each project lists its test folders, file extensions and an optional label in a `[traceability]` section of `pipeline-check.toml` (QuizApp: Kotlin and JavaScript, with the web twin's tests labelled `web`; the wiki: Elixir and Elm).

## Where it sits in the pipeline
Step 2 of every quality gate.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]] and [[wiki-quality-gate]].
