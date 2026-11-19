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
sources: [ralexandria:CLAUDE.md, ralexandria:PLAN.md, ralexandria:docs/SCOPE.md, ralexandria:DESIGN.md, ralexandria:tools/inventory.py, ralexandria:.github/workflows/quality-gate.yml, ralexandria:docs/MAINTENANCE.md, ralexandria:docs/REQUIREMENTS.md, ralexandria:docs/TRACEABILITY.md, ralexandria:docs/adr/0002-elm-and-elixir.md, ralexandria:frontend/elm.json, ralexandria:frontend/src/Entry.elm, ralexandria:frontend/src/Main.elm, ralexandria:frontend/static/style.css, ralexandria:server/lib/ralexandria/router.ex, ralexandria:server/lib/ralexandria/entries.ex, ralexandria:tools/quality_gate.sh, ralexandria:pipeline-check.toml, ralexandria:frontend/src/Flow.elm, ralexandria:frontend/src/FlowLayout.elm, ralexandria:frontend/src/FlowView.elm, ralexandria:server/config/runtime.exs, ralexandria:docs/adr/0000-template.md, ralexandria:frontend/static/index.html, ralexandria:frontend/tests/EntryTests.elm, ralexandria:pipeline-check.version, ralexandria:tools/concepts.py, ralexandria:tests/test_concepts.py, ralexandria:server/config/config.exs, ralexandria:server/lib/ralexandria/application.ex, ralexandria:server/mix.exs, ralexandria:server/mix.lock, ralexandria:server/test/entries_test.exs, ralexandria:server/test/test_helper.exs, ralexandria:tools/build.sh, ralexandria:tools/hooks/pre-push, ralexandria:tools/sourcebank.py, ralexandria:tests/test_sourcebank.py, ralexandria:tools/pipeline-check.sh, ralexandria:tools/run.sh, ralexandria:.gitignore]
reviewed: 2026-11-19T16:34Z
---

## What it is
A project, started on 2026-11-19, to build a complete radiology encyclopedia as a website, in English together with a reference bank of the literature behind it. It lives in the folder `~/dev/ralexandria` (a git repository, private on GitHub as `yujideluca/ralexandria`, branch `main` only) and reads the data of the [[radiology-report-matcher]] project (the downloaded Radiopaedia articles and cases, the book texts and the reference vocabularies) without changing it.

