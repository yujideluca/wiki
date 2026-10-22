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
---

## What it is
The catalogue of every testable promise of [[quizapp]], each with an ID (SP-1 spacing, GR-1 grading, QU-1 queue, DG-* daily goal, QP-* question pool…), plus the test strategy in `docs/TESTING.md` (ADR-0008, requirements-first QA).

## What it does
Says what must hold and at which level it is tested: unit, integration, property, cross-platform conformance, acceptance on a device, mutation-checked. `docs/TRACEABILITY.md` (generated) maps each requirement to its tests.

## How it does it
A behaviour Giovanni states becomes a row first; then a test tagged `REQ <ID>`; then code. [[check-traceability]] fails when a requirement has no test.

## Where it sits in the pipeline
The first step of [[quizapp-release]].

## Who receives its output
[[check-traceability]] and every test author.
