---
id: radiology-v3
title: Report matcher version 3 (article-anchored case shrinkage)
aliases: [V3, version 3, C4]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/v3_model.py
fed_by: []
feeds: []
sources: [radiology-crawler:analysis/v3_model.py, radiology-crawler:analysis/v3_run.py, radiology-crawler:analysis/v3_outer.py, radiology-crawler:tests/test_v3_model.py, radiology-crawler:tests/test_v3_outer.py, radiology-crawler:docs/v3-design.md, radiology-crawler:docs/v3-debate-codex-critique.md, radiology-crawler:docs/problem-formulation.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/v3-report.md]
reviewed: 2026-11-08T01:23Z
---

## What it is
Version 3 is the third of the competing ways [[radiology-analysis]] ranks diagnosis articles for a typed radiology report, built in step C4 of the [[radiology-report-matcher]] plan ("the academic approach"). It counts words, like [[radiology-v2]], and does not call a language model. It has one model per language: English, German and Brazilian Portuguese. Its design came from a debate: Claude wrote a proposal, Codex (OpenAI's coding agent) criticised it in a read-only session, and the agreed changes were written down before any tuning run (`docs/v3-design.md`, critique in `docs/v3-debate-codex-critique.md`).

## What it does
For every article it estimates which words a report about that diagnosis tends to use. With no teaching case of that diagnosis, the estimate comes from the article and from the general word frequencies of reports (the "background"). As teaching cases of the diagnosis accumulate, their words take over. This is called shrinkage: a weak estimate is pulled toward a safer one in proportion to how little evidence it has. A report is then scored against every article (all 17,361, the same candidate list as version 2) by how much more typical its words are for that article than for reports in general. Two smaller terms are added: how often the diagnosis appears among the teaching cases (the "prior"), and how similar the report is to the single closest teaching case of that diagnosis, because one diagnosis can look different from case to case. The scores rank articles; they are not probabilities.

## How it does it
The word estimate for article d and word w is (case count of w + τ × article share of w + μ × background share of w) divided by (case word total + τ + μ). τ and μ are "pseudo-counts": how many words the article and the background are worth. Each teaching case adds at most 400 words, so one long case cannot dominate. The report's word counts are softened with log(1 + count) and divided by their total, so long and short reports are scored on the same scale. All of it runs as sparse-matrix products (tables that store only nonzero values) with NumPy and SciPy, or with CuPy on the graphics processing unit (GPU) when one is present; a test checks that both give the same ranking. Each word's share of a score can be listed exactly, and the listed shares plus the prior and closest-case amounts add up to the score.

Tuning uses only the tuning half of the cases, split the same way as version 2 (training about 50 %, selection 25 %, internal audit 25 %), so the two versions are measured on the same cases. The 54 settings tried were fixed before any run (τ 250/1000/4000, μ 500/2000, prior weight 0/0.02/0.05, closest-case weight 0/0.5/1). The setting with the best top-10 rate on selection is kept; the audit is scored once with it and never chooses. A top-10 rate is the share of reports whose recorded diagnosis is among the first ten articles. The outer script then scores the test half and the newer cases once each, after refitting on all tuning cases, and compares version 3 with version 2 case by case by replaying the saved version 2 on the same cases. It reports the difference with a 95 % interval from resampling diagnoses 2,000 times.

Requirements AN-37 (the model), AN-38 (exact explanation), AN-39 (tuning only on the tuning half) and AN-40 (outer scoring once, paired with version 2) are checked by tagged tests in `tests/test_v3_model.py` and `tests/test_v3_outer.py`. Results (2026-11-08, `docs/v3-report.md`): version 3 does not beat version 2. On the test half its top-10 rate is 79.3 % (English), 74.6 % (German) and 78.2 % (Portuguese), against 80.2 %, 75.0 % and 79.1 % for version 2; the paired difference is below zero with 95 % confidence in English and Portuguese. Its strength is diagnoses with no teaching case at all: among the newer cases (about 140 per language) it puts the right article in the first ten 24.3 %, 19.7 % and 16.2 % of the time, against 8.3 %, 7.7 % and 7.0 % for version 2. It is weaker than version 2 for diagnoses with two to four teaching cases in English and Portuguese. The prior got weight 0 in every language, and several chosen settings lie at the edge of the fixed grid. The report suggests combining the two versions in step S2.

## Functions
- `V3Model.fit_cases`: add tuning-case evidence; refuses cases that are not tuning cases, duplicate identifiers and labels outside the article list.
- `V3Model.kernel`, `log_prior`: build the sparse word table and per-article constant for one τ and μ, and the smoothed case-frequency prior.
- `V3Model.parts`, `scores`, `nearest`, `recognised`: score a batch of reports (refusing reports that are training cases), compute the closest-case term, count recognised words.
- `V3Model.explain`: list each word's share of one article's score, plus the prior and closest-case amounts.
- `v3_run.grid`, `measure`, `run`, `main`: the fixed 54 settings, top-1/5/10 per setting and by number of training cases, tuning or replay of one language with the ablations (variants with one part removed).
- `v3_outer.frozen_v3`, `ranks`, `paired_interval`, `score_language`, `main`: check the saved setting against the input checksums, rank with ties counted against the model, compute the paired difference and its interval, and refuse a second scoring of a half.

## Where it sits in the pipeline
It reads the frozen article snapshots and case files under ignored `data/analysis/`, the same inputs as version 2. Settings are saved to `data/analysis/v3-params-LANG.json`, outer results to `data/analysis/v3-outer-SPLIT-DATE.json`. Heavy runs take the shared lock `/tmp/radiology-heavy.lock`, one at a time.

## Who receives its output
Giovanni and step S1 (scoring all versions on the same test half) and S2 (comparing them and choosing a winner) of the [[radiology-report-matcher]] plan. Only aggregate hit rates are saved; no case text or case identifier is printed.
