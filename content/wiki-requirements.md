---
id: wiki-requirements
title: Wiki requirements
aliases: [wiki REQUIREMENTS.md]
kind: data
project: wiki
status: active
location: wiki:docs/REQUIREMENTS.md
fed_by: []
feeds: [check-traceability, wiki-quality-gate]
sources: [wiki:docs/REQUIREMENTS.md]
reviewed: 2026-11-06T13:12Z
---

## What it is
A requirement is a testable promise of the software. This page describes the wiki's own list of promises (`docs/REQUIREMENTS.md`), each with an ID built from a two-letter family and a number: AU (the login gate), DC (the decoy), CO (content rules), LG (languages), BU (the build), UP (the update chain), ST (the staleness of pages), MP (the map and the pages), MB (the phone version), LN (the globe on the map), AR (how an article is drawn), DY (the elastic dots) LY (the layout computation) and TC (touch on the map).

## What it does
Every row must have at least one test tagged `REQ <ID>`; the generated file `docs/TRACEABILITY.md` maps each requirement to its tests.

## How it does it
The rows are written from Giovanni's statements (source G) and from the approved design (source D). The [[check-traceability]] check enforces that every promise has a test and every tag names a real promise.

## Where it sits in the pipeline
Beside the design document `docs/2026-10-22-wiki-design.md`.

## Who receives its output
[[check-traceability]] and the [[wiki-quality-gate]].

## Notes
The current traceability report covers 79 requirements. The flowchart family is `FL` and the architecture/practices family is `PJ`. The audit added `ST-4` through `ST-6` for self-source handling, precise wiki-source review semantics and publication validation, and `UP-7` for preserving shared obligations under malformed state, concurrent publication and linked worktrees. The tests include independent processes and a source that exists only in the selected wiki worktree.
