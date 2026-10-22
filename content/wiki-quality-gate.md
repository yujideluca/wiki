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
---

## What it is
The wiki's one definition of "passing", from [[template-quality-gate]]; CI runs the same script.

## What it does
Elixir tests (`mix test`: checker, build, hook, publish, login gate, decoy), Elm tests (`elm-test`), an Elm build, requirement traceability ([[check-traceability]]), `wiki check` on the real content, and fitness checks (the decoy contains no real content; the built app stays small).

## How it does it
Bash; on GitHub it runs `wiki check` without `--local`, because the other private repos are not visible there.

## Where it sits in the pipeline
Before publishing code changes and on every push.

## Who receives its output
[[github]] (CI result).
