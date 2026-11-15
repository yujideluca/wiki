---
id: radiology-final-test-batch
title: Final-test batch of real radiology reports, "batch 2" (real_reports.py collect2, annotate2, label2, verify2, status2)
aliases: [batch 2, final-test batch, held-out batch of real reports, real-reports-batch2.json, collect2, annotate2, label2, verify2, score2, status2, sealed manifest]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/real_reports.py
fed_by: [radiology-analysis]
feeds: [radiology-real-report-factcheck, radiology-report-matcher]
sources: [radiology-crawler:analysis/real_reports.py, radiology-crawler:tests/test_real_reports_batch2.py, radiology-crawler:docs/real-reports-batch2.json, radiology-crawler:docs/real-reports-factcheck-batch2-xray.json, radiology-crawler:docs/real-reports-factcheck-batch2-ultrasound.json, radiology-crawler:docs/real-reports-factcheck-batch2-ct.json, radiology-crawler:docs/real-reports-factcheck-batch2-mri.json, radiology-crawler:analysis/second_check.py, radiology-crawler:tests/test_second_check.py, radiology-crawler:DESIGN.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json]
reviewed: 2026-11-15T17:31Z
memory: []
---

## What it is
A set of 340 real radiology report texts that the project keeps aside for one purpose: to measure, once and at the end, how well the finding assistant works on text written by real doctors. The finding assistant ([[radiology-report-matcher]]) is a program that turns a loose description of something seen on an image into exact radiological terms. A "finding" is one named observation on an image, for example a pleural effusion.

The set is called "batch 2". It is "held out": nobody who builds or tunes the assistant may look at it, and no number measured on it may be used to improve the assistant. A first, smaller batch ("batch 1") was looked at while building and so cannot serve as the final test ([[radiology-real-report-factcheck]]).

State on 2026-11-15 (commit `33d7776` of the repository `~/dev/radiology-crawler`): batch 2 is **collected, labelled, fact-checked by two checkers for all four imaging methods, and re-checked against the full texts of the articles**. It is **not scored**. The assistant has never been run on it, so there is no result of any kind for it yet. The committed manifest says the same in four fields: `held_out: true`, `development_batch: false`, `fact_checked: true`, `scored: false`. The single scoring waits for Giovanni's go.

Three rules of Giovanni shape everything on this page:

- **The final test never feeds the algorithm** (2026-11-14, requirement AN-104; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). What the fact-check of batch 2 learns stays in a sealed folder. Outside it, only counts, dates and checksums are written: no finding name, no name of a missing finding, no source, no reason, no report text. So the people and sessions that build the assistant cannot learn from the batch what to fix.
- **No pooling across imaging methods** (2026-11-15, requirement AN-101). X-ray, ultrasound, CT (computed tomography) and MRI (magnetic resonance imaging) each have their own list of findings and their own naming. Each is labelled, checked and scored on its own, and no combined number is reported.
- **A fact-check must rest on full articles, not abstracts** (2026-11-15, requirement AN-123). An abstract is the short summary at the head of a journal article. This rule was given after the first checks below were done, so every decision was read again against a full text the same day; the result is under "Re-checked against full texts".

## Flow
trigger t1: The plan needs an untouched batch of real reports for the final test | [[radiology-report-matcher]]
step s1: collect2 takes report sentences from openly licensed case reports, per imaging method
decide d1: Does the article or a sentence also stand in batch 1 or in the training data?
product p0: The report is refused and another article is tried
step s2: Two annotators each name the findings of every report, on the lists of one recorded commit
step s3: label2 keeps the findings both annotators name and counts the rest
step s4: A first checker decides every agreed label against open literature | [[radiology-real-report-factcheck]]
step s5: A second checker judges every agreed label blind; disagreements are resolved
product p1: Committed manifests: ids, licences, checksums and counts only | [[radiology-report-matcher]]
step s6: status2 shows which guard of the scoring would refuse now; it reads only
decide d2: Has Giovanni typed the confirmation sentence?
product p2: Nothing is scored; the batch stays sealed
product p3: score2 runs once: one result per imaging method, never pooled | [[radiology-report-matcher]]

t1 -> s1
s1 -> d1
d1 -yes-> p0
d1 -no-> s2
s2 -> s3
s3 -> s4
s4 -> s5
s5 -> p1
s5 -> s6
s6 -> d2
d2 -no-> p2
d2 -yes-> p3

