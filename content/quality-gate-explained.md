---
id: quality-gate-explained
title: Quality gate, requirements, mutation and fitness explained
aliases: [quality gate explained, gate explained, fitness functions explained]
kind: script
project: project-template
status: active
location: project-template:tools/quality_gate.sh
fed_by: []
feeds: []
sources: [project-template:tools/quality_gate.sh, project-template:pipeline-check.toml, pipeline-check:src/lib.rs, pipeline-check:src/traceability.rs]
reviewed: 2026-11-07T23:39Z
---

## What it is
A quality gate is one script, `tools/quality_gate.sh`, that decides whether a project "passes". It exits with 0 when everything is fine and with another number (an exit code) when something fails. It is the single definition of passing: the laptop, the publish scripts and [[ci-explained]] all run the same file ([[template-quality-gate]] is the blank form).

## What it does
A gate usually has three kinds of step, explained here once:
- **Tests**: the project's own test suite (unit tests, property tests, conformance tests).
- **Requirement traceability**: every promise in `docs/REQUIREMENTS.md` has an ID, and a test carries the tag `REQ <ID>` ([[check-traceability]]). A promise without a test, or a tag for a promise that does not exist, fails; since pipeline-check v0.7.0 so does an ID that is not two capital letters, a dash and a number, and any table row or `REQ` mention that cannot be read.
- **Mutation check**: the script plants a small fault on purpose in a copy of the code (for example changing a number) and demands that at least one test fails; a fault that survives means a test is missing ([[mutation-check]]).
- **Fitness functions**: automatic limits on a design quality, such as the largest file, the size of the app or how long the gate takes. A fitness function warns from 80 % of its limit and fails at 100 % ([[fitness-check]]).
- **Shell lint**: [ShellCheck](https://www.shellcheck.net/) reads the project's shell scripts for mistakes.
- **DORA figures**: DORA (DevOps Research and Assessment) delivery metrics computed from git; they are reported, never failing ([[pipeline-check]]).

## How it does it
The gate calls `tools/pipeline-check.sh --traceability` and `--measure-only` for the shared checks. The wrapper `pipeline-check` runs the gate once and adds the checks that are not inside it (architecture imports, GitHub state). A `falha` (failure) makes the program exit with 1; an `aviso` (warning) never does; a check that could not run is `pulado` (skipped), never `ok`. Which steps each project has is in [[checker-catalog]].

## Where it sits in the pipeline
Step 3 of [[code-security-pipeline]].

## Who receives its output
[[ci-explained]], the pre-push hook ([[branch-protection-explained]]) and, through `report.json`, the skill [[skill-revisao-manutencao]].
