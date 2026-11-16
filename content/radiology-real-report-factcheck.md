---
id: radiology-real-report-factcheck
title: Literature fact-check of real radiology reports (real_reports.py factcheck, second_check.py, dev_batch.py)
aliases: [real-report fact-check, factcheck, batch 1 fact-check, real-reports-factcheck-batch1.json, analysis/second_check.py, blind second check, second checker, analysis/dev_batch.py, development batch, dev batch 1, real-reports-dev1.json]
kind: process
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/real_reports.py
fed_by: [radiology-analysis, radiology-final-test-batch, radiology-fulltext-resolver]
feeds: [radiology-report-matcher, radiology-finding-inventory, radiology-modality-corpus, radiology-one-time-test]
sources: [radiology-crawler:analysis/real_reports.py, radiology-crawler:tests/test_real_reports.py, radiology-crawler:docs/real-reports-factcheck-batch1.json, radiology-crawler:analysis/second_check.py, radiology-crawler:tests/test_second_check.py, radiology-crawler:analysis/dev_batch.py, radiology-crawler:tests/test_dev_batch.py, radiology-crawler:docs/real-reports-dev1.json, radiology-crawler:docs/real-reports-factcheck-dev1-ultrasound.json, radiology-crawler:docs/real-reports-factcheck-dev1-ct.json, radiology-crawler:docs/real-reports-factcheck-dev1-mri.json, radiology-crawler:docs/real-reports-factcheck-batch2-xray.json, radiology-crawler:docs/real-reports-factcheck-batch2-ultrasound.json, radiology-crawler:docs/real-reports-factcheck-batch2-ct.json, radiology-crawler:docs/real-reports-factcheck-batch2-mri.json, radiology-crawler:docs/real-reports-batch2.json, radiology-crawler:tests/test_real_reports_batch2.py, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:PLAN.md, radiology-crawler:tests/test_dev_batch_score.py, radiology-crawler:docs/results-registry.json, radiology-crawler:docs/held-out-relabel.json]
reviewed: 2026-11-16T21:47Z
memory: []
---

## What it is
A check that the labels put on real radiology reports are right according to published medical literature. It belongs to the finding assistant ([[radiology-report-matcher]]), a program that turns a loose description of something seen on an image into exact radiological terms. A "finding" is one named observation on an image, for example a pleural effusion. A "label" says that a given report states a given finding.

The project keeps a small collection of real reports, taken from openly licensed publications, to test the assistant at the end. Before a report can test anything, somebody has to say which findings it really states. Two annotators (the language models Sonnet and Codex) each read every report with the project's list of findings ([[radiology-finding-inventory]]) and name the findings they see. This page describes the next step: a third party, the "judge", checks those answers against the literature and settles every case the annotators left open. The first batch of reports was checked on 2026-11-14, which closed the plan milestone "Fact-check the first real reports".

Since 2026-11-15 the check has a second half: a second, independent checker that judges the same labels without seeing the first checker's answer. On that day three sets of reports were checked this way: the held-out final-test batch, for all four imaging methods ([[radiology-final-test-batch]]), and a new, open "development batch" for ultrasound, CT (computed tomography) and MRI (magnetic resonance imaging), described below. Later the same day both sets were checked again against the full texts of the articles, after Giovanni ruled that an abstract is not enough; the section "Full articles, not abstracts" gives the result. The fact-check counts below are not scores. A separate repeatable development score on the open ultrasound, CT and MRI reports is described below; neither held-out batch has been scored.

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

### The blind second check (2026-11-15)
The plan asks that the final test be checked "by two checkers and the literature". The first check alone is one model's reading of the sources. So `analysis/second_check.py` adds a second checker, where possible a model of another maker (Codex), that works "blind": for each label it sees only the finding's name and definition, as the list stood at the commit of the labelling, and the words of the report. It never sees the first verdict, its reason or its sources. It answers `confirmed` or `rejected`. Agreement is recorded as counts. Every disagreement must be resolved by the judge against the sources, with a written resolution on the decision, before the counts can be recorded; the program refuses otherwise (requirement AN-109; a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check). No human checker took part in any check on this page, and the manifests say so.

