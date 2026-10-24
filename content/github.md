---
id: github
title: GitHub
aliases: [github.com, yujideluca]
kind: external
project: none
status: active
fed_by: [mem-sync, quizapp-ci, quizweb-ci, wiki-cli, wiki-quality-gate]
feeds: []
reviewed: 2026-10-22
---

## What it is
[GitHub](https://github.com/) is a website that stores programmers' projects online and keeps the full history of every change (it is built on [Git](https://git-scm.com/), the version-control tool). A project stored this way is called a repository. All of Giovanni's repositories live under the account `yujideluca`: german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template and this wiki. Those that hold anything personal are private.

## What it does
It hosts the code, runs the automatic checks called CI (continuous integration) through GitHub Actions, serves static websites ([[github-pages]]), and is the bridge that lets the [[claude-app]] write to the memory ([[mem-github-connector]]).

## How it does it
[[claude-code]] uploads (pushes) over SSH (Secure Shell, an encrypted login method that uses keys instead of passwords). It never force-pushes, which would overwrite history on the server; this is a standing preference of Giovanni.

## Where it sits in the pipeline
It is the off-laptop backup and the meeting point of every project.

## Who receives its output
The Claude instances, [[github-pages]] and the phone's update check ([[update-client]]).
