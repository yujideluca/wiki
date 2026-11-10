---
id: radiology-r1-xray-review
title: Radiology finding assistant: X-ray literature review (R1)
aliases: [R1, X-ray literature review, docs/r1]
kind: data
project: radiology-report-matcher
status: active
location: radiology-crawler:docs/r1
fed_by: []
feeds: [radiology-report-matcher, radiology-finding-inventory]
sources: [radiology-crawler:docs/r1/foundational-candidates.md, radiology-crawler:docs/r1/foundational-chest.md, radiology-crawler:docs/r1/foundational-msk-1.md, radiology-crawler:docs/r1/foundational-msk-2.md, radiology-crawler:docs/r1/foundational-abdomen.md, radiology-crawler:docs/r1/r1-xray-chest.md, radiology-crawler:docs/r1/r1-xray-msk.md, radiology-crawler:docs/r1/r1-xray-abdomen-other.md, radiology-crawler:docs/r1/r1-xray-lexicons-and-test-sources.md, radiology-crawler:docs/assistant-problem-statement.md, radiology-crawler:docs/analysis-status.json]
reviewed: 2026-11-10T00:55Z
---

## What it is
Four research documents in the folder `docs/r1/` of the radiology repository. They are step R1 of the finding assistant described on [[radiology-report-matcher]]: a literature inventory of the radiological findings that a plain X-ray (radiograph) report can describe, with the attributes a proper description states for each finding and the standard terms for them. A "finding" is one named observation on an image, for example a pneumothorax or a spiculated bone lesion. Three documents list findings (chest 70, bones, joints, spine and skull 91, abdomen and other plain films 46, about 207 in all); the fourth covers terminologies, their licences and the possible sources of real reports for the final test.

## What it does
For each finding a document gives a definition in plain words, the descriptors with their allowed values, the findings it is easily confused with (which is what makes a finding "strict"), a rule for how specific a finding may be, the source, and German and Brazilian Portuguese terms. Every row carries a verification level: read in full, read in part, abstract only, or UNSOURCED (no open source supported it). Nothing was invented to fill a gap; UNSOURCED rows wait for Giovanni's decision. Counts after the verification pass of 2026-11-09:

| Document | Findings | With no source at all | Marked weak | Other detail |
|---|---|---|---|---|
| Chest | 70 | 2 | 4 | 39 read in full, 29 read in part |
| Bones, joints, spine, skull | 91 | 0 | 7 | none read in full; 65 rows still carry at least one detail with no source |
| Abdomen and other | 46 | 4 | 1 | 4 rows rest on abstracts only |

A second source search on the same day, over the findings that first had no source, found an open source for most of them (14 of 16 chest findings, all 24 bone findings, 3 of 7 abdomen findings). Support is thin in places: the sources for the newly cited rows were read only in part, and the bone document still has 65 findings with at least one unsupported detail (for example, no open source defines dislocation as against subluxation). The search also corrected the draft: the diaphragm limit is more than 3 cm, and one source puts the apex of a sigmoid volvulus under the left diaphragm while another says the pelvis. "Weak" means the source lacks the key definition, is a single case report, or is based on CT rather than X-ray.

The verification corrected several draft claims, for example the Meyerding grades, the Kellgren-Lawrence grades, the football-sign wording and the Naclerio V sign position. German terms found in open German articles: 26 of 70 chest, 22 of 45 bone-term rows, 14 of 34 abdomen rows; none is checked against a published glossary. Portuguese terms verified: 21 of 70 chest, 20 of 45 bone rows, 22 of 34 abdomen rows.

On licences, Giovanni has no paid or membership licences, so only open material counts. RadLex (the radiology terminology of the Radiological Society of North America) allows commercial use under its licence version 2.1, but a term of ours may be added next to RadLex's and must never alter its names. The Portuguese RadLex of the Brazilian Radiology College is members-only and not cleared for reuse; the German one could not be read. The Indiana chest X-ray collection (about 3,955 English reports) is CC BY-NC-ND for its images and states no licence for its reports. Restricted collections (MIMIC-CXR, CheXpert Plus, BRAX) need credentialed access and are not used. As of 2026-11-09 the open PubMed Central search found, with the radiograph phrase in the full text and a CC BY licence, 30,585 English, 57 German and 20 Portuguese case reports; these are upper bounds, not usable reports, and show that German and Portuguese final tests will be small.

Some basic radiology is taught without a citation, so no paper supports it. Giovanni ruled on 2026-11-09 that such items may be kept if marked "foundational", reported apart and judged by the tests. To avoid deciding by opinion, 173 items that still lacked support were measured: for each, research helpers counted the independent open sources that state it (up to 6). Four counting tables (`foundational-chest.md`, `foundational-msk-1.md`, `foundational-msk-2.md`, `foundational-abdomen.md`, one per area, each with the links to the sources found) are merged into the list `docs/r1/foundational-candidates.md`, which sorts them in four tiers: 73 widely stated descriptions and signs (proposed as foundational), 14 widely stated numbers (accepted only if their sources do not all trace to one origin), 50 stated by only one or two sources, and 36 not found in any open source. Nothing in it is accepted yet.

## How it does it
Four research agents (Claude) wrote the drafts on 2026-11-09 from web searches; a second set of four re-read the sources through the open Europe PMC service and corrected the drafts in place. Paywalled pages (Fleischner 2024, the German RadLex, several Thieme and Springer papers) were not read and not bypassed. The documents are not data sets and nothing in them was run. The next step, R2, turns the verified rows into the finding inventory and descriptor schemas of the assistant, deciding what to do with the UNSOURCED rows.

## Where it sits in the pipeline
Step R1 of the finding assistant, after the problem statement (R0) and before the finding inventory (R2); see [[radiology-analysis]] for the step record.

## Who receives its output
Step R2 of the finding assistant, and Giovanni for the decisions on UNSOURCED rows.
