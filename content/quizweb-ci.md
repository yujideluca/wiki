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
reviewed: 2026-10-22T16:33Z
---

## What it is
This is the GitHub Actions workflow of [[quizweb]] (file `.github/workflows/test.yml`). [GitHub Actions](https://docs.github.com/en/actions) runs automatic jobs on GitHub's computers; this job is CI (continuous integration), the automatic checks on every change.

## What it does
It runs the whole web test suite on every push and pull request (a proposal to merge a change): domain, shared conformance vectors, content, i18n and architecture rules.

## How it does it
It uses the test runner built into Node 22 (`npm test` = `node --test`), so there are no dependencies to install.

## Where it sits in the pipeline
After every push to [[github]].

## Who receives its output
[[github]].
