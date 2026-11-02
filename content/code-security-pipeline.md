---
id: code-security-pipeline
title: Code structure and security pipeline (start here)
aliases: [engineering overview, code and security map]
kind: process
project: none
status: active
fed_by: []
feeds: []
sources: [project-template:README.md, project-template:CLAUDE.md, pipeline-check:src/lib.rs, wiki:docs/adr/0003-login-gate-and-decoy.md, workflow-memory:mem/privacy-patterns.tsv]
reviewed: 2026-11-02T10:44Z
---

## What it is
This is the entry node of a small set of pages that explain how Giovanni's software is built and protected. Every project follows the same recipe: a fixed folder layout ([[repository-layout]]), a script that decides whether the code passes ([[quality-gate-explained]]), automatic checks on every upload ([[ci-explained]]), written decisions ([[adr-explained]]), and a safety net against leaking secrets ([[security-layers]]). The pages below explain each idea from zero and then list the checkers and rules that belong to each project.

## Flow
trigger t1: Someone changes code and pushes it | [[branch-protection-explained]]
step s1: The local pre-push check runs the gate before main is pushed | [[branch-protection-explained]]
step s2: Automatic checks on GitHub run the same gate | [[ci-explained]]
step s3: The gate runs tests, requirement tags, mutation and size limits | [[quality-gate-explained]]
step s4: The secret scanners look for keys, tokens and personal data | [[security-layers]]
decide d1: Does any check fail?
step s5: The push or merge is stopped and the change is fixed
step s6: The change is accepted and any structural decision is written as a record | [[adr-explained]]
product p1: A change that passed every project check | [[checker-catalog]]
product p2: A blocked change with the failing check named

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p2
s6 -> p1

## What it does
It gives a new reader a map in three layers. Layer 1 explains the shared ideas: [[ci-explained]], [[adr-explained]], [[quality-gate-explained]], [[branch-protection-explained]] and [[security-layers]]. Layer 2 is the shared structure: [[repository-layout]] and the full list of checkers in [[checker-catalog]]. Layer 3 is one page per project with the checkers and rules that only that project has: [[checks-quizapp]], [[checks-quizweb]], [[checks-wiki]], [[checks-workflow-memory]], [[checks-pipeline-check]], [[checks-codex-pbar]], [[checks-codex-skills]], [[checks-machine-bootstrap]], [[checks-remote-terminal]], [[checks-processing-sketches]], [[checks-radiology-crawler]], [[checks-status-quo]] and [[checks-project-template]].

## How it does it
The shared recipe lives in [[project-template]]; the measuring program [[pipeline-check]] lives in its own repository and each project pins a version of it. The process around it is described in [[maintenance-pipeline]] and [[maintenance-policy]].

## Where it sits in the pipeline
It sits above the project pages and next to [[system-overview]], which shows the whole system rather than the engineering part.

## Who receives its output
[[giovanni]], and every Claude session that needs to know which check protects what.

## Steps
1. A change is pushed. Actor: Giovanni or a Claude session. Output: a commit on a branch.
2. The pre-push hook on the laptop runs the project gate before `main` is pushed. Output: a stopped or allowed push.
3. GitHub Actions runs the same gate. Output: a green or red mark and a `report.json` for projects that use [[pipeline-check]].
4. The gate runs the project's tests and its checkers (see [[checker-catalog]]). Output: pass or the first failing check.
5. Secret and privacy scanners run in the gate or when content is published ([[security-layers]]). Output: a refusal that names the kind of secret, never its value.
6. A structural decision becomes an ADR (architecture decision record) and a row in the decision log ([[adr-explained]]). Output: a file in `docs/adr/`.
