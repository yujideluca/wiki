---
id: radiology-analysis
title: Radiology analysis package (analysis/)
aliases: [analysis package, report matcher analysis, analysis/]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis
fed_by: [radiopaedia-crawler]
feeds: []
sources: [radiology-crawler:analysis/__init__.py, radiology-crawler:analysis/corpus.py, radiology-crawler:analysis/hardware.py, radiology-crawler:analysis/harness.py, radiology-crawler:analysis/tagger.py, radiology-crawler:analysis/filters.py, radiology-crawler:analysis/wording.py, radiology-crawler:analysis/pipeline.py, radiology-crawler:analysis/v1_model.py, radiology-crawler:analysis/codex_tags.py, radiology-crawler:analysis/haiku_batches.py, radiology-crawler:analysis/tag_agreement.py, radiology-crawler:analysis/filler_test.py, radiology-crawler:analysis/sanity.py, radiology-crawler:tools/analysis_status.py, radiology-crawler:docs/analysis-status.json, radiology-crawler:AGENTS.md]
reviewed: 2026-11-01T18:11Z
---

## What it is
The Python code that studies the Radiopaedia articles and cases collected by [[radiopaedia-crawler]] and tries to map the words of a radiology report to likely diagnoses. It is the statistical part of [[radiology-report-matcher]]: it counts words and does arithmetic on them, and it is not an artificial-intelligence model. The plan is to build four competing versions of the mapping and score them all the same way; this package holds the shared tools and versions 1 and 4. The folder is `analysis/` in `~/dev/radiology-crawler`, with one helper outside it, `tools/analysis_status.py`.

## What it does
It provides the pieces below, each in its own file. Each piece has a requirement (rows AN-1 to AN-17 in `docs/REQUIREMENTS.md`) and a test tagged with it.

- A frozen copy of the articles, so every version reads the same data while the crawler keeps writing.
- A hardware layer that uses every processor thread and a graphics card (GPU, graphics processing unit) when there is one. The same code gives the same ranking on the processor alone.
- A scoring harness: for each diagnosis, half of its cases tune a model and half test it (a fixed random seed, so all versions see the same halves), and a ranking is scored by how often the true diagnosis is in the top 1, 5 and 10.
- Version 4, Giovanni's idea, in layers: a rule tagger that gives every article the same set of tags (patient group, sex, imaging method, body region, texture, brightness, margins, contrast uptake, side or number, symptoms); filters that remove a diagnosis only when the article states a fact that contradicts the report, or only lower its score for the softer layers; a chooser of the next question to ask the user ("akinator" style, like the guessing game: ask what removes the most candidates); and a last layer that scores the wording of the report.
- Version 1, Claude's own model without prior bias: a smoothed word-probability model of each article, with the number of articles linking to a diagnosis as its starting weight.
- Tagging by [[codex]] and by Haiku (a small Claude model) with the same closed list of allowed values, and a comparison of the taggers.
- A scientific test of the list of filler words (words a radiologist uses when unsure, which carry little information), written down in `docs/filler-list-protocol.md` before any result.
- `tools/analysis_status.py`, the one place that records where the analysis stands.

## How it does it
- **Unknown is not no.** A tag layer the article never mentions is stored as unknown, which differs from a stated "no". Only a stated, contradicting fact removes a diagnosis; missing information never does. Instead the question chooser asks.
- **Wording layer.** Each diagnosis article becomes a weighted bag of words and word pairs using BM25 (a standard formula that gives more weight to rare, informative words); sections about imaging count fully and the rest of the article a little. In a report, words inside a negation get a negative sign, words after a hedge ("possibly") are softened, and filler words are dropped. The score is one sparse-matrix product (a table of numbers multiplied in bulk), run on the processor or the GPU, and the result lists the words that moved each score.
- **Tagging by models.** `analysis/codex_tags.py` sends one article per call in a new, throw-away [[codex]] session far below 250,000 tokens (Giovanni's limit), with the article marked as untrusted text. An answer outside the allowed values is rejected, not silently fixed. Results are appended one line per article, so a stop loses nothing and a restart tags only what is missing. `analysis/haiku_batches.py` cuts batches of 100 articles from the other end of the same queue for Haiku subagents and merges only valid answers.
- **Status record.** The state of the work is the file `docs/analysis-status.json`; `tools/analysis_status.py set STEP STATUS --note "..."` changes it, rewrites the readable copy `docs/ANALYSIS-STATUS.md` and rebuilds the plan site, so the three never disagree. Anyone continuing the work reads it first. `AGENTS.md` in the repository gives [[codex]] the same working notes that `CLAUDE.md` gives [[claude-code]].
- **Data stays local.** The snapshot, tags and results live in `data/analysis/`, which git ignores, like the rest of `data/`.

## Functions
- `corpus.make_snapshot`, `corpus.load_snapshot`: write the frozen article file with a count and checksum; read it back and refuse a file whose checksum changed.
- `hardware.detect`, `hardware.array_module`, `hardware.parallel_map`: find threads and GPU; return CuPy (GPU arrays) or NumPy (processor arrays); run a function over items on all threads.
- `harness.split_by_diagnosis`, `harness.topk_hit_rates`, `harness.diagnosis_label`, `harness.case_label`: split cases by diagnosis; score a ranking at top 1, 5 and 10; find the article a case belongs to by exact title or synonym (a name shared by two articles gives no label instead of a guess).
- `tagger.tag_article`, `tagger.tag_all`, `tagger.article_type`, `tagger.coverage`: tag articles from word lists kept as data in `analysis/wordlists/`; give the article's type; report how often each layer is unknown.
- `filters.build`, `filters.FilterModel.apply`, `filters.best_question`: build the filter model; apply the layers to a report's stated facts; choose the next question.
- `wording.build_index`, `wording.read_report`, `wording.score`: index the diagnosis articles; read a report with negation, hedging and filler; rank the diagnoses.
- `pipeline.Engine`: version 4 end to end, from report text to a ranking and the next question.
- `v1_model.build`, `v1_model.rank`: version 1.
- `codex_tags.run_all`, `codex_tags.parse_answer`, `codex_tags.compare`: tag every missing article with Codex; validate an answer; compare two taggers.
- `haiku_batches.make`, `haiku_batches.merge`: cut batches for Haiku; merge valid answers.
- `tag_agreement.agreement`: how often the taggers agree with each other.
- `filler_test.run`, `filler_test.classify`, `filler_test.holm`: run the filler-word test; label a word filler, informative or undecided; correct for many tests at once (Holm's method).
- `sanity.main`: a machinery check on the cases downloaded so far; it is not the real evaluation.

## Where it sits in the pipeline
After [[radiopaedia-crawler]], which supplies the articles and cases in the database. It runs next to [[report-translator]] and does not read its output. It is the base for the planned numerical engine of [[radiology-report-matcher]].

## Who receives its output
Giovanni, through the step-by-step guide on the home page of the plan site and through `docs/ANALYSIS-STATUS.md`; later the planned matching engine.
