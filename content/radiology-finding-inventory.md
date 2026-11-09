---
id: radiology-finding-inventory
title: Finding inventory and its checker (assistant/)
aliases: [finding inventory, assistant/inventory.py, X-ray inventory]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:assistant
fed_by: [radiology-r1-xray-review]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:assistant/inventory.py, radiology-crawler:assistant/__init__.py, radiology-crawler:assistant/modules/xray/chest.json, radiology-crawler:assistant/modules/xray/msk-trauma.json, radiology-crawler:assistant/modules/xray/msk-other.json, radiology-crawler:assistant/modules/xray/abdomen.json, radiology-crawler:tests/test_finding_inventory.py, radiology-crawler:docs/adr/0008-finding-inventory-format-and-module-layout.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/r1/omitted-chest.md, radiology-crawler:docs/r1/omitted-msk-trauma.md, radiology-crawler:docs/r1/omitted-msk-other.md, radiology-crawler:docs/r1/omitted-abdomen.md]
reviewed: 2026-11-09T22:15Z
---

## What it is
The first code of the finding assistant described on [[radiology-report-matcher]]: the checked list of X-ray findings the assistant is allowed to suggest, and the program that checks it. A "finding" is one named observation on an image, such as a pneumothorax. The list is the package `assistant/`; the knowledge of one imaging method sits in its own folder, `assistant/modules/xray/`, so that ultrasound, CT and MRI can be added later as folders without changing the core (decision record ADR-0008, an architecture decision record, a short file that records one structural decision; see [[adr-explained]]). It was built from the literature drafts of [[radiology-r1-xray-review]].

## What it does
The X-ray folder has four JSON (JavaScript Object Notation, a plain-text format for structured data) files: chest (70 findings), fractures and dislocations (45), other bone, joint, spine and skull findings (46), and abdomen and other plain films (44), 205 findings in all. Each finding has an English name, German and Portuguese terms each marked verified or not, a definition in plain words, the descriptors a proper description states with their allowed values, the findings it is easily confused with, and its support. Support is one of two kinds: sourced (it cites a source of the file, whose citation, link, licence and reading depth are recorded) or foundational (basic radiology that textbooks teach without a citation, kept only when at least 3 independent open sources state it, by Giovanni's ruling of 2026-11-09). Anything else is refused. Counts on 2026-11-09: 201 findings sourced and 4 foundational, 25 marked weak, 968 descriptors of which 155 are foundational; German terms verified 47 of 149, Portuguese 71 of 141. Items left out because they were stated by fewer than 3 sources, were not found, or were numbers whose sources trace back to a single origin are listed with reasons in `docs/r1/omitted-*.md`.

## How it does it
`python3 -I assistant/inventory.py check assistant/modules/xray/*.json` validates the files and prints the counts. The checker needs only the Python standard library. The requirements AN-61 and FA-4 are tested by `tests/test_finding_inventory.py`, including a test over the real X-ray files, and the quality gate compiles the package.

## Functions
- `inventory.validate`: return the problems of one area file: missing fields, entries that are neither sourced nor foundational, unknown source keys, foundational counts below 3, missing English names, malformed German or Portuguese terms, duplicate ids, unknown references.
- `inventory.report`: count findings by support, weak marks, descriptors and verified terms per language.
- `inventory.load`, `inventory.main`: read several area files, check references across them, and run the check from the command line (exit code 1 when anything is refused).

## Where it sits in the pipeline
After the literature review ([[radiology-r1-xray-review]], step R1) and before the test sets and the engine that will read this list (steps R3 onward, see [[radiology-analysis]]).

## Who receives its output
The later test sets and engine of the finding assistant, and Giovanni, who reviews the omitted-item lists.