Giovanni's decisions of 2026-11-19: the project is English only; it is a website with an Elm front end and an Elixir back end (the same stack as the wiki), in the palette #deb87c, #93614b, #293497 and #342d5f, using schematic diagrams as in the wiki where they help; there is one entry per concept (a disease, an imaging finding or sign, a technique, a piece of anatomy); every entry also explains the biophysics under the finding, meaning how the patient's biology and the physics of the device together produce the look of the image; all text is written in our own words with citations, so Radiopaedia is one source among many and nothing is copied from it; only whole articles count as sources, never abstracts or summaries; any source may be used, politely (it obeys each site's crawling rules, waits 10 seconds between requests and never works around a block).

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
container web: Front end (Elm) — index and entry pages in the browser
container api: Back end (Elixir, Plug and Bandit) — serves entries from content/ and the front end
store md: Entry files — one Markdown file per concept in content/
container inv: Inventory script — counts the local sources, read-only
external r: Existing radiology data | [[radiology-report-matcher]]

g -reads entries in-> web
web -asks for entries from-> api
api -reads-> md
g -starts-> inv
inv -reads-> r

## Engineering practices
How this project follows the golden path of [[project-template]]: so far only in part.

### Principles
The rules for every session are the file `CLAUDE.md` of the repository (2026-11-19): English only, own words with citations, whole articles as sources, read-only inputs, commit by path, never skip the pre-push check, and only a real run counts as proof.

### Decisions
Two decision-log rows in `DESIGN.md` (the brief and the stack, 2026-11-19) and one architecture decision record, 0002, for the Elm and Elixir stack.

### Requirements
Sixteen requirement rows in `docs/REQUIREMENTS.md`, each with a tagged test: RX-1 to RX-7 for the site (local-only server, entry list, one entry or a 404, paragraphs, diagram blocks, diagram drawing, content folder setting) and CX-1 to CX-4 for the concept index and SB-1 to SB-5 for the source bank (one concept per article with kind, systems and synonyms; no disambiguation pages; RadLex id only on an exact name match; names, tags and links only, never article text; full text only; two independent sources; Radiopaedia never independent).

### Quality gate
`tools/quality_gate.sh` has five steps: Elixir and Python tests, Elm tests with an optimized build, requirement traceability, fitness limits (file length, gate time) and the gzipped bundle size. It passed on 2026-11-19 (a few seconds). The local pre-push check is switched on with `git config core.hooksPath tools/hooks` and ran on the pushes of that day.

### Continuous integration
The workflow `quality-gate.yml` installs Erlang, Elixir, Node and Elm and runs the gate on every push. The first push failed because the tools were missing; after the fix the run of 2026-11-19 was green.

### Maintenance
Not started: no debt issues and no monthly review.

## What it does
Gives Giovanni one place that explains every radiology concept in plain English, including the biophysics behind how it looks on an image, with a list of the full-text sources behind each statement.

## How it does it
The site runs locally on 127.0.0.1:4200 (`tools/run.sh`): an index of entries and one page per entry. An entry is a Markdown file; besides paragraphs it may hold schematic diagrams in fenced blocks marked `flow` (a flowchart) or `architecture` (two C4 levels), drawn by the modules `Flow`, `FlowLayout` and `FlowView`, which were copied from the [[wiki]] on 2026-11-19 at Giovanni's decision (not shared; changes to the diagram language must be carried over by hand). There are no real entries yet. The first pass of the concept index exists: `tools/concepts.py` reads the Radiopaedia database read-only and writes `data/concepts.jsonl` (not in git): on 2026-11-19, 17,207 concepts (kinds: 8,348 conditions, 3,311 anatomy, 1,169 signs, 782 technology, 752 syndromes, 712 gamuts and others), 4,010 of them matched to a RadLex id, 1,181 without a body-system tag. Terms that exist only in RadLex or MeSH are not added yet.

The first pass of the source bank also exists: `tools/sourcebank.py build` reads the radiology project's data read-only and builds a search index in `data/sourcebank.sqlite` (not in git) over full texts only: 1,160 open-access articles (body sections only, never abstracts or references), 147 open-licence books, 17 books Giovanni owns (private, never copied or sent out) and the Radiopaedia articles. `match` then looks up each concept's names as exact phrases; a source counts only if it names the concept in at least two passages, and Radiopaedia never counts as an independent source. Result on 2026-11-19: 9,043 of 17,207 concepts have at least two independent full-text sources, 8,164 do not (5,393 have none): those gaps are the list for fetching more sources from the web. Matching by name is coarse: a source may name a concept without explaining it, so "covered" is an upper bound; precision was only spot-checked by eye on eight concepts. A flow diagram was seen drawn in a browser with a test entry; how it looks in light mode was not checked, and in the dark mode of the test browser the box fills looked pale. Also, `tools/inventory.py`: `tools/inventory.py` opens the Radiopaedia database of [[radiology-report-matcher]] read-only and counts its tables and the files of the book and vocabulary folders. As of 2026-11-19 it found 17,361 articles, 70,527 cases, 7 book texts and the vocabulary files. No entry has been written yet; the next steps are the concept index, the source bank and a pilot chapter.

## Where it sits in the pipeline
It sits after the downloads and translations of [[radiology-report-matcher]], using their stored data as raw material, and before any reader of the finished encyclopedia.

## Who receives its output
Giovanni, who reviews the pilot. Nothing is published on the internet; the repository is private.
