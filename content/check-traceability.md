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
The requirement-traceability check shared by all projects: every requirement has a test, and every test tag names a real requirement.

## What it does
Reads the IDs from `docs/REQUIREMENTS.md`, collects `REQ <ID>` tags from the test folders, fails on a requirement without a tagged test or an unknown tag, and writes `docs/TRACEABILITY.md` (requirement → test files).

## How it does it
A subcommand of the [[pipeline-check]] program (Rust, `--traceability`, since v0.3.0) that every project runs through its pinned `tools/pipeline-check.sh`; it replaced the `check_traceability.py` that was copied into each repository. Each project lists its test folders, file extensions and an optional label in a `[traceability]` section of `pipeline-check.toml` (QuizApp: Kotlin and JS, with the web twin's tests labelled `web`; the wiki: Elixir and Elm).

## Where it sits in the pipeline
Step 2 of every quality gate.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]], [[wiki-quality-gate]].
