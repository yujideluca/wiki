---
id: ralexandria
title: Ralexandria (project)
aliases: [radiology encyclopedia, literature reference bank]
kind: project
project: none
status: active
location: ralexandria:
fed_by: []
feeds: []
sources: [ralexandria:CLAUDE.md, ralexandria:PLAN.md, ralexandria:docs/SCOPE.md, ralexandria:DESIGN.md, ralexandria:tools/inventory.py]
reviewed: 2026-11-19T15:31Z
---

## What it is
A project, started on 2026-11-19, to build a complete radiology encyclopedia in English together with a reference bank of the literature behind it. It lives in the folder `~/dev/ralexandria` (a local git repository, no remote yet) and reads the data of the [[radiology-report-matcher]] project (the downloaded Radiopaedia articles and cases, the book texts and the reference vocabularies) without changing it.

Giovanni's decisions of 2026-11-19: the project is English only; there is one entry per concept (a disease, an imaging finding or sign, a technique, a piece of anatomy); every entry also explains the biophysics under the finding, meaning how the patient's biology and the physics of the device together produce the look of the image; all text is written in our own words with citations, so Radiopaedia is one source among many and nothing is copied from it; only whole articles count as sources, never abstracts or summaries; any source may be used, politely (it obeys each site's crawling rules, waits 10 seconds between requests and never works around a block).

## Flow
trigger t1: Giovanni asks for the encyclopedia
step s1: Inventory the local sources, read-only
step s2: Build the concept index from titles and vocabularies
step s3: Match full-text sources to each concept; mark gaps
step s4: Write a pilot chapter with the biophysics section
decide d1: Does Giovanni approve the pilot? (if not, the pilot is rewritten and shown again)
step s5: Scale out by body system
product p1: The encyclopedia and its reference bank
product p2: Notes from Giovanni for another pilot round

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -no-> p2
d1 -yes-> s5
s5 -> p1

## Architecture
### Context
person g: Giovanni — sets the scope and reviews the pilot | [[giovanni]]
system s: Ralexandria — the encyclopedia and its reference bank
external r: Radiology finding assistant data — Radiopaedia articles, cases, books, vocabularies | [[radiology-report-matcher]]
external w: Open sources on the web — full-text articles and open vocabularies

g -sets scope and reviews-> s
s -reads, never changes-> r
s -fetches full texts from-> w

### Containers
person g: Giovanni | [[giovanni]]
container inv: Inventory script — counts the local sources, read-only
external r: Existing radiology data | [[radiology-report-matcher]]

g -starts-> inv
inv -reads-> r

## Engineering practices
How this project follows the golden path of [[project-template]]: so far only in part.

### Principles
The rules for every session are the file `CLAUDE.md` of the repository (commit `2332626`, 2026-11-19): English only, own words with citations, whole articles as sources, read-only inputs, commit by path, never skip the pre-push check, and only a real run counts as proof.

### Decisions
One decision-log row in `DESIGN.md` (Giovanni's brief of 2026-11-19). No architecture decision records yet.

### Requirements
None yet: there is no `docs/REQUIREMENTS.md`.

### Quality gate
Not built yet: the repository has no gate script, no pre-push check and no tests. This is open work, to be done before real code is added.

### Continuous integration
None yet: the repository has no remote.

### Maintenance
Not started: no debt issues and no monthly review.

## What it does
Gives Giovanni one place that explains every radiology concept in plain English, including the biophysics behind how it looks on an image, with a list of the full-text sources behind each statement.

## How it does it
So far only the groundwork exists: `tools/inventory.py` opens the Radiopaedia database of [[radiology-report-matcher]] read-only and counts its tables and the files of the book and vocabulary folders. As of 2026-11-19 it found 17,361 articles, 70,527 cases, 7 book texts and the vocabulary files. No entry has been written yet; the next steps are the concept index, the source bank and a pilot chapter.

## Where it sits in the pipeline
It sits after the downloads and translations of [[radiology-report-matcher]], using their stored data as raw material, and before any reader of the finished encyclopedia.

## Who receives its output
Giovanni, who reviews the pilot. Nothing is published and the repository has no remote.
