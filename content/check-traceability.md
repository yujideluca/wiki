---
id: check-traceability
title: check_traceability.py
aliases: [traceability gate, REQ tags check]
kind: script
project: project-template
status: active
location: project-template:tools/check_traceability.py
fed_by: [quizapp-requirements, wiki-requirements]
feeds: [quizapp-quality-gate, template-quality-gate]
sources: [project-template:tools/check_traceability.py, QuizApp:tools/check_traceability.py, wiki:tools/check_traceability.py]
---

## What it is
The requirement-traceability gate shared by all projects: every requirement has a test, and every test tag names a real requirement.

## What it does
Reads the IDs from `docs/REQUIREMENTS.md`, collects `REQ <ID>` tags from the test folders, fails on a requirement without a tagged test or an unknown tag, and writes `docs/TRACEABILITY.md` (requirement → test files).

## How it does it
Python standard library; each project sets its own `TEST_DIRS` and file extensions (QuizApp: Kotlin and JS; the wiki: Elixir and Elm).

## Where it sits in the pipeline
Step 2 of every quality gate.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]], [[wiki-quality-gate]].
