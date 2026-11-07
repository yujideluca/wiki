---
id: repository-layout
title: Repository layout (the golden path)
aliases: [project folder layout, folder structure]
kind: data
project: project-template
status: active
location: project-template:
fed_by: []
feeds: []
sources: [project-template:README.md, project-template:CLAUDE.md, project-template:pipeline-check.toml, project-template:tools/quality_gate.sh, project-template:.github/workflows/quality-gate.yml]
reviewed: 2026-11-07T23:42Z
---

## What it is
A repository is a project folder tracked by [Git](https://git-scm.com/), a tool that records every change. Every software project of Giovanni's starts from [[project-template]], so they all have the same skeleton. A reader who has seen one project can find the same things in another.

## What it does
The skeleton has these parts:
- `CLAUDE.md` (and `AGENTS.md` for Codex): the principles and working rules for the assistant, each principle paired with the check that enforces it.
- `DESIGN.md`: diagrams of the system and the decision log, a table with one row per decision and its maintenance type.
- `docs/adr/`: one file per structural decision ([[adr-explained]]).
- `docs/REQUIREMENTS.md`: the promises of the program, each with an ID such as `PC-3`; `docs/TRACEABILITY.md` is the generated table that maps each ID to its tests ([[check-traceability]]).
- `docs/MAINTENANCE.md`: the debt policy ([[maintenance-policy]]).
- `tools/quality_gate.sh`: the one definition of passing ([[quality-gate-explained]]).
- `tools/pipeline-check.sh`, `pipeline-check.version` and `pipeline-check.toml`: the runner that fetches the pinned [[pipeline-check]], the version it pins and the limits it enforces.
- `tools/hooks/pre-push`: the local stand-in for branch protection ([[branch-protection-explained]]).
- `.github/workflows/quality-gate.yml`: the automatic checks on GitHub ([[ci-explained]]).

## How it does it
New projects copy the template folder; the wiki page [[new-project]] describes the steps. Not every older project has every part: [[checks-remote-terminal]] and [[checks-processing-sketches]] have a lighter gate, and [[checks-status-quo]] still carries placeholder gate steps.

## Where it sits in the pipeline
It is the shared shape that the per-project pages in [[code-security-pipeline]] refer to.

## Who receives its output
New projects and the checks in [[checker-catalog]], which look for these files by name.
