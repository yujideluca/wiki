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
sources: [radiology-crawler:analysis/v2_model.py, radiology-crawler:analysis/v2_run.py, radiology-crawler:tests/test_v2_model.py, radiology-crawler:tests/test_text_encoding.py, radiology-crawler:docs/v2-report.md]
reviewed: 2026-11-07T20:45Z
---

## What it is
Version 2 is an independent experiment in [[radiology-analysis]] that ranks article diagnoses against a typed radiology report. It has separate models for English, German and Brazilian Portuguese. It counts matching words rather than calling a language model. The [[radiology-report-matcher]] project compares it with other proposed approaches.

## What it does
It blends full-article word similarity with evidence from teaching reports used for training. It also tests a separate index that gives imaging sections extra weight. A model refuses to score a report whose identifier occurs in its training evidence. Empty reports receive zero scores.

## How it does it
NumPy and SciPy, libraries for bulk numerical calculations, store word counts in sparse matrices: tables that store only nonzero values. Four matrix products compare reports with full articles, selected sections, average training reports and individual training reports. Independent processor products run in a thread pool. CuPy runs the products on a graphics processing unit (GPU) when the shared hardware adapter finds one.

The tuning command divides only the approved tuning cases into training, parameter selection and an internal audit. The audit checks the chosen settings without choosing them. The validate command replays saved settings and rejects changed input checksums. Neither command evaluates the outer test half or newly downloaded cases; that belongs to analysis step S1.

On 2026-11-07 the real English GPU replay matched all six saved processor selection and audit rates exactly. German and Portuguese processor replays also matched their saved rates. Internal audit top-10 rates were 81.0732%, 75.4557% and 79.3340%, respectively. These are internal checks, not clinical validation or outer-test results. The synthetic GPU test compares all four score components and their mixture within a numerical tolerance.

## Functions
- `vocabulary`, `counts`: extract Unicode letter words and form document-by-word counts in bounded batches.
- `unit_rows`, `tfidf`, `bm25`: normalize and weight sparse word counts.
- `V2Model.fit_cases`, `components`, `score`: fit approved training evidence, calculate four similarities, and blend them into article scores.
- `v2_run.tuning_cases`, `partition`: reconcile frozen labels and case records, then separate training, selection and audit identifiers.
- `v2_run.measure`, `run`, `main`: measure bounded batches, tune or replay a language, and parse command arguments.
- `v2_run.read_rows`, `digest_ids`: read compressed records with explicit UTF-8 text encoding and checksum the partition identifiers.

## Where it sits in the pipeline
It reads frozen article and teaching-case files under ignored `data/analysis/`. Training, selection and audit identifiers stay disjoint. Numerical scoring uses compiled library operations. The runner names UTF-8, the text encoding that preserves accented letters, on every text read and write.

## Who receives its output
Giovanni and the coordinator of step S1 receive per-language settings and measured hit rates. A hit rate is the share of reports whose supplied diagnosis occurs among the first ranked articles. Saved settings and per-identifier reconciliation remain under ignored `data/`; case text is not printed or copied into documentation.
