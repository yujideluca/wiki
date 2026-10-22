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
Where all of Giovanni's repositories live (account `yujideluca`): german-quiz, german-quiz-web, german-quiz-releases, workflow-memory, project-template and wiki (private where they hold anything personal).

## What it does
Hosts the code, runs CI (GitHub Actions), serves [[github-pages]], and is the bridge the [[claude-app]] uses to write memory ([[mem-github-connector]]).

## How it does it
Claude Code pushes over SSH; never force-push (a standing preference).

## Where it sits in the pipeline
The off-laptop backup and meeting point of every project.

## Who receives its output
The Claude instances, [[github-pages]] and the phone's update check ([[update-client]]).
