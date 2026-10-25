---
id: workflow-memory
title: workflow-memory (shared memory)
aliases: [memory, mem repo]
kind: project
project: none
status: active
location: workflow-memory:
fed_by: [claude-code]
feeds: []
sources: [workflow-memory:README.md, workflow-memory:docs/DESIGN.md]
reviewed: 2026-10-25T07:34Z
---

## What it is
workflow-memory is the shared, long-lived memory of all the Claude assistants Giovanni uses. A Claude chat normally forgets everything when it ends; this project is what lets a preference said once ("answer in the language I wrote in") still apply months later, in a different chat, on a different device. It is a public repository (`yujideluca/workflow-memory`, since 2026-10-25) and lives in `~/dev/workflow-memory`. It has no branch protection on purpose: its `mem` job pushes derived files to `main` and a required check would reject them, so the local pre-push check stands in and `pipeline-check.toml` records the exception ([[maintenance-pipeline]]). It replaced the retired protocol described in [[retired-workflow-pipeline]].

## What it does
It keeps preferences, facts, decisions and open items (things still to be done), and shows the relevant ones at the start of every chat as the [[session-brief]]. It is the only channel between the different Claude instances ([[claude-code]], the [[remote-assistant]] and the [[claude-app]]); this is decision ADR-0003 in [[memory-adrs]] (an ADR, "architecture decision record", is a short note that records one decision and its reasons).

## How it does it
The memory is a log: every entry is one new file that is never edited afterwards, stored in [[events-log]]. One function, [[memory-fold]], reads the whole log and works out the current state (the latest ruling for each topic wins). A GitHub Action ([[mem-action]], an automatic job on GitHub) regenerates the readable files in [[memory-views]]. Claude Code writes with the command [[mem]] and with three hooks ([[hook-session-start]], [[hook-prompt]], [[hook-stop]]); the Claude app writes through [[mem-github-connector]]. Everything is written in plain Python (only its standard library), and [[mem-validator]] keeps secrets and other people's contact data out.

## Where it sits in the pipeline
Under every other project: they read their defaults from it and report back with `mem use`.

## Who receives its output
Every Claude instance, through the brief; [[giovanni]], through the review file in [[memory-views]].
