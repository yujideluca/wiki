---
id: quizapp-ci
title: QuizApp CI (GitHub Actions)
aliases: [quality-gate workflow]
kind: service
project: quizapp
status: active
location: QuizApp:.github/workflows/quality-gate.yml
fed_by: [quizapp-quality-gate, pipeline-check]
feeds: [github]
sources: [QuizApp:.github/workflows/quality-gate.yml]
---

## What it is
The GitHub Actions workflow of [[quizapp]]: it runs [[quizapp-quality-gate]] on GitHub's machines.

## What it does
Every push and pull request: the full gate without mutation. Every Monday: with the mutation check, so a test that stopped protecting a rule shows up within a week. After pushing, the run must be green.

## How it does it
Sets up Java 21, Gradle and Node 22, checks out the matching web branch (`web-<versionName>` if it exists, else `main`), then runs [[pipeline-check]], which runs the same gate script as the laptop once and adds the architecture, fitness and report checks; a `falha` fails the job `gate`, which branch protection should require.

## Where it sits in the pipeline
After every push to [[github]].

## Who receives its output
[[github]] (the green or red mark) and Claude, who must check it.
