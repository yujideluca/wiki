---
id: radiology-real-report-factcheck
title: Literature fact-check of real radiology reports (real_reports.py factcheck)
aliases: [real-report fact-check, factcheck, batch 1 fact-check, real-reports-factcheck-batch1.json]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/real_reports.py
fed_by: [radiology-analysis]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:analysis/real_reports.py, radiology-crawler:tests/test_real_reports.py, radiology-crawler:docs/real-reports-factcheck-batch1.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:PLAN.md]
reviewed: 2026-11-14T18:50Z
memory: []
---

## What it is
A check that the labels put on real radiology reports are right according to published medical literature. It belongs to the finding assistant ([[radiology-report-matcher]]), a program that turns a loose description of something seen on an image into exact radiological terms. A "finding" is one named observation on an image, for example a pleural effusion. A "label" says that a given report states a given finding.

The project keeps a small collection of real reports, taken from openly licensed publications, to test the assistant at the end. Before a report can test anything, somebody has to say which findings it really states. Two annotators (the language models Sonnet and Codex) each read every report with the project's list of findings ([[radiology-finding-inventory]]) and name the findings they see. This page describes the next step: a third party, the "judge", checks those answers against the literature and settles every case the annotators left open. The first batch of reports was checked on 2026-11-14, which closed the plan milestone "Fact-check the first real reports".

## Flow
trigger t1: Two annotators have labelled a batch of real reports | [[radiology-analysis]]
step s1: The judge session reads open literature for every label and every unplaced name
step s2: The judge writes one decision file: sources, verdicts, reasons, gaps
step s3: The factcheck command joins the decisions with the annotators' labels | [[radiology-analysis]]
decide d1: Is a decision missing, surplus or without a source?
product p0: The run stops and lists the problems; no file is written
product p1: The checked set: labels both annotators gave, minus the rejected ones
product p2: The gap list: findings the list lacks, for the session that builds the list | [[radiology-finding-inventory]]
product p3: The committed manifest: counts, verdicts and sources, no report text | [[radiology-report-matcher]]

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -yes-> p0
d1 -no-> p1
d1 -no-> p2
d1 -no-> p3

## What it does
The annotators' answers fall into three groups, and the check gives each item of each group one verdict:

- An **agreed** label is a (report, finding) pair that both annotators state. Its verdict is `confirmed` or `rejected`.
- A **disputed** label is a pair that only one annotator states. Its verdict is `accepted` or `rejected`.
- An **unlisted** name is a finding name an annotator wrote down because nothing in the list of findings fitted. Its verdict is `synonym` (another word for a finding that is in the list), `gap` (a real finding the list lacks) or `not_a_finding` (a descriptor such as a shape, a statement that something is normal, or a vague phrase).

Every verdict carries a reason and at least one literature source, and a grade of how far the source carries it: `full`, `partial` or `unverified`.

Result for batch 1 (numbers from the committed manifest `docs/real-reports-factcheck-batch1.json`). Batch 1 is a **development batch**: a batch that was used while building, so it may not serve as the final test. These numbers are counts of a fact-check. They are not a score of the assistant; the assistant has not been run on these reports, and the manifest says so (`scored: false`).

- Agreed labels: 46. Confirmed 45, rejected 1. The rejected one is the label of the finding "faecal loading" on one report.
- Disputed labels: 18. Accepted 10, rejected 8.
- Unlisted names: 43 (report, name) pairs, 39 different names when upper and lower case are ignored. Synonyms 11, pointing at a gap 24, not a finding 8 (5 descriptors, 2 vague phrases, 1 normal statement). The milestone text in `PLAN.md` says "41 unlisted names": that is the earlier count made when the reports were labelled ([[radiology-analysis]]), which counts spellings; the fact-check counts pairs.
- Gaps of the list of findings: 9. They are: low lung volumes; dilated oesophagus; dilated bowel loops with the segment not named; fracture with pattern and site not named; periosteal reaction with the type not named; lytic bone lesion with the pattern not named; bone loss around a prosthesis; flatfoot; joint erosion with the type not named. Five of the nine are "generic" entries: the list has only the specific sub-types and no entry for a report that does not say which.
- Defects of existing entries of the list: 6 (for example the same finding listed twice under chest and abdomen, and a definition that is too narrow).
- The checked set has 45 rows: the 46 agreed labels minus the rejected one.
- Sources: 47 publications. Support for the 107 verdicts: full 71, partial 33, unverified 3 (all three are unlisted names).

