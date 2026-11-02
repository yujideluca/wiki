---
id: ci-explained
title: CI (continuous integration) explained
aliases: [continuous integration, GitHub Actions, CI explained]
kind: service
project: none
status: active
location: project-template:.github/workflows/quality-gate.yml
fed_by: []
feeds: []
sources: [project-template:.github/workflows/quality-gate.yml, QuizApp:.github/workflows/quality-gate.yml, workflow-memory:.github/workflows/mem.yml, QuizWeb:.github/workflows/test.yml]
reviewed: 2026-11-02T10:44Z
---

## What it is
CI (continuous integration) means that every time someone pushes a change, a computer that is not the author's runs the checks again from a clean state ([continuous integration](https://en.wikipedia.org/wiki/Continuous_integration)). It catches the case "it works on my machine" and gives a green or red mark on the change. Giovanni's projects use [GitHub Actions](https://docs.github.com/en/actions), which runs jobs described in files under `.github/workflows/` on GitHub's computers.

## What it does
In nearly every project the workflow `quality-gate.yml` has one job named `gate`. It runs on every push and pull request (a proposal to merge a change) and can also be started by hand (`workflow_dispatch`). The job installs the project's tools, then runs `tools/pipeline-check.sh --mode ci`, which runs the project's gate once and adds the shared checks of [[pipeline-check]]; it uploads `report.json` as an artifact (a file kept with the run). Job time limits differ: 20 minutes in [[checks-remote-terminal]] and [[checks-processing-sketches]], 30 in [[checks-wiki]] and [[checks-pipeline-check]], 60 in [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-radiology-crawler]] and [[checks-status-quo]], 120 in [[checks-quizapp]].

Four projects differ. [[checks-pipeline-check]] cannot check itself with a pinned copy, so its job runs `tools/quality_gate.sh` directly. [[checks-quizweb]] names its job `test` and runs the plain test suite. [[checks-quizapp]] also runs weekly (Mondays) with the slow mutation check. [[checks-workflow-memory]] has two workflows: `quality-gate.yml` for the code of the memory tools and `mem.yml`, which processes memory events and has an extra job named `append-only`.

## How it does it
The workflow file is read by GitHub from the repository; the gate script is the same one that runs on the laptop, so CI and a laptop run cannot disagree about what passing means. A CI run alone does not stop a merge; [[branch-protection-explained]] explains what makes the job binding.

## Where it sits in the pipeline
Step 2 of [[code-security-pipeline]], after the local pre-push check and before the change is accepted. Project-specific detail is in [[quizapp-ci]] and [[quizweb-ci]].

## Who receives its output
[[github]] (the mark on the commit) and the Claude session, which must check that the run on its exact commit is green.
