---
id: quizapp-requirements
title: QuizApp requirements and traceability
aliases: [REQUIREMENTS.md, TESTING.md, REQ tags]
kind: data
project: quizapp
status: active
location: QuizApp:docs/REQUIREMENTS.md
fed_by: []
feeds: [check-traceability]
sources: [QuizApp:docs/REQUIREMENTS.md, QuizApp:docs/TESTING.md, QuizApp:core/src/test, QuizApp:app/src/test]
reviewed: 2026-10-25T02:04Z
---

## What it is
A requirement is a testable promise of the program, for example "a wrong answer on a new card comes back after 10 minutes". This catalogue lists every testable promise of [[quizapp]], each with an ID (SP-1 spacing, GR-1 grading, QU-1 queue, DG-* daily goal, QP-* question pool, and so on), together with the test strategy in `docs/TESTING.md` (decision ADR-0008, "requirements-first quality assurance"; an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## What it does
It says what must hold and at which level each promise is tested: unit (one piece), integration (pieces together), property (many random inputs), cross-platform conformance (app and web agree), acceptance on a device, and mutation-checked. The generated file `docs/TRACEABILITY.md` maps each requirement to its tests.

## How it does it
A behaviour Giovanni states becomes a row first; then a test tagged `REQ <ID>` is written; then the code. The [[check-traceability]] check fails when a requirement has no test.

## Where it sits in the pipeline
The first step of the [[quizapp-release]].

## Who receives its output
[[check-traceability]] and every test author.
