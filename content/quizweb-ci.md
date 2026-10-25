---
id: quizweb-ci
title: QuizWeb CI (GitHub Actions)
aliases: [web tests workflow]
kind: service
project: quizweb
status: active
location: QuizWeb:.github/workflows/test.yml
fed_by: []
feeds: [github]
sources: [QuizWeb:.github/workflows/test.yml]
reviewed: 2026-10-24T22:03Z
---

## What it is
This is the GitHub Actions workflow of [[quizweb]] (file `.github/workflows/test.yml`). [GitHub Actions](https://docs.github.com/en/actions) runs automatic jobs on GitHub's computers; this job is CI (continuous integration), the automatic checks on every change.

## What it does
It runs the whole web test suite on every push and pull request (a proposal to merge a change): domain, shared conformance vectors, content, i18n and architecture rules. Then [[pipeline-check]] checks the project's limits: no source file over 600 lines, the gate under 300 seconds, and `shellcheck` on the scripts; a `falha` (failure) fails the job.

## How it does it
It sets up Node 22 and Rust (with a cache for the built program) and runs `tools/pipeline-check.sh --mode ci`, which runs `tools/quality_gate.sh` once and then adds the fitness checks. The gate uses the test runner built into Node 22 (`npm test` = `node --test`), so the web code has no dependencies to install; Rust is needed only to build [[pipeline-check]]. The job is named `test`, and GitHub's branch protection should require it.

## Where it sits in the pipeline
After every push to [[github]].

## Who receives its output
[[github]].
