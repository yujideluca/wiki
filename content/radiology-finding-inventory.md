---
id: radiology-finding-inventory
title: Finding inventory and its checker (assistant/)
aliases: [finding inventory, assistant/inventory.py, X-ray inventory]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:assistant
fed_by: [radiology-r1-xray-review, radiology-real-report-factcheck]
feeds: [radiology-report-matcher, radiology-finding-engine, radiology-modality-corpus]
sources: [radiology-crawler:assistant/inventory.py, radiology-crawler:assistant/__init__.py, radiology-crawler:assistant/modules/xray/chest.json, radiology-crawler:assistant/modules/xray/msk-trauma.json, radiology-crawler:assistant/modules/xray/msk-other.json, radiology-crawler:assistant/modules/xray/abdomen.json, radiology-crawler:tests/test_finding_inventory.py, radiology-crawler:docs/adr/0008-finding-inventory-format-and-module-layout.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/r1/gap-clusters.md, radiology-crawler:docs/r1/omitted-chest.md, radiology-crawler:docs/r1/omitted-msk-trauma.md, radiology-crawler:docs/r1/omitted-msk-other.md, radiology-crawler:docs/r1/omitted-abdomen.md, radiology-crawler:analysis/finding_links.py, radiology-crawler:tests/test_finding_links.py, radiology-crawler:docs/real-reports-factcheck-batch1.json, radiology-crawler:DESIGN.md]
reviewed: 2026-11-14T23:13Z
---

## What it is
The first code of the finding assistant described on [[radiology-report-matcher]]: the checked list of X-ray findings the assistant is allowed to suggest, and the program that checks it. A "finding" is one named observation on an image, such as a pneumothorax. The list is the package `assistant/`; the knowledge of one imaging method sits in its own folder, `assistant/modules/xray/`, so that ultrasound, CT and MRI can be added later as folders without changing the core (decision record ADR-0008, an architecture decision record, a short file that records one structural decision; see [[adr-explained]]). It was built from the literature drafts of [[radiology-r1-xray-review]].

## What it does
The X-ray folder has four JSON (JavaScript Object Notation, a plain-text format for structured data) files. Since the correction of 2026-11-14 described below they hold 233 findings: chest 80, fractures and dislocations 51, other bone, joint, spine and skull findings 57, and abdomen and other plain films 45. Before that the list had 228 findings (205 at first on 2026-11-09, 23 added the same day from the gaps the linking pilot found; the sorting of those gaps is in `docs/r1/gap-clusters.md`). Each finding has an English name, German and Portuguese terms each marked verified or not, a definition in plain words, the descriptors a proper description states with their allowed values, the findings it is easily confused with, and its support. Support is one of two kinds: sourced (it cites a source of the file, whose citation, link, licence and reading depth are recorded) or foundational (basic radiology that textbooks teach without a citation, kept only when at least 3 independent open sources state it, by Giovanni's ruling of 2026-11-09). Anything else is refused. Counts on 2026-11-09: 223 findings sourced and 5 foundational, 37 marked weak, 1,041 descriptors of which 155 are foundational; German terms verified 47 of 172, Portuguese 71 of 164. The 23 added findings were read only at the matching sentences of 72 open-access papers (reading depth "part", one "abstract"), and 12 of them are weak. Counts after the correction of 2026-11-14, printed by the checker on the committed files: 229 findings sourced and 4 foundational, 38 marked weak, 1,089 descriptors of which 160 are foundational; German terms verified 46 of 168, Portuguese 70 of 160. Items left out because they were stated by fewer than 3 sources, were not found, or were numbers whose sources trace back to a single origin are listed with reasons in `docs/r1/omitted-*.md`.

Correction after the fact-check of the first real reports (2026-11-14, commit `3575a75`, requirement AN-86; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). The literature fact-check of a first batch of real reports ([[radiology-real-report-factcheck]]) named 9 findings the list lacked and 6 defects of existing entries. The list was changed as follows:

- Nine findings were added: low lung volumes, dilated oesophagus, dilated bowel loops, fracture, lytic bone lesion, periosteal reaction, joint erosion, bone loss around a prosthesis, and flatfoot. Five of them are "generic" entries (dilated bowel loops, fracture, lytic bone lesion, periosteal reaction, joint erosion): a report often says "a fracture" without the bone or the pattern, and the list had only the specific kinds. The generic entry is now the parent of its specific entries, and bone, site and type are descriptors.
- Four duplicate entries were merged into three surviving ones: pneumoperitoneum was listed under chest and under abdomen, rib fracture under chest and under fractures, and a radiopaque foreign body under abdomen, chest and other bone findings. The surviving entry lists the old identifiers in a field `replaces`, and `finding_links.aliases` reads a label made on an old identifier as the surviving one. This matters because the frozen test sets were labelled on the old list and may not be rewritten: labels are mapped when they are read, no agreed label is lost, and the merge can be undone.
- Parent links: 47 findings now have a parent, 5 before.
- Five definitions were changed with the identifier kept (for example phlebolith and ankle fracture). Two of the new sources could not be fetched in full: one entry rests on the fact-check record and is marked weak, one source was read as an abstract only (stated in the commit message; not re-checked for this page).
- The five generic findings had no training text when they were added.

Plain names for the kinds of finding (2026-11-14, commit `87d9fc5`, requirement AN-87): each of the four files has a table `group_names` that gives every group (the kind of finding, for example "bone-lesion") a plain English name ("Bone lesion"), 23 names in all, so that no internal group name needs to be shown to a user.

This part of the project is still being extended by the session that builds the lists (the "corpus lane"); this page describes commit `7bbdaaa` of 2026-11-14.

## How it does it
`python3 -I assistant/inventory.py check assistant/modules/xray/*.json` validates the files and prints the counts. The checker needs only the Python standard library. The requirements AN-61 and FA-4 are tested by `tests/test_finding_inventory.py`, including a test over the real X-ray files, and the quality gate (the one script that decides whether the code passes) compiles the package. AN-86 and AN-87 are tested in `tests/test_finding_links.py`, against the committed X-ray files.

## Functions
- `inventory.validate`: return the problems of one area file: missing fields, entries that are neither sourced nor foundational, unknown source keys, foundational counts below 3, missing English names, malformed German or Portuguese terms, duplicate ids, unknown references.
- `inventory.report`: count findings by support, weak marks, descriptors and verified terms per language.
- `finding_links.aliases` (in `analysis/finding_links.py`): the map from a merged finding's old identifier to the surviving one, read from the `replaces` fields.
- `inventory.load`, `inventory.main`: read several area files, check references across them, and run the check from the command line (exit code 1 when anything is refused).

## Where it sits in the pipeline
After the literature review ([[radiology-r1-xray-review]], step R1) and before the test sets and the engine that will read this list (steps R3 onward, see [[radiology-analysis]]).

## Who receives its output
The lists of ultrasound, CT (computed tomography) and MRI (magnetic resonance imaging) are written in this same format by [[radiology-modality-corpus]], from the article finding tags instead of a literature review; since 2026-11-14 they also carry descriptors, parent links and lists of easily confused findings, made by a different method that the same page describes. The later test sets and engine of the finding assistant, and Giovanni, who reviews the omitted-item lists.
