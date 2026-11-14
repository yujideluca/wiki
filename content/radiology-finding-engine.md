---
id: radiology-finding-engine
title: Finding engine and its scorer (assistant/engine.py)
aliases: [finding engine, assistant/engine.py, assistant_eval, step R5]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:assistant/engine.py
fed_by: [radiology-finding-inventory]
feeds: [radiology-report-matcher]
sources: [radiology-crawler:assistant/engine.py, radiology-crawler:analysis/assistant_eval.py, radiology-crawler:tests/test_assistant_engine.py, radiology-crawler:docs/adr/0009-engine-retrieve-and-rerank.md, radiology-crawler:docs/REQUIREMENTS.md]
reviewed: 2026-11-14T03:35Z
---

## What it is
The first slice of the program at the heart of the finding assistant described on [[radiology-report-matcher]]: given a free-text description of an X-ray, it returns at most three candidate findings (a "finding" is one named observation on an image, such as a pneumothorax), best first, the first one marked as the most likely. It is built in English only for now: Giovanni decided on 2026-11-14 to perfect English first and to derive the German and Portuguese terms from the English ones if that works, so the German and Portuguese finding tags (step T2 of [[radiology-analysis]]) and the four translator services of [[report-translator]] are paused.

## What it does
It reads a description clause by clause, sets apart words that a negation ("no", "without", "absent") covers and words that are hedged ("possibly"), and scores every finding of [[radiology-finding-inventory]] against the stated words. The scoring uses only the inventory (each finding's name, group and descriptor names and values), never text from the cases or articles, so the cases can still judge it fairly. The scorer `analysis/assistant_eval.py` counts a (text, target finding) pair as a hit only when the target is exactly one of the three proposed, resamples a 95 % interval by case, and refuses to score the test half of the data: that half is scored once, in step R8.

Measured on the tuning half (1,453 agreed pairs from 718 cases): the right finding is among the three in 48 % of pairs (40 % before the free numbers were chosen) and is first in about 25 %. The target is 97 %. Two limits are known. A name match is most of the signal, and generic findings such as "opacity" and "atelectasis" are missed because texts use a more specific word. And because one case text states several findings (1.8 on average, up to 13) while only three are shown, this pair unit can reach at most 86 %; Giovanni still has to decide how to score it (per case, per sentence, or with the target marked).

## How it does it
Each finding becomes a small weighted profile of words and word pairs; a BM25-style (a standard text-search weighting) matrix product on NumPy scores all findings at once, so the order does not depend on the number of threads, and ties go to the smaller finding id. Free numbers (name weight 12, descriptor weight 1, definition weight 0 and others) live in the `Params` class and were chosen on the tuning half. The method choice is decision record (architecture decision record, ADR) 0009; requirements FA-1, FA-6 and AN-65 are tested by `tests/test_assistant_engine.py`.

## Functions
- `Engine.rank`: up to three strict candidates for a text, the first highlighted.
- `Engine.scores`, `Engine.read`: finding scores and the clause reading (stated, negated, hedged words).
- `Engine.with_params`: a copy with other free numbers, used to tune on the tuning half.
- `assistant_eval.score`, `summarize`, `interval`: strict top-3 and top-1 hits and their intervals; `proper_pairs`, `fabricated_pairs` load the frozen sets and refuse the test half.

## Where it sits in the pipeline
After the inventory and the frozen test sets (step R4) and before the sufficiency check and question chooser (steps R6, R7). Stage 2, a descriptor reader that re-scores the top candidates, is not built yet.

## Who receives its output
The later steps of the finding assistant, and Giovanni, who reads the scores.