For the held-out final-test batch the counts per imaging method are on [[radiology-final-test-batch]]; only counts leave its sealed folder.

### The development batch for ultrasound, CT and MRI (2026-11-15)
Batch 1 holds X-ray reports only. The other three imaging methods had no real reports that the builders were allowed to look at. `analysis/dev_batch.py` (requirement AN-111) collects such a set, "dev batch 1": 20 report passages per method from openly licensed case reports in PubMed Central (the free full-text archive of the US National Library of Medicine), all under the licence CC BY (Creative Commons Attribution), labelled by the same two annotators and fact-checked like batch 1.

It is **open**: every session may read it, and the findings it shows to be missing from the lists are published for the session that builds the lists ([[radiology-modality-corpus]]). It is **never a sealed test**: the fact-check manifest says `development_batch: true`, `held_out: false`, `scored: false`. A later, separately labelled development score may be repeated and may guide tuning; it is kept outside the test results. Each method is checked against its own list; nothing is pooled across methods.

Collection and labelling (manifest `docs/real-reports-dev1.json`): 60 reports, collected on 2026-11-15, labelled on the lists of commit `7d55d9a`. Each report was compared with 377 articles of the other real-report batches (batch 1 and the final-test batch), 2,569 articles of the training data and 219,149 sentences; overlaps found: 0. Tokens used (a token is the unit in which model use is counted): Sonnet 159,272, Codex 128,496.

**Withdrawals** (requirement AN-119). The same day, the session that builds the training data added more public texts ([[radiology-modality-corpus]]), and six of the 60 articles ended up in the training material: two CT and four MRI reports. A report that the assistant may have trained on shows nothing, so `dev_batch.py withdraw` marks such reports. They stay named in the manifest with the reason, no check or count uses them, and the fact-check join refuses to run while such a report is not withdrawn. That leaves 20 ultrasound, 18 CT and 16 MRI reports. In the other direction, a rule of the training side keeps the remaining development reports out of every training corpus (requirement AN-113).

Fact-check results (manifests `docs/real-reports-factcheck-dev1-<method>.json`; counts of a fact-check on open development reports, not scores):

| | Ultrasound | CT | MRI |
|---|---|---|---|
| Reports checked | 20 | 18 | 16 |
| Agreed labels confirmed / rejected | 23 / 0 | 41 / 0 | 20 / 0 |
| Disputed labels accepted / rejected | 8 / 5 | 11 / 3 | 11 / 3 |
| Unlisted names: synonym / gap / not a finding | 3 / 20 / 12 | 1 / 27 / 10 | 3 / 16 / 2 |
| Gaps of the list (distinct missing findings) | 11 | 14 | 8 |
| Defects of existing entries | 0 | 0 | 1 |
| Second checker: items, agreed, disagreed | 47, 43, 4 | 69, 66, 3 | 42, 35, 7 |
| Support before the full-text re-check: full / partial / unverified | 0 / 54 / 17 | 4 / 53 / 36 | 0 / 44 / 11 |
| Support after it: full / partial / unverified | 22 / 49 / 0 | 39 / 54 / 0 | 27 / 28 / 0 |
| Decisions resting on a full text / an abstract only / nothing, after it | 71 / 0 / 0 | 93 / 0 / 0 | 55 / 0 / 0 |

For this batch the second checker also judges the disputed labels and every proposed gap, the latter against the method's whole list: is it a real finding, and does the list lack it (requirement AN-120). The gap lists are open. Examples: for ultrasound "joint effusion", "portal vein thrombosis" and "unicornuate uterus"; for CT "pseudoaneurysm", "carotid artery stenosis" and "intramuscular abscess"; for MRI "pulmonary regurgitation" and "linear leptomeningeal enhancement". The one defect found is an MRI definition that contains words of a single case. A defect must name the listed finding, what is wrong and at least one source (requirement AN-122). The gaps are proposals: the session that builds the lists decides, with its own sources, which become entries. It has since added all 33 to the three lists, each with sources it found and read itself (commits `004903b` and `952d328`, requirement AN-124; [[radiology-modality-corpus]]).

