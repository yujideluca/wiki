---
id: checks-codex-skills
title: codex-skills: checkers and rules
aliases: [codex skills checks, skillsctl checks]
kind: decision
project: codex-skills
status: active
fed_by: []
feeds: []
sources: [codex-skills:tools/quality_gate.sh, codex-skills:pipeline-check.toml, codex-skills:tools/skillsctl.py, codex-skills:tools/mutation_check.py]
reviewed: 2026-11-02T10:44Z
---

## What it is
These are the checkers of [[codex-skills]], the repository that holds the skills Codex uses, with their sources and a manifest. Its tool `skillsctl` validates and installs them ([[codex-skillsctl]]).

## What it does
The gate runs: `skillsctl.py check` (validates the manifest and the skills' file fingerprints; the hash is computed over names and bytes and never follows symbolic links); the unit tests in `tests/test_skillsctl.py`; a mutation check (`tools/mutation_check.py`); requirement traceability (the CS requirements); and the fitness limits. The rule behind it (ADR-0002 (an architecture decision record)): Codex-owned adaptations never update the Claude sources.

## How it does it
CI (continuous integration) runs `pipeline-check --mode ci` (60 minutes at most). The `pipeline-check.toml` is the template one: no GitHub section, so branch protection is not read. Three ADRs exist.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