## What it does
All numbers below come from the committed manifests `docs/real-reports-batch2.json` and `docs/real-reports-factcheck-batch2-<method>.json`. They are counts of a collection, of a labelling and of a fact-check, on held-out real reports. **None of them is a score of the assistant.**

**Collected.** 340 reports: 100 for X-ray, 100 for ultrasound, 70 for CT and 70 for MRI. The batch first had 70 per method (2026-11-14); on 2026-11-15 it was extended by 30 X-ray and 30 ultrasound reports under the same rules, before those two methods were fact-checked (commit `d2175a9`). A "report" here is the sentences of one published case report that describe what one imaging method showed. The articles come from PubMed Central (PMC), the free full-text archive of the US National Library of Medicine, read through the web service Europe PMC on 2026-11-14 and 2026-11-15. Only articles whose own file states an open licence are taken; all 340 carry CC BY (Creative Commons Attribution, a licence that allows reuse when the author is named). One article serves one method only.

**Checked for overlap.** A held-out set is worthless if the assistant has already seen its text. Every report was compared with the 37 articles of batch 1, the 2,425 articles of the training data and 218,836 sentences of training texts and teaching cases. Overlaps found: 0.

**Labelled.** Two annotators, the language models Sonnet and Codex, each read every report with the project's lists of findings ([[radiology-finding-inventory]] for X-ray, [[radiology-modality-corpus]] for the other methods) and named the findings it states. Both used the lists exactly as they stood at one recorded commit (`600af44`), read from git, the version-control system that holds the code. Tokens used (a token is the unit in which model use is counted): Sonnet 633,086, Codex 682,024. Only a finding that **both** annotators name for a report counts; the project calls such a pair an "agreed structure" or "agreed label".

| Method | Reports | Agreed labels | Disputed pairs | Same set | Reports with none agreed | Unlisted names |
|---|---|---|---|---|---|---|
| X-ray | 100 | 94 | 42 | 68.0 % | 39 | 164 |
| Ultrasound | 100 | 99 | 74 | 58.0 % | 37 | 230 |
| CT | 70 | 111 | 58 | 57.1 % | 20 | 128 |
| MRI | 70 | 150 | 68 | 52.9 % | 10 | 153 |

How to read the columns. A "disputed pair" is a finding only one annotator names for a report. "Same set" is the share of reports for which both annotators named exactly the same findings. An "unlisted name" is a finding an annotator wrote down because nothing in the list fitted; the column counts different names. The manifest also gives the mean Jaccard index per method (for one report: the findings both named, divided by the findings either named): 0.763, 0.736, 0.747 and 0.782 in the order of the table. The manifest adds the agreed labels to 454; that sum is a count of labels to be checked, not a pooled result.

The agreement matters for the later score: where the two annotators do not agree on what a report states, the assistant cannot be marked right or wrong, so low agreement limits what the final test can show.

**Fact-checked by two checkers** (2026-11-15, requirements AN-92 and AN-109). The plan asks that the batch be "fact-checked by two checkers and the literature". For each method, on its own:

1. The first checker (a Claude session with research helpers) decided every agreed label against open literature: `confirmed` or `rejected`, with a source and a reason. [[radiology-real-report-factcheck]] describes this method.
2. The second checker (the model Codex, from another maker) judged every agreed label "blind": it saw only the finding's name and definition and the words of the report, never the first verdict, its reason or its sources (`analysis/second_check.py`).
3. Where the two disagreed, the first checker resolved the label against the sources before anything was recorded. No human took part; the manifests say so.

| Method | Agreed labels | Confirmed | Rejected | Second checker agreed | Disagreed (resolved as confirmed, as rejected) | Rows in the checked set |
|---|---|---|---|---|---|---|
| X-ray | 94 | 88 | 6 | 82 | 12 (7, 5) | 88 |
| Ultrasound | 99 | 97 | 2 | 89 | 10 (9, 1) | 97 |
| CT | 111 | 110 | 1 | 106 | 5 (4, 1) | 110 |
| MRI | 150 | 146 | 4 | 133 | 17 (14, 3) | 146 |

