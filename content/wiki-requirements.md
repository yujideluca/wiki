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
---

## What it is
The testable promises of the wiki, each with an ID: AU (login gate), DC (decoy), CO (content rules), LG (languages), BU (build), UP (update chain), MP (map and pages).

## What it does
Every row has at least one test tagged `REQ <ID>`; `docs/TRACEABILITY.md` maps them.

## How it does it
Written from Giovanni's statements (G) and the approved design (D); [[check-traceability]] enforces coverage.

## Where it sits in the pipeline
Beside the design document `docs/2026-10-22-wiki-design.md`.

## Who receives its output
[[check-traceability]] and [[wiki-quality-gate]].