Limits, as the manifest states them: there was one checker, a Claude session with four research helpers, and no second human or model checker. 33 of the 47 sources were read as a page extract and the quoted words were not compared with the page itself; 11 were read as full text through a PubMed connector (PubMed is the public index of medical articles of the US National Library of Medicine); 3 were read as abstracts only. For 7 sources the licence was not retrieved.

## How it does it
The work is split between a judgement and a mechanical step, so that the judgement can be inspected and the mechanical step can be tested.

The judgement is one decision file per batch, written by the judge. It lists the sources (citation, web address, licence, how the source was read) and then one decision per item. It stays in the folder `data/`, which is not in git (the version-control system that holds the code), because its reasons quote words of the reports.

The mechanical step is the command `python3 -I analysis/real_reports.py factcheck` in the repository `~/dev/radiology-crawler`. It rebuilds the three groups from the annotators' files, joins them with the decision file and refuses to continue when the check is incomplete. The rule is "complete or absent": a fact-check with holes would look finished and is worse than none. The run stops, with a list of every problem, when:

- an item has no decision, has two, or a decision names an item that does not exist;
- a verdict is not one of the words allowed for its group;
- a decision has no reason, has no source, or names a source that is not in the source list;
- a source lacks its citation, its web address or the note on how it was read;
- a synonym does not point at a finding of the list, or a gap verdict does not point at an entry of the gap list;
- a gap lacks a name, a definition, a source, or has no unlisted name pointing at it;
- a defect names a finding that is not in the list or does not say what is wrong.

When everything is in order it writes four files:

1. The full records with reasons, in `data/`.
2. The gap list, in `data/`: each gap with its name, body area, definition, sources and the reports it came from, plus the defects of existing entries. It is addressed to the "corpus lane", the working area of the project whose session builds the lists of findings; that session decides whether each gap becomes an entry.
3. The checked set, in `data/`: the agreed labels without the rejected ones.
4. The manifest `docs/real-reports-factcheck-batch1.json`, committed to git. It holds the counts, each verdict by report number and finding identifier, the sources, the gaps and checksums of the other files (a checksum is a fingerprint that changes when the file changes). It holds no report text, no reason and no unlisted name: each unlisted name appears only as the first 16 characters of its SHA-256 (Secure Hash Algorithm 256) fingerprint. It marks the batch as a development batch and as not scored.

One decision is recorded in the decision log of the repository's `DESIGN.md` (2026-11-14): a disputed label that the literature accepts is recorded but stays out of the checked set. The project counts only labels that both annotators agree on; an accepted disputed label would rest on one annotator plus one checker. So the 10 accepted disputed labels of batch 1 are in the records and not among the 45 rows.

Three requirements describe this, AN-76 to AN-78 (a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). Six tests in `tests/test_real_reports.py` check them on small invented examples: the counts add up; a missing, surplus or unsourced decision is refused; an unlisted name must be a synonym, a sourced gap or not a finding; the gap file names each gap with its source and reports; the manifest contains none of the words of the example; the checked set drops a rejected agreed label and keeps an accepted disputed one out.

## Steps
1. The two annotators label the batch; the command `label` of the same program keeps the pairs both state. Output: the labelled file in `data/` (described on [[radiology-analysis]]).
2. The judge (a Claude session that works only on held-out data and never changes the assistant in the same session) reads open literature for each agreed label, each disputed label and each unlisted name. Output: the decision file in `data/`.
3. The judge runs `factcheck`. Output: either a list of problems and no files, or the records, the gap list, the checked set and the manifest.
4. The judge commits the manifest and records the milestone as done with the plan tool. Output for batch 1: commits `c953478` (code, tests, manifest) and `2160a8d` (plan) of 2026-11-14.
5. The corpus session reads the gap list and decides, with its own sources, which gaps and defects change the list of findings. Not done yet on 2026-11-14.

## Where it sits in the pipeline
After the labelling of real reports by `analysis/real_reports.py label` ([[radiology-analysis]]) and before any scoring of the assistant on real reports. Scoring batch 1 is part of a later milestone ("X-ray: the one-time test"); the final test uses a new, untouched batch, which the plan says must be fact-checked by two checkers and the literature.

## Who receives its output
The session that builds the lists of findings ([[radiology-finding-inventory]]) receives the gap list. The later scoring step receives the checked set. Giovanni and any reader of the repository receive the manifest; the plan in [[radiology-report-matcher]] shows the milestone as done.

## Notes
The contents of the reports and of the files in `data/` were not opened for this page; everything here comes from the code, its tests, the committed manifest, the requirement rows, the decision log and the plan.
