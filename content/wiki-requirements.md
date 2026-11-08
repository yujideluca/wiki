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
sources: [wiki:docs/REQUIREMENTS.md, wiki:server/test/map_css_test.exs]
reviewed: 2026-11-08T21:05Z
---

## What it is
A requirement is a testable promise of the software. This page describes the wiki's own list of promises (`docs/REQUIREMENTS.md`), each with an ID built from a two-letter family and a number: AU (the login gate), DC (the decoy), CO (content rules), LG (English only), BU (the build), UP (the update chain), ST (the staleness of pages), MP (the map and the pages), MB (the phone version), LN (the globe on the map), AR (how an article is drawn), DY (the elastic dots) LY (the layout computation) and TC (touch on the map) and LB (the names beside the dots).

## What it does
Every row must have at least one test tagged `REQ <ID>`; the generated file `docs/TRACEABILITY.md` maps each requirement to its tests.

## How it does it
The rows are written from Giovanni's statements (source G) and from the approved design (source D). The [[check-traceability]] check enforces that every promise has a test and every tag names a real promise.

## Where it sits in the pipeline
Beside the design document `docs/2026-10-22-wiki-design.md`.

## Who receives its output
[[check-traceability]] and the [[wiki-quality-gate]].

## Notes
The list holds 85 requirements, and the traceability report covers each of them. The flowchart family is `FL` and the architecture/practices family is `PJ`. The audit added `ST-4` through `ST-6` for self-source handling, precise wiki-source review semantics and publication validation, and `UP-7` for preserving shared obligations under malformed state, concurrent publication and linked worktrees. `UP-8` (2026-11-06) asks the Stop hook ([[wiki-hook-stop]]) to reach the same answer as before while asking each read-only question (a git query, or where a file path really points after following links) only once per run, so that it ends well inside its 30-second time limit. The tests include independent processes and a source that exists only in the selected wiki worktree.

MP-10 keeps text inside the globe unselectable while article text remains selectable. Its regression test reads the stylesheet and rejects label overrides that enable text selection or a text cursor.
