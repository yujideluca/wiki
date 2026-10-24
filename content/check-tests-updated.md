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
`check_tests_updated.sh` is the check behind decision ADR-0011 (an ADR is an architecture decision record, a short note that keeps the reasons for a decision). The rule: a new version of [[quizapp]] may reach users only if it survived tests that were updated for what it changes. Otherwise old tests could pass while the new behaviour is not tested at all.

## What it does
It compares the commit about to be published with the last stable release. If code or content changed but no test changed, it refuses and exits with code 1.

## How it does it
A [Bash](https://www.gnu.org/software/bash/) script over `git diff --name-only BASE HEAD` (the list of files that differ between two points in history), which separates main code from test folders.

## Where it sits in the pipeline
Run by `promote` in [[publish-apk]], as part of the [[quizapp-release]].

## Who receives its output
[[publish-apk]].
