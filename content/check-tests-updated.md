---
id: check-tests-updated
title: check_tests_updated.sh
aliases: [tests updated check]
kind: script
project: quizapp
status: active
location: QuizApp:tools/check_tests_updated.sh
fed_by: []
feeds: [publish-apk]
sources: [QuizApp:tools/check_tests_updated.sh]
---

## What it is
The check behind ADR-0011: a new version may reach users only when it survived tests that were updated for what it changes.

## What it does
Compares the commit to publish with the last stable release: if code or content changed and no test changed, it refuses (exit 1).

## How it does it
Bash over `git diff --name-only BASE HEAD`, separating main code from test folders.

## Where it sits in the pipeline
Run by [[publish-apk]] `promote`, part of [[quizapp-release]].

## Who receives its output
[[publish-apk]].
