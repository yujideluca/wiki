---
id: radiology-final-test-batch
title: Final-test batch of real radiology reports, "batch 2" (real_reports.py collect2, annotate2, label2, verify2)
aliases: [batch 2, final-test batch, held-out batch of real reports, real-reports-batch2.json, collect2, annotate2, label2, verify2, score2]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/real_reports.py
fed_by: [radiology-analysis]
feeds: [radiology-real-report-factcheck, radiology-report-matcher]
sources: [radiology-crawler:analysis/real_reports.py, radiology-crawler:tests/test_real_reports_batch2.py, radiology-crawler:docs/real-reports-batch2.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json]
reviewed: 2026-11-14T23:13Z
memory: []
---

## What it is
A set of 280 real radiology report texts that the project keeps aside for one purpose: to measure, once and at the end, how well the finding assistant works on text written by real doctors. The finding assistant ([[radiology-report-matcher]]) is a program that turns a loose description of something seen on an image into exact radiological terms. A "finding" is one named observation on an image, for example a pleural effusion.

The set is called "batch 2". It is "held out": nobody who builds or tunes the assistant may look at it, and no number measured on it may be used to improve the assistant. A first, smaller batch ("batch 1") was looked at while building and so cannot serve as the final test ([[radiology-real-report-factcheck]]).

State on 2026-11-14 (commit `7bbdaaa` of the repository `~/dev/radiology-crawler`): batch 2 is **collected and labelled**. It is **not fact-checked** and **not scored**. The assistant has never been run on it, so there is no result of any kind for it yet. The committed manifest says the same in four fields: `held_out: true`, `development_batch: false`, `fact_checked: false`, `scored: false`.

## Flow
trigger t1: The plan needs an untouched batch of real reports for the final test | [[radiology-report-matcher]]
step s1: collect2 takes report sentences from openly licensed case reports, 70 per imaging method
decide d1: Does the article or a sentence also stand in batch 1 or in the training data?
product p0: The report is refused and another article is tried
step s2: Two annotators each name the findings of every report, on the lists of one recorded commit
step s3: label2 keeps the findings both annotators name and counts the rest
step s4: verify2 repeats the overlap and checksum checks on the stored batch
product p1: The committed manifest: ids, licences, checksums and counts, no report text | [[radiology-report-matcher]]
product p2: The labelled batch in the data folder, waiting for its fact-check | [[radiology-real-report-factcheck]]

t1 -> s1
s1 -> d1
d1 -yes-> p0
d1 -no-> s2
s2 -> s3
s3 -> s4
s4 -> p1
s4 -> p2

## What it does
All numbers below come from the committed manifest `docs/real-reports-batch2.json`. They are counts of a collection and of a labelling. None of them is a score of the assistant.

**Collected.** 280 reports, 70 for each of the four imaging methods: X-ray, ultrasound, CT (computed tomography) and MRI (magnetic resonance imaging). A "report" here is the sentences of one published case report that describe what one imaging method showed. The articles come from PubMed Central (PMC), the free full-text archive of the US National Library of Medicine, read through the web service Europe PMC on 2026-11-14. Only articles whose own file states an open licence are taken; all 280 carry CC BY (Creative Commons Attribution, a licence that allows reuse when the author is named). One article serves one method only.

**Checked for overlap.** A held-out set is worthless if the assistant has already seen its text. Every report was compared with the 37 articles of batch 1, the 2,425 articles of the training data and 218,836 sentences of training texts and teaching cases. Overlaps found: 0.

**Labelled.** Two annotators, the language models Sonnet and Codex, each read every report with the project's lists of findings ([[radiology-finding-inventory]] for X-ray, [[radiology-modality-corpus]] for the other methods) and named the findings it states. Both used the lists exactly as they stood at one recorded commit (`600af44`), read from git, the version-control system that holds the code. Tokens used (a token is the unit in which model use is counted): Sonnet 541,034, Codex 582,310. Only a finding that **both** annotators name for a report counts; the project calls such a pair an "agreed structure".

| Method | Reports | Agreed structures | Disputed pairs | Same set | Reports with none agreed | Unlisted names |
|---|---|---|---|---|---|---|
| X-ray | 70 | 75 | 27 | 72.9 % | 20 | 112 |
| Ultrasound | 70 | 74 | 54 | 55.7 % | 23 | 150 |
| CT | 70 | 111 | 58 | 57.1 % | 20 | 128 |
| MRI | 70 | 150 | 68 | 52.9 % | 10 | 153 |
| Total | 280 | 410 | | | | |

