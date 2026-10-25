---
id: project-template
title: project-template (golden path)
aliases: [template, golden path]
kind: project
project: none
status: active
location: project-template:
fed_by: []
feeds: [quizapp, wiki]
sources: [project-template:README.md, project-template:CLAUDE.md]
reviewed: 2026-10-24T22:03Z
---

## What it is
project-template is the starting point for every new software project of Giovanni's. It is a ready-made folder (`~/dev/project-template`, repository `yujideluca/project-template`) that already contains the good working habits, so that doing it the right way is also the quickest way. It was chosen in the maintenance and evolution review of 2026-10-22, and [[quizapp]] was the reference project it was extracted from.

## What it does
From day one a new project gets: principles that are each enforced by a check; a design file with diagrams (in the [C4 model](https://c4model.com/) style, drawn with [Mermaid](https://mermaid.js.org/)) and a decision log; ADRs (architecture decision records, short notes that keep the reasons for decisions); a list of requirements with tests tagged to them ([[check-traceability]]); a quality gate (one script that defines "passing", [[template-quality-gate]]); CI (continuous integration: automatic checks on every push); and the policy for technical debt and reviews ([[maintenance-policy]]).

## How it does it
The folder is copied with `cp -r` into a new project folder. In the first session Claude fills in the project's CLAUDE.md (its instruction file), section 1 of the design file, the first requirements, the gate's steps and ADR-0002 for the chosen technology, and then creates the private GitHub repository and its labels ([[new-project]]). Before any of that, Giovanni chooses the programming language ([[work-ask-language]]). The maintenance program [[pipeline-check]] is not copied into the project: the folder carries the file `pipeline-check.version` (`v0.4.0` on 2026-10-24), the runner `tools/pipeline-check.sh`, which fetches and builds that version from `yujideluca/pipeline-check` once (the machine needs Rust, `cargo` and git), the limits in `pipeline-check.toml`, and a local pre-push check in `tools/hooks/pre-push`, turned on with `git config core.hooksPath tools/hooks`.

## Where it sits in the pipeline
Upstream of every new project. This [[wiki]] was the first project started from it.

## Who receives its output
New projects such as the [[wiki]]; improvements found in running projects flow back into the template during the [[monthly-architecture-review]].
