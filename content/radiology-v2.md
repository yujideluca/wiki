---
id: radiology-v2
title: Independent report matcher version 2
aliases: [V2 retrieval, C3]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/v2_model.py
fed_by: []
feeds: []
sources: [radiology-crawler:analysis/v2_model.py, radiology-crawler:analysis/v2_run.py, radiology-crawler:tests/test_v2_model.py, radiology-crawler:tests/test_text_encoding.py, radiology-crawler:docs/v2-report.md, radiology-crawler:analysis/v2_outer.py, radiology-crawler:tests/test_v2_outer.py, radiology-crawler:docs/articles-only-report.md, radiology-crawler:docs/modelling-directives.md]
reviewed: 2026-11-08T01:54Z
---

## What it is
Version 2 is an independent experiment in [[radiology-analysis]] that ranks article diagnoses against a typed radiology report. It has separate models for English, German and Brazilian Portuguese. It counts matching words rather than calling a language model. The [[radiology-report-matcher]] project compares it with other proposed approaches.

## What it does
It blends full-article word similarity with evidence from teaching reports used for training. It also tests a separate index that gives imaging sections extra weight. A model refuses to score a report whose identifier occurs in its training evidence. Empty reports receive zero scores.

## How it does it
NumPy and SciPy, libraries for bulk numerical calculations, store word counts in sparse matrices: tables that store only nonzero values. Four matrix products compare reports with full articles, selected sections, average training reports and individual training reports. Independent processor products run in a thread pool. CuPy runs the products on a graphics processing unit (GPU) when the shared hardware adapter finds one.

The tuning command divides only the approved tuning cases into training, parameter selection and an internal audit. The audit checks the chosen settings without choosing them. The validate command replays saved settings and rejects changed input checksums. Neither command evaluates the outer test half or newly downloaded cases; that belongs to analysis step S1, done by a separate script, `analysis/v2_outer.py`.

Its requirements are AN-29 (per-language models, GPU agrees with CPU), AN-30 (training evidence only from allowed tuning cases) and AN-31 (the tuning command never scores the test or new halves), each checked by tagged tests in `tests/test_v2_model.py`. They were first named AN-V2-1..3, a shape the [[check-traceability]] check did not read; they were renamed on 2026-11-07 and the work was pushed.

On 2026-11-07 the real English GPU replay matched all six saved processor selection and audit rates exactly. German and Portuguese processor replays also matched their saved rates. Internal audit top-10 rates were 81.0732%, 75.4557% and 79.3340%, respectively. These are internal checks, not clinical validation or outer-test results. The synthetic GPU test compares all four score components and their mixture within a numerical tolerance.

On 2026-11-07 version 2 was scored once on the outer halves by `python3 -m analysis.v2_outer --split test|new` (requirement AN-36, tests in `tests/test_v2_outer.py`). The script retrains version 2 on all of the roughly 22,700 tuning cases with the saved settings and changes nothing else. It refuses to run if the input files changed since tuning, if a scored case is also a training case, or if that half already has a version 2 result. On the test half, the right diagnosis was among the first 10 articles in 80.2% of English, 75.0% of German and 79.1% of Portuguese reports (versions 1 and 4: 64.7%, 52.8%, 62.3% and 56.6%, 46.0%, 54.3%). On the newer cases it was 76.5%, 69.7% and 75.3%. Version 2 learns from earlier teaching cases of the same diagnosis; versions 1 and 4 read only the articles. Version 2 also scored the 742 test cases the others left out because their diagnosis was outside their own list of possible answers.

On 2026-11-08 Giovanni ruled that the models are built from the articles only: a case never enters a model, and the labelled cases of the tuning half (cases kept for choosing settings) only choose a few free numbers, while the test cases only score (`docs/modelling-directives.md`, principle 13 in the repository's CLAUDE.md). This version breaks it, because it learns from the tuning-case texts, so its results above are superseded. Its articles-only rebuild, V2a, keeps only its article parts; it is described on [[radiology-analysis]]. Under that rule, among versions 1 to 3 rebuilt from articles only, the order on the test half is V1a, then V3a, then V2a in every language (top-10, the share of cases whose true diagnosis is among the ten best: English 61.7 %, 56.0 %, 53.3 %; German 49.0 %, 44.2 %, 39.6 %; Portuguese 58.6 %, 53.0 %, 50.3 %), with version 4 at 56.6 %, 46.0 % and 54.3 %, unpaired (`docs/articles-only-report.md`).

## Functions
- `vocabulary`, `counts`: extract Unicode letter words and form document-by-word counts in bounded batches.
- `unit_rows`, `tfidf`, `bm25`: normalize and weight sparse word counts.
- `V2Model.fit_cases`, `components`, `score`: fit approved training evidence, calculate four similarities, and blend them into article scores.
- `v2_run.tuning_cases`, `partition`: reconcile frozen labels and case records, then separate training, selection and audit identifiers.
- `v2_run.measure`, `run`, `main`: measure bounded batches, tune or replay a language, and parse command arguments.
- `v2_outer.outer_cases`, `frozen_params`, `evaluate`, `score_language`, `main`: read one outer half and count what is left out, check the saved settings against the input checksums, score in batches, and refuse a second scoring.
- `v2_run.read_rows`, `digest_ids`: read compressed records with explicit UTF-8 text encoding and checksum the partition identifiers.

## Where it sits in the pipeline
It reads frozen article and teaching-case files under ignored `data/analysis/`. Training, selection and audit identifiers stay disjoint. Numerical scoring uses compiled library operations. The runner names UTF-8, the text encoding that preserves accented letters, on every text read and write.

## Who receives its output
Giovanni and the coordinator of step S1 receive per-language settings and measured hit rates. A hit rate is the share of reports whose supplied diagnosis occurs among the first ranked articles. Saved settings and per-identifier reconciliation remain under ignored `data/`; case text is not printed or copied into documentation.