The "checked set" is what will be scored: the agreed labels minus the rejected ones. Only agreed labels were checked; disputed pairs and unlisted names of batch 2 were not settled, because they are not scored. The X-ray count changed with the second check: after the first checker alone it was 93 confirmed and 1 rejected (commit `811d9c5`); after the blind second check and the resolution it is 88 and 6.

How far the literature carries each decision was graded by the first checker as `full`, `partial` or `unverified`. After the first check: X-ray 67 full and 27 partial; ultrasound 55 and 44; CT 64 and 47; MRI 84 and 66; none `unverified`. Those sealed manifests did not say how each source had been read.

**Re-checked against full texts** (2026-11-15, requirement AN-123, commits `b138cae`, `16b094c`, `cc4feff`, `9466f4f` and `8f61f60`). Since that requirement every source of a decision states how it was read (the full text, an abstract only, or not read), and a decision without a source read in full text counts as `unverified`, never as supported ([[radiology-real-report-factcheck]] gives the rule). The judge session read every agreed label again against full texts. The commit messages give the state before: of the 94 X-ray labels 60 rested on a full text and 34 on an abstract or a page summary only; of the 99 ultrasound labels 98 and 1; of the 111 CT labels 108; of the 150 MRI labels 145 and 5.

| Method | Agreed labels | Resting on a full text | On an abstract only | On nothing | Support full / partial / unverified | Sources used |
|---|---|---|---|---|---|---|
| X-ray | 94 | 94 | 0 | 0 | 63 / 31 / 0 | 60 |
| Ultrasound | 99 | 99 | 0 | 0 | 60 / 39 / 0 | 82 |
| CT | 111 | 111 | 0 | 0 | 82 / 29 / 0 | 82 |
| MRI | 150 | 150 | 0 | 0 | 111 / 39 / 0 | 92 |

No verdict changed in any method: the confirmed and rejected counts, the checked sets and their checksums are the same as before the re-check. For CT one label had only an abstract after the first pass of the re-check and was recorded as `unverified` (commit `cc4feff`); a full text was then found for it (commit `8f61f60`). The manifests also count how many decisions name the place in the text that carries them: 52, 46, 52 and 68. "Rests on a full text" is what the checker recorded; the program checks that the reading level is stated, and no human took part.

**What is still open.** The single scoring. `score2 --confirm "score batch 2 once"` runs the assistant on each of the four methods. It has not been run, and Giovanni decides when.

## How it does it
Everything is in the program `analysis/real_reports.py`, run as `python3 -I analysis/real_reports.py COMMAND`, plus `analysis/second_check.py` for the second checker.

Selection (`collect2 --per-method 70`, no model involved; `--methods xray ultrasound` fills only the named methods, which is how the batch was extended). For each method the program asks Europe PMC for case reports that match a fixed search phrase (for X-ray: `radiograph OR "x-ray" OR "plain film"`), in an order fixed by the seed 20261114 (a seed is a number that makes a random order repeatable). From each article it takes the sentences about that one method and drops sentences with personal context. It records, per report, an identifier, the PMC number of the article, the licence and its address, the date, and the first 16 characters of the SHA-256 (Secure Hash Algorithm 256) fingerprint of the text.

Refusals. A report is refused when its article is in batch 1 or in any training source, or when one of its sentences stands in a training text or a Radiopaedia teaching case (Radiopaedia is the reference site the project collects pages from).

Labelling (`annotate2 --engine sonnet`, then `--engine codex`, then `label2 --engines sonnet codex`). Each label keeps the identifier of the finding in the list, the list's name for it at the recorded commit, the annotator's own name for the finding, and a quote that must stand in the report text. A label made against a second commit is refused. This matters because the lists keep changing after the labelling. When the batch is scored, a label on a merged entry is read as the surviving entry, and a label whose finding has no place in the current list is left out and counted (function `remap_labels`).

Fact-check join (`factcheck --real-batch 2 --method METHOD`). It joins the first checker's decision file with the agreed labels of one method and refuses an incomplete check. For batch 2 the committed manifest is "sealed": it holds counts and checksums (fingerprints that change when a file changes) only. The verdict rows, the names of findings the list lacks, the sources and the reasons stay in the folder `data/`, which is not in git, until Giovanni decides who may see them.

