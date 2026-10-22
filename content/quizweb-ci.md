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
---

## What it is
The GitHub Actions workflow of [[quizweb]].

## What it does
Runs the whole web test suite on every push and pull request: domain, shared conformance vectors, content, i18n and architecture rules.

## How it does it
Node 22's built-in test runner (`npm test` = `node --test`), no dependencies to install.

## Where it sits in the pipeline
After every push to [[github]].

## Who receives its output
[[github]].