How to read the columns. A "disputed pair" is a finding only one annotator names for a report. "Same set" is the share of reports for which both annotators named exactly the same findings. An "unlisted name" is a finding an annotator wrote down because nothing in the list fitted; the column counts different names. The manifest also gives the mean Jaccard index per method (for one report: the findings both named, divided by the findings either named): 0.819, 0.719, 0.747 and 0.782 in the order of the table.

The agreement matters for the later score: where the two annotators do not agree on what a report states, the assistant cannot be marked right or wrong, so low agreement limits what the final test can show.

**What is still open.** The plan milestone "Final test on fresh real reports" lists two open points: the fact-check of batch 2 and its single scoring. The commands for both exist since commit `7bbdaaa` and had not been run at that commit:

- `factcheck --real-batch 2 --method METHOD` joins a judge's literature decisions with the agreed labels, per imaging method ([[radiology-real-report-factcheck]] describes the method).
- `score2 --confirm "score batch 2 once"` runs the assistant on all four methods at once. It refuses unless the batch is held out, fact-checked and never scored, the assistant's code is committed, and every checked file has its recorded checksum. It marks the batch as scored before it scores, so it cannot be run a second time.

## How it does it
Everything is in the program `analysis/real_reports.py`, run as `python3 -I analysis/real_reports.py COMMAND`.

Selection (`collect2 --per-method 70`, no model involved). For each method the program asks Europe PMC for case reports that match a fixed search phrase (for X-ray: `radiograph OR "x-ray" OR "plain film"`), in an order fixed by the seed 20261114 (a seed is a number that makes a random order repeatable). From each article it takes the sentences about that one method and drops sentences with personal context. It records, per report, an identifier, the PMC number of the article, the licence and its address, the date, and the first 16 characters of the SHA-256 (Secure Hash Algorithm 256) fingerprint of the text.

Refusals. A report is refused when its article is in batch 1 or in any training source, or when one of its sentences stands in a training text or a Radiopaedia teaching case (Radiopaedia is the reference site the project collects pages from).

Labelling (`annotate2 --engine sonnet`, then `--engine codex`, then `label2 --engines sonnet codex`). Each label keeps the identifier of the finding in the list, the list's name for it at the recorded commit, the annotator's own name for the finding, and a quote that must stand in the report text. A label made against a second commit is refused. This matters because the lists keep changing: on the same day four duplicate X-ray entries were merged, after the labelling. When the batch is scored, a label on a merged entry is read as the surviving entry, and a label whose finding has no place in the current list is left out and counted (function `remap_labels`).

What is committed and what is not. The report texts and the labels stay in the folder `data/`, which is not in git. The manifest in `docs/` holds identifiers, licences, checksums (fingerprints that change when a file changes) and counts, and no report text.

Eight requirements describe this: AN-79 and AN-80 (collection and overlap), AN-89 to AN-91 (manifest, labelling, agreement), AN-92 (fact-check per method), AN-101 and AN-102 (scoring once, reading old labels on the current lists). A requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check. `tests/test_real_reports_batch2.py` holds 11 tests on small invented examples.

## Steps
1. The judge session (a Claude session that works only on held-out data and never changes the assistant) runs `collect2 --per-method 70`. Output: the raw batch in `data/`, 70 reports per method.
2. The judge runs `annotate2` once per annotator. Output: each annotator's answers in `data/`.
3. The judge runs `label2 --engines sonnet codex`. Output: the labelled batch in `data/` and the counts per method.
4. The judge runs `verify2`. Output: a pass, or a failure that names every overlap or changed file.
5. The judge commits the manifest `docs/real-reports-batch2.json` and records the state in the plan. Output: commits `fe91e85` (manifest) and `91f965f` (plan) of 2026-11-14. The code and its tests entered the repository earlier the same day inside commit `3575a75` of another session, through a staging collision that the project's rules file now guards against ([[radiology-report-matcher]]).
6. Not done yet: the judge fact-checks the agreed labels of each method against the literature and runs `factcheck --real-batch 2 --method METHOD`. Output: a sealed manifest per method (counts and checksums only).
7. Not done yet: `score2` runs once, after the fact-check. Output: one result per method in the results registry of [[radiology-analysis]].

## Where it sits in the pipeline
At the end of the project's chain: after the lists of findings and the engine ([[radiology-finding-engine]]) exist, and before the single final measurement. It is separate from the "one-time test" of the X-ray milestone, which scores the frozen test half of the simulated data and batch 1; that test was prepared and not run on 2026-11-14.

## Who receives its output
The fact-check ([[radiology-real-report-factcheck]]) receives the labelled batch. Giovanni and any reader of the repository receive the manifest; the plan on [[radiology-report-matcher]] shows the milestone as in progress.

## Notes
The report texts, the labels and every file under `data/` were not opened for this page, on purpose: they are held out. Everything here comes from the code, its tests, the committed manifest, the requirement rows and the plan.
