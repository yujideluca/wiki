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
sources: [radiology-crawler:assistant/lexicon/RadLex_License_2.1.pdf, radiology-crawler:analysis/synonyms.py, radiology-crawler:assistant/lexicon/xray-synonyms-en.json, radiology-crawler:assistant/segment.py, radiology-crawler:assistant/engine.py, radiology-crawler:analysis/assistant_eval.py, radiology-crawler:tests/test_assistant_engine.py, radiology-crawler:docs/adr/0009-engine-retrieve-and-rerank.md, radiology-crawler:docs/REQUIREMENTS.md]
reviewed: 2026-11-14T04:53Z
---

## What it is
The first slice of the program at the heart of the finding assistant described on [[radiology-report-matcher]]: given a free-text description of an X-ray, it returns at most three candidate findings (a "finding" is one named observation on an image, such as a pneumothorax), best first, the first one marked as the most likely. It is built in English only for now: Giovanni decided on 2026-11-14 to perfect English first and to derive the German and Portuguese terms from the English ones if that works, so the German and Portuguese finding tags (step T2 of [[radiology-analysis]]) and the four translator services of [[report-translator]] are paused.

## What it does
It reads a description clause by clause, sets apart words that a negation ("no", "without", "absent") covers and words that are hedged ("possibly"), and scores every finding of [[radiology-finding-inventory]] against the stated words. The scoring uses only the inventory (each finding's name, group and descriptor names and values), never text from the cases or articles, so the cases can still judge it fairly. The scorer `analysis/assistant_eval.py` counts a (text, target finding) pair as a hit only when the target is exactly one of the three proposed, resamples a 95 % interval by case, and refuses to score the test half of the data: that half is scored once, in step R8.

The unit of analysis is one structure (Giovanni, 2026-11-14): a text that describes several structures is analysed one structure at a time, each getting its own three suggestions, and several mentions of the same thing count as one structure. For the proper test set a structure is what the annotators quoted for a finding. My first measurement used a whole case text against all its findings with only three slots, which capped the score at 86 % and was the wrong unit; it was replaced.

Measured on the tuning half per structure (1,453 pairs from 718 cases): the right finding is among the three in 74.5 % of pairs (95 % interval 72 to 77) and is first in 57.7 %. The target is 97 %. A first run reported 40 % because the scorer reused the first structure's answer for every structure of a case; that bug is fixed and has a test. When the engine misses, the right finding is within its top ten in 80 % of cases: the gap is vocabulary the inventory lacks ("pleural fluid" or "hydrothorax" for pleural effusion), so the next steps are a literature-sourced synonym list per finding and a descriptor reader that re-scores candidates.

Synonyms (`analysis/synonyms.py`, requirement FA-7, no model tokens): the engine can read an added-synonym list, `assistant/lexicon/xray-synonyms-en.json`, built by exact whole-name matching against RadLex 4.3 (the Radiological Society of North America's lexicon, used under its licence: added terms, names unchanged, not endorsed by that society), MeSH 2026 (the US National Library of Medicine's vocabulary) and the fact-checked finding tags of the articles (kept when at least two tag groups agree). The engine uses RadLex, the Consumer Health Vocabulary and the tags, not MeSH, which brought wrong senses. Giovanni accepted the RadLex licence on 2026-11-14 (an "I agree" box on the download page); a copy of the agreement ships in `assistant/lexicon/`. The Consumer Health Vocabulary (a public vocabulary of everyday wording mapped to UMLS concepts, from the University of Utah and partners) was added the same way and brings real lay wording ("fluid in the chest", "broken rib"): with RadLex and the finding tags the top-three rate is 77.0 % and the first-place rate 61.7 % on the tuning half. The alternative names listed in the `keywords` field of the Radiopaedia articles were tested too and gave no gain, so they are not used (their licence, CC BY-NC-SA, would also need a decision). Searches for an open list of informal radiology wording found none: MedlinePlus has only coarse lay names ("broken bone", "collapsed lung"), the Consumer Health Vocabulary needs a registration with a name, and the RadLex normalisation corpus of the Roberts laboratory is not released yet. The effect is small, from 74.5 % to 77 % in the top three on the tuning half, because neither vocabulary has the everyday wording ("pleural fluid", "hydrothorax"); the next lever is the descriptor reader, not more vocabulary.

The segmenter (`assistant/segment.py`, requirement FA-10) cuts a real description into structures using only the engine's scores: sentences are cut again where a list names different findings, a piece that starts with a back reference ("it", "this"), supports no finding or has the same best finding as the piece before joins it, and a piece scoring below a minimum is dropped. It is imprecise: it keeps 71 % of the true structures but proposes 4.7 per case where the annotators saw 2.0, because word matching cannot tell a finding from a mention of something unlisted. The fabricated and insufficiency test sets must still be rebuilt per structure.

## How it does it
Each finding becomes a small weighted profile of words and word pairs; a BM25-style (a standard text-search weighting) matrix product on NumPy scores all findings at once, so the order does not depend on the number of threads, and ties go to the smaller finding id. Free numbers (name weight 12, descriptor weight 1, definition weight 0 and others) live in the `Params` class and were chosen on the tuning half. The method choice is decision record (architecture decision record, ADR) 0009; requirements FA-1, FA-6 and AN-65 are tested by `tests/test_assistant_engine.py`.

## Functions
- `Engine.rank`: up to three strict candidates for a text, the first highlighted.
- `Engine.scores`, `Engine.read`: finding scores and the clause reading (stated, negated, hedged words).
- `segment.segment`, `segment.analyse`: cut a text into structures and rank each one on its own.
- `synonyms.build` (`python3 -I analysis/synonyms.py build`): rebuild the added-synonym list from RadLex, MeSH and the finding tags.
- `Engine.with_params`: a copy with other free numbers, used to tune on the tuning half.
- `assistant_eval.score`, `summarize`, `interval`: strict top-3 and top-1 hits and their intervals; `proper_pairs`, `fabricated_pairs` load the frozen sets and refuse the test half.

## Where it sits in the pipeline
After the inventory and the frozen test sets (step R4) and before the sufficiency check and question chooser (steps R6, R7). Stage 2, a descriptor reader that re-scores the top candidates, is not built yet.

## Who receives its output
The later steps of the finding assistant, and Giovanni, who reads the scores.