### Full articles, not abstracts (Giovanni, 2026-11-15)
On 2026-11-15 Giovanni ruled that a fact-check must rest on full articles, not on abstracts (an abstract is the short summary at the head of a journal article). The checks above were done before that rule. The rule is now requirement AN-123, and the program enforces it for every batch except batch 1:

- Every source states how it was read, in a field `level`: `full_text` (the passage was read in the full text of the article), `abstract` (only an abstract, or a machine summary of the page, was read) or `none` (not read: the list's own reference, or the report itself).
- A decision rests on the best level among its sources. A decision with no source read in full text may only be graded `unverified`; the join refuses it when it claims `full` or `partial` support.
- Each manifest counts the decisions per level (`evidence`), and how many name the place in the text that carries them (`passage_recorded`).

**Before the re-check**, as the open manifests of the development batch then showed: the share of decisions graded `unverified` was 17 of 71 for ultrasound, 36 of 93 for CT and 11 of 55 for MRI, and of the sources that had been read nearly all were abstracts. The first commits of the re-check give the starting point per decision: resting on a full text 0 of 71 for ultrasound, 8 of 93 for CT and 0 of 55 for MRI; on an abstract only 56, 49 and 44; on nothing 15, 36 and 11.

**The re-check** (judge session, 2026-11-15, commits `792691b` to `8f61f60`). Every decision of the development batch and of the final-test batch was read again against the full text of an article. Where a source had only been read as an abstract, its full text or another full text was found. One tool for this is the full-text resolver ([[radiology-fulltext-resolver]]), a program that fetches the body of an article by open routes only; one commit message names it for a guideline that the article services did not serve.

**After the re-check**, from the committed manifests:

- Development batch: all 71 ultrasound, 93 CT and 55 MRI decisions rest on a source read in full text. None rests on an abstract only, none on nothing, and none is graded `unverified`. Support is full for 22, 39 and 27 decisions and partial for 49, 54 and 28. No verdict changed. The manifests now list 82, 134 and 79 sources.
- For CT, ten decisions were read again in other full texts than the ones the list-building session used for its new entries, so that the two pieces of work stay independent (commit `ad5f26c`).
- Final-test batch: all 454 agreed labels rest on a source read in full text; the counts per imaging method are on [[radiology-final-test-batch]]. No verdict changed, and the checked sets and their checksums are unchanged.
- The plan note of that day sums both up: all 673 decisions (219 of the development batch and 454 of the final-test batch) rest on a full text.

Limits of this statement. "Rests on a full text" means that the checker recorded reading the passage in the article's full text; the program checks that the level is stated, not that the reading happened. No human took part. Batch 1 is not covered: its manifest keeps the limits stated above (33 of 47 sources read as a page extract, 3 as abstracts), and the program does not apply the rule to it.

**Repeatable development score, 2026-11-15.** `analysis/dev_batch.py score` measures the fact-checked structures of the open development batch by imaging method. It reports strict top-three hits, a separately labelled parent-or-child family rate, simulated answers to questions, missing training rows and list gaps. The result is marked “development, repeatable, not a test” in `docs/results-registry.json`; it may guide tuning and is not a sealed test result. The recorded run on committed engine `c1bc2c9` counted 23 ultrasound structures (100% strict top three), 41 CT structures (82.93%) and 20 MRI structures (85%). These small open samples do not establish final accuracy.

## How it does it
The work is split between a judgement and a mechanical step, so that the judgement can be inspected and the mechanical step can be tested.

The judgement is one decision file per batch, written by the judge. It lists the sources (citation, web address, licence, how the source was read) and then one decision per item. It stays in the folder `data/`, which is not in git (the version-control system that holds the code), because its reasons quote words of the reports.

The mechanical step is the command `python3 -I analysis/real_reports.py factcheck` in the repository `~/dev/radiology-crawler`. It rebuilds the three groups from the annotators' files, joins them with the decision file and refuses to continue when the check is incomplete. The rule is "complete or absent": a fact-check with holes would look finished and is worse than none. The run stops, with a list of every problem, when:

- an item has no decision, has two, or a decision names an item that does not exist;
- a verdict is not one of the words allowed for its group;
- a decision has no reason, has no source, or names a source that is not in the source list;
- a source lacks its citation, its web address or the note on how it was read; since requirement AN-123, and not for batch 1, a source whose `level` is not `full_text`, `abstract` or `none`;
- since AN-123, and not for batch 1, a decision that claims support while none of its sources was read in full text;
- a synonym does not point at a finding of the list, or a gap verdict does not point at an entry of the gap list;
- a gap lacks a name, a definition, a source, or has no unlisted name pointing at it;
- a defect names a finding that is not in the list or does not say what is wrong.

When everything is in order it writes four files:

1. The full records with reasons, in `data/`.
2. The gap list, in `data/`: each gap with its name, body area, definition, sources and the reports it came from, plus the defects of existing entries. It is addressed to the "corpus lane", the working area of the project whose session builds the lists of findings; that session decides whether each gap becomes an entry.
3. The checked set, in `data/`: the agreed labels without the rejected ones.
4. The manifest `docs/real-reports-factcheck-batch1.json`, committed to git. It holds the counts, each verdict by report number and finding identifier, the sources, the gaps and checksums of the other files (a checksum is a fingerprint that changes when the file changes). It holds no report text, no reason and no unlisted name: each unlisted name appears only as the first 16 characters of its SHA-256 (Secure Hash Algorithm 256) fingerprint. It marks the batch as a development batch and as not scored.

One decision is recorded in the decision log of the repository's `DESIGN.md` (2026-11-14): a disputed label that the literature accepts is recorded but stays out of the checked set. The project counts only labels that both annotators agree on; an accepted disputed label would rest on one annotator plus one checker. So the 10 accepted disputed labels of batch 1 are in the records and not among the 45 rows.

Three requirements describe the join, AN-76 to AN-78. Six tests in `tests/test_real_reports.py` check them on small invented examples: the counts add up; a missing, surplus or unsourced decision is refused; an unlisted name must be a synonym, a sourced gap or not a finding; the gap file names each gap with its source and reports; the manifest contains none of the words of the example; the checked set drops a rejected agreed label and keeps an accepted disputed one out.

The second check is run in three commands: `python3 -I analysis/second_check.py run --method xray --engine codex` (asks the second model, 25 labels per call, and can be resumed), `compare` (counts; `--show` lists the disagreements on screen only) and `record` (writes the counts into the decisions, after which the join is run again). The development batch has its own commands in `analysis/dev_batch.py`: `collect`, `annotate`, `label`, `withdraw`, `second`, `compare`, `record` and `factcheck --method METHOD`. Its texts and reasons stay in `data/`; its manifests in `docs/` hold verdicts by report and finding identifier, gaps, defects and sources, and no report text. `tests/test_second_check.py` holds three tests and `tests/test_dev_batch.py` six, on small invented examples. The full-text rule (AN-123) is checked by one test in `tests/test_real_reports_batch2.py`: the manifest counts the decisions by what was read, and an abstract never supports a decision.

## Steps
1. The two annotators label the batch; the command `label` of the same program keeps the pairs both state. Output: the labelled file in `data/` (described on [[radiology-analysis]]).
2. The judge (a Claude session that works only on held-out data and never changes the assistant in the same session) reads open literature for each agreed label, each disputed label and each unlisted name. Output: the decision file in `data/`.
3. The judge runs `factcheck`. Output: either a list of problems and no files, or the records, the gap list, the checked set and the manifest.
4. Since 2026-11-15: a second checker judges the same labels blind (`second_check.py run`, or `dev_batch.py second` for the development batch); the judge resolves every disagreement against the sources, runs `record` and repeats step 3. Output: the agreement counts in the manifest. Batch 1 was checked before this step existed and had one checker.
5. Since 2026-11-15, not for batch 1: every decision names a source read in full text, or is graded `unverified`; the judge fetches the articles, by hand or with [[radiology-fulltext-resolver]], and repeats step 3. Output: the counts per reading level in the manifest.
6. The judge commits the manifest and records the milestone as done with the plan tool. Output for batch 1: commits `c953478` (code, tests, manifest) and `2160a8d` (plan) of 2026-11-14.
7. The corpus session reads the gap list and decides, with its own sources, which gaps and defects change the list of findings. Done for batch 1 on 2026-11-14 (commit `3575a75`): nine findings added, four duplicate entries merged into three; [[radiology-finding-inventory]] describes the change. Done for the development batch on 2026-11-15: 11 ultrasound, 14 CT and 8 MRI findings added ([[radiology-modality-corpus]]).

## Where it sits in the pipeline
After the labelling of real reports by `analysis/real_reports.py label` ([[radiology-analysis]]). The open development batch now has a repeatable score; the sealed batches have none. Scoring batch 1 is part of a later milestone ("X-ray: the one-time test"); the final test uses a new, untouched batch, which the plan says must be fact-checked by two checkers and the literature. That batch, "batch 2", is described on [[radiology-final-test-batch]]; since 2026-11-15 it is fact-checked by two checkers for all four imaging methods and re-checked against full texts, and it has not been scored. Batch 1 itself will be scored once, by the one-time test of the X-ray milestone, which has not been run ([[radiology-one-time-test]]).

Since commit `7bbdaaa` of 2026-11-14 the command takes the batch and, for batch 2, the imaging method: `factcheck --real-batch 2 --method xray` (requirement AN-92). For batch 2 the committed manifest is sealed, meaning it holds only counts and checksums and no verdict, so that nothing about the held-out reports can be read from the repository (Giovanni's rule of 2026-11-14 that the final test never feeds the algorithm, requirement AN-104). Four such manifests exist since 2026-11-15, one per imaging method.

## Who receives its output
The session that builds the lists of findings receives the gap lists: of batch 1 for the X-ray list ([[radiology-finding-inventory]]), of the development batch for the ultrasound, CT and MRI lists ([[radiology-modality-corpus]]). The one-time test of the X-ray milestone receives the checked set of batch 1 ([[radiology-one-time-test]]). The later scoring step receives the checked set. Giovanni and any reader of the repository receive the manifest; the plan in [[radiology-report-matcher]] shows the milestone as done.

## Notes
The contents of the reports and of the files in `data/` were not opened for this page; everything here comes from the code, its tests, the committed manifests, the requirement rows, the decision log and the plan.

Update 2026-11-15 (change of scope; commits `976c81a` and `ad929e1`): Giovanni decided that the finding lists hold only what is seen on the image, so entries that name a diagnosis are to be replaced by their visible signs. Some labels of the batches described here point to such entries. They are not rewritten by hand and not mapped through the old name: two annotators read the wording again, blind, with the corrected list, and only a sign both agree on replaces a label (`analysis/relabel.py`, requirements AN-161 to AN-165; the rule is on [[radiology-one-time-test]]). This covers batch 1, the open development batch and the sealed batch 2. Until it is done the scoring of batch 1 and of batch 2 refuses. At commit `780123d` nothing was relabelled and no count is committed. The fact-check verdicts on this page were made on the earlier lists and are unchanged.

Update 2026-11-16 (commits `d9a3760` and `ee7d438`; record `docs/held-out-relabel.json`, counts only): the X-ray labels were relabelled blind by two models, Sonnet and Opus. In batch 1, 8 labels pointed to a retired diagnosis-like entry; the two agreed on all 8: 2 were relabelled as a visible sign and 6 were set aside because the wording only names the diagnosis. In the sealed batch 2 the counts are 15 pending, 12 agreed, 1 relabelled and 14 set aside ([[radiology-final-test-batch]]). A first pair, Sonnet and Haiku, agreed on 3 of the 8 labels of batch 1; its counts are kept beside in the record. Nothing was scored. The development batch of ultrasound, CT and MRI is not relabelled, because those lists still hold their diagnosis-like entries. The fact-check verdicts on this page are unchanged.