Second check (`python3 -I analysis/second_check.py run --method xray --engine codex`, then `compare`, then `record`). `run` asks the second model in groups of 25 labels and can be resumed. `compare` counts agreements; with `--show` it lists the disagreements on screen only. `record` writes the counts into the decisions and refuses while a disagreement is unresolved; the fact-check join is then run again so that the sealed manifest carries the second-check counts.

Guards of the scoring (`score2`, requirements AN-101, AN-102, AN-121). It refuses unless: the batch is held out, fact-checked and never scored; the second checker saw every agreed label of every method (the count of second-check labels must equal the count of agreed labels, per method); the confirmation sentence is typed; the engine, the lists and the scoring programs have no uncommitted change; and each checked set still has its recorded checksum. It marks the batch as started before the first report is scored, so it cannot be run a second time. It reports one row per imaging method and no pooled row. For hurried wording it reports the same three numbers as the engine's own measurements ([[radiology-finding-engine]]), with a simulated user.

Status (`status2`, requirement AN-121). It names each of those guards and says "ok" or why it would refuse now. It reads only: nothing is scored, opened or written. The plan note of 2026-11-15 records that it showed every guard ok; the typed confirmation is the one step left, and it is Giovanni's.

What is committed and what is not. The report texts, the labels and the decisions stay in `data/`. The manifests in `docs/` hold identifiers, licences, checksums and counts, and no report text. A test checks that everything the batch-2 fact-check writes outside the sealed folder is counts, dates and checksums only.

Twelve requirements describe this: AN-79 and AN-80 (collection and overlap), AN-89 to AN-91 (manifest, labelling, agreement), AN-92 (fact-check per method), AN-101 and AN-102 (scoring once and per method, reading old labels on the current lists), AN-104 (the sealed outputs), AN-109 (the blind second check), AN-121 (the two-checker guard and `status2`) and AN-123 (how each source was read). `tests/test_real_reports_batch2.py` holds 14 tests and `tests/test_second_check.py` 3, all on small invented examples.

## Steps
1. The judge session (a Claude session that works only on held-out data and never changes the assistant) runs `collect2`. Output: the raw batch in `data/`. Done: 70 reports per method on 2026-11-14, 30 more for X-ray and for ultrasound on 2026-11-15.
2. The judge runs `annotate2` once per annotator. Output: each annotator's answers in `data/`.
3. The judge runs `label2 --engines sonnet codex`. Output: the labelled batch in `data/` and the counts per method.
4. The judge runs `verify2`. Output: a pass, or a failure that names every overlap or changed file.
5. For each method, the judge (first checker) decides every agreed label against open literature and runs `factcheck --real-batch 2 --method METHOD`. Output: a sealed manifest per method. Done on 2026-11-15 (commits `811d9c5` X-ray, `7d55d9a` ultrasound, `baa8786` CT, `91cc7ff` MRI).
6. For each method, the second checker judges every agreed label blind (`second_check.py run`); the judge resolves each disagreement, runs `record` and joins the fact-check again. Output: the second-check counts in the manifests. Done for all four methods on 2026-11-15.
7. The judge runs `status2`. Output: the list of guards, each "ok" or the reason it would refuse.
8. For each method, the judge reads every agreed label again against the full text of an article, records how each source was read, and joins the fact-check again. Output: the counts per reading level in the manifests. Done for all four methods on 2026-11-15.
9. Not done: Giovanni gives the go and `score2 --confirm "score batch 2 once"` runs once. Output: one result per method in the results registry of [[radiology-analysis]].

## Where it sits in the pipeline
At the end of the project's chain: after the lists of findings and the engine ([[radiology-finding-engine]]) exist, and before the single final measurement. It is separate from the one-time test of the X-ray milestone, which scores the frozen test half of the simulated data and batch 1 and has not been run either ([[radiology-one-time-test]]). It is also separate from the open "development batch" of real reports for ultrasound, CT and MRI, which may be looked at and is never a test ([[radiology-real-report-factcheck]]); the collection of that batch excludes every article of batch 2.

## Who receives its output
The fact-check ([[radiology-real-report-factcheck]]) receives the labelled batch. Giovanni and any reader of the repository receive the manifests; the plan on [[radiology-report-matcher]] shows the milestone "Final test on fresh real reports" as in progress.

## Notes
The report texts, the labels, the decisions and every file under `data/` were not opened for this page, on purpose: they are held out. Everything here comes from the code, its tests, the committed manifests, the requirement rows, the decision log and the plan.
