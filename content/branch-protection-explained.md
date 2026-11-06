---
id: branch-protection-explained
title: Branch protection and the pre-push hook explained
aliases: [pre-push hook, required check, branch protection]
kind: hook
project: none
status: active
location: project-template:tools/hooks/pre-push
fed_by: []
feeds: []
sources: [project-template:tools/hooks/pre-push, pipeline-check:src/lib.rs, workflow-memory:pipeline-check.toml, codex-pbar:pipeline-check.toml, machine-bootstrap:DESIGN.md]
reviewed: 2026-11-06T21:24Z
---

## What it is
A branch is a line of work in Git; `main` is the line that counts as the official version. Branch protection is a GitHub setting that refuses changes to `main` until named checks are green (here: the CI (continuous integration) job `gate`). A hook is a small program that runs automatically on an event; the pre-push hook runs just before `git push` sends commits away.

## What it does
Two guards protect `main`. On GitHub, the job `gate` is a required check ([[ci-explained]]). On the laptop, `tools/hooks/pre-push` runs `pipeline-check --pre-push`, which runs the gate and stops the push of `main` when a check fails; `[pre_push] guard` in `pipeline-check.toml` lists path prefixes so that a push touching only other files is not checked. It is turned on once per clone with `git config core.hooksPath tools/hooks` and bypassed on purpose with `git push --no-verify`. The wider rule "never force-push" is a standing preference in the memory.

## How it does it
Branch protection is free only on public repositories (GitHub Free refuses it on private ones with error 403), so the private ones rely on the hook. The report check `protecao-de-branch` reads the live setting with the `gh` command. A project that cannot have the protection records why in `protection_exception` in its `pipeline-check.toml`, and the check then reports `aviso`, never `ok`. Today two projects declare an exception: [[checks-workflow-memory]] (its `mem` job pushes to `main` with GitHub's built-in token, which a required check would reject) and [[checks-codex-pbar]] (private repository on the free plan).

## Where it sits in the pipeline
Step 1 of [[code-security-pipeline]], with the wider policy in [[maintenance-pipeline]].

## Who receives its output
The person or session pushing: a refused push names the failing check.
