---
id: wiki-quality-gate
title: Wiki quality gate
aliases: [wiki gate]
kind: script
project: wiki
status: active
location: wiki:tools/quality_gate.sh
fed_by: [template-quality-gate, wiki-requirements]
feeds: [github]
sources: [wiki:tools/quality_gate.sh, wiki:.github/workflows/quality-gate.yml, wiki:pipeline-check.toml]
reviewed: 2026-10-24T21:57Z
---

## What it is
The quality gate is the wiki's one definition of "passing", derived from the [[template-quality-gate]]. CI (continuous integration, the automatic checks on GitHub) runs the same script.

## What it does
It runs five steps. (1) The Elixir tests (`mix test`: checker, build, staleness, hook, publish, login gate, decoy). (2) The Elm tests (`elm-test`) and an optimized Elm build. (3) Requirement traceability ([[check-traceability]]), which also fails when the regenerated `docs/TRACEABILITY.md` differs from the committed one. (4) `wiki check` on the real content, after comparing the privacy patterns file `server/priv/privacy-patterns.tsv` with the copy in workflow-memory (on the laptop). (5) Fitness checks, limits that keep the project healthy: the limits in `pipeline-check.toml`, measured by [[pipeline-check]] (the architecture rule, shellcheck on the scripts, no source file over 800 lines, the gate under 1200 seconds), and the optimized app bundle at most 200,000 bytes compressed.

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script. On GitHub it runs `wiki check` without `--local`, because the other private repositories are not visible there.

## Where it sits in the pipeline
Before publishing code changes and on every push.

## Who receives its output
[[github]] (the CI result).
