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
reviewed: 2026-10-24T22:03Z
---

## What it is
This is the GitHub Actions workflow of [[quizapp]] (file `.github/workflows/quality-gate.yml`). [GitHub Actions](https://docs.github.com/en/actions) runs automatic jobs on GitHub's computers. This workflow is CI (continuous integration): it runs the [[quizapp-quality-gate]] on every change and shows a green or red mark.

## What it does
On every push and pull request (a proposal to merge a change) it runs the full gate without the mutation check. Every Monday it runs it with the mutation check, so a test that stopped protecting a rule shows up within a week. After pushing, the run must be green.

## How it does it
It sets up Java 21, Gradle and Node 22 (a JavaScript runtime), checks out the matching branch of the web twin (`web-<versionName>` if it exists, otherwise `main`), then runs [[pipeline-check]], which runs the same gate script as on the laptop once and adds the architecture, fitness and report checks. A `falha` (failure) fails the job `gate`, which GitHub's branch protection should require.

## Where it sits in the pipeline
After every push to [[github]].

## Who receives its output
[[github]] (the green or red mark) and Claude, who must check it.
