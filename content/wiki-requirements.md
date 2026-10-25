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
reviewed: 2026-10-24T21:57Z
---

## What it is
A requirement is a testable promise of the software. This page describes the wiki's own list of promises (`docs/REQUIREMENTS.md`), each with an ID built from a two-letter family and a number: AU (the login gate), DC (the decoy), CO (content rules), LG (languages), BU (the build), UP (the update chain), ST (the staleness of pages) and MP (the map and the pages).

## What it does
Every row must have at least one test tagged `REQ <ID>`; the generated file `docs/TRACEABILITY.md` maps each requirement to its tests.

## How it does it
The rows are written from Giovanni's statements (source G) and from the approved design (source D). The [[check-traceability]] check enforces that every promise has a test and every tag names a real promise.

## Where it sits in the pipeline
Beside the design document `docs/2026-10-22-wiki-design.md`.

## Who receives its output
[[check-traceability]] and the [[wiki-quality-gate]].
