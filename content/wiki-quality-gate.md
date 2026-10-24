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
sources: [wiki:tools/quality_gate.sh, wiki:.github/workflows/quality-gate.yml]
reviewed: 2026-10-22T16:33Z
---

## What it is
The quality gate is the wiki's one definition of "passing", derived from the [[template-quality-gate]]. CI (continuous integration, the automatic checks on GitHub) runs the same script.

## What it does
It runs: the Elixir tests (`mix test`: checker, build, hook, publish, login gate, decoy), the Elm tests (`elm-test`), an Elm build, requirement traceability ([[check-traceability]]), `wiki check` on the real content, and fitness checks (the decoy contains no real content; the built app stays small).

## How it does it
It is a [Bash](https://www.gnu.org/software/bash/) script. On GitHub it runs `wiki check` without `--local`, because the other private repositories are not visible there.

## Where it sits in the pipeline
Before publishing code changes and on every push.

## Who receives its output
[[github]] (the CI result).
