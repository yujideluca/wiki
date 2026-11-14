---
id: radiology-modality-corpus
title: Training corpus of ultrasound, CT and MRI (analysis/modality_corpus.py)
aliases: [modality corpus, analysis/modality_corpus.py, analysis/modality_inventory.py, tools/modality_corpus_run.sh, corpus lane]
kind: module
project: radiology-report-matcher
status: active
location: radiology-crawler:analysis/modality_corpus.py
fed_by: [radiology-finding-inventory]
feeds: [radiology-finding-engine]
sources: [radiology-crawler:analysis/modality_corpus.py, radiology-crawler:analysis/modality_inventory.py, radiology-crawler:tools/modality_corpus_run.sh, radiology-crawler:tests/test_modality_corpus.py, radiology-crawler:docs/training-corpus-manifest-ultrasound.json, radiology-crawler:docs/training-corpus-manifest-ct.json, radiology-crawler:docs/training-corpus-manifest-mri.json, radiology-crawler:docs/inventory-crosscheck-mri.json, radiology-crawler:docs/results-registry.json, radiology-crawler:docs/inventory-crosscheck-ultrasound.json, radiology-crawler:docs/inventory-crosscheck-ct.json, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:DESIGN.md, radiology-crawler:PLAN.md, radiology-crawler:assistant/lexicon/ct-synonyms-en.json, radiology-crawler:assistant/lexicon/mri-synonyms-en.json, radiology-crawler:assistant/lexicon/ultrasound-synonyms-en.json, radiology-crawler:assistant/modules/ct/abdomen.json, radiology-crawler:assistant/modules/ct/brain.json, radiology-crawler:assistant/modules/ct/breast.json, radiology-crawler:assistant/modules/ct/chest.json, radiology-crawler:assistant/modules/ct/general.json, radiology-crawler:assistant/modules/ct/head-neck.json, radiology-crawler:assistant/modules/ct/heart-vessels.json, radiology-crawler:assistant/modules/ct/msk.json, radiology-crawler:assistant/modules/ct/obstetric.json, radiology-crawler:assistant/modules/ct/spine.json, radiology-crawler:assistant/modules/ct/urogenital.json, radiology-crawler:assistant/modules/mri/abdomen.json, radiology-crawler:assistant/modules/mri/brain.json, radiology-crawler:assistant/modules/mri/breast.json, radiology-crawler:assistant/modules/mri/chest.json, radiology-crawler:assistant/modules/mri/general.json, radiology-crawler:assistant/modules/mri/head-neck.json, radiology-crawler:assistant/modules/mri/heart-vessels.json, radiology-crawler:assistant/modules/mri/msk.json, radiology-crawler:assistant/modules/mri/obstetric.json, radiology-crawler:assistant/modules/mri/spine.json, radiology-crawler:assistant/modules/mri/urogenital.json, radiology-crawler:assistant/modules/ultrasound/abdomen.json, radiology-crawler:assistant/modules/ultrasound/brain.json, radiology-crawler:assistant/modules/ultrasound/breast.json, radiology-crawler:assistant/modules/ultrasound/chest.json, radiology-crawler:assistant/modules/ultrasound/general.json, radiology-crawler:assistant/modules/ultrasound/head-neck.json, radiology-crawler:assistant/modules/ultrasound/heart-vessels.json, radiology-crawler:assistant/modules/ultrasound/msk.json, radiology-crawler:assistant/modules/ultrasound/obstetric.json, radiology-crawler:assistant/modules/ultrasound/spine.json, radiology-crawler:assistant/modules/ultrasound/urogenital.json]
reviewed: 2026-11-14T17:41Z
memory: []
---

## What it is
The program that builds the training data of the finding assistant ([[radiology-report-matcher]]) for three imaging methods: ultrasound, computed tomography (CT) and magnetic resonance imaging (MRI). A "finding" is one named observation on an image, such as a pleural effusion. A "training corpus" is a file of short texts, each labelled with the finding it describes; the learned matcher of [[radiology-finding-engine]] reads such a file to learn which words go with which finding. The X-ray corpus is built by an older program, `analysis/training_corpus.py`; this one does the same job for the other methods.

## What it does
For each method it produces three things: a list of findings (the inventory, in the format of [[radiology-finding-inventory]]), a corpus file of labelled texts, and a manifest. The manifest is a small committed file with counts, sources, licences and checksums (a checksum is a fingerprint that changes when the file changes) but no text; the corpus text itself stays in the `data/` folder, which is not in git.

Two rules shape it, both decided by Giovanni on 2026-11-14 and recorded in the decision log of `DESIGN.md` and in requirement AN-70 (a requirement is a numbered promise in `docs/REQUIREMENTS.md` that a test must check):

- The corpus must cross several public sources and never be a copy of one. The texts come from three: the "tuning half" of the Radiopaedia teaching cases (the cases are split in two halves; only the tuning half may train anything, the other half is kept for the one-time test), imaging sentences of case reports in PubMed Central (PMC, a free archive of journal articles) whose own file states the licence CC BY or CC0 (licences that allow copying and adapting), and sentences of the open-access IDKD books (a Springer series of radiology course books under CC BY 4.0). The build refuses a corpus in which one source holds more than 60 % of the rows.
- It must use few model tokens (a token is the unit in which a language model's use is counted). So the finding lists are made from data that was already paid for, and model calls are batched.

Results on 2026-11-14 (tuning half only, not a test score):

- Ultrasound: 2,732 rows (1,395 quotes and 1,337 rewrites) for 338 of the 750 findings of its list; Radiopaedia 54 %, PubMed Central 38 %, IDKD books 8 %.
- CT: 2,668 rows (1,376 quotes and 1,292 rewrites) for 493 of 1,180 findings; Radiopaedia 60 % after 135 rows were dropped to respect the limit, PubMed Central 32 %, IDKD books 8 %.
- MRI: 3,419 rows (1,790 quotes and 1,629 rewrites) for 502 of 1,107 findings; Radiopaedia 60 % after 834 rows were dropped to respect the limit, PubMed Central 34 %, IDKD books 6 %.
- Hit rate "right finding among three proposals", measured by five-fold cross-validation (the corpus is cut in five parts by diagnosis; four train, one is scored, in turn), with a simulated user for the rewrites. Engine alone, then engine plus learned matcher: ultrasound 71.5 % and 77.3 % on quotes, 19.8 % and 67.9 % on rewrites; CT 77.9 % and 72.7 % on quotes, 25.6 % and 56.2 % on rewrites; MRI 70.8 % and 74.9 % on quotes, 24.6 % and 60.7 % on rewrites. All are below the project targets (97 % on proper descriptions, 90 % on rewrites after questions), and in CT the matcher lowers the quotes: its weight is the X-ray value and is not tuned per method. The numbers are entry H10 of `docs/results-registry.json`.

## How it does it
The steps run in order; each can be run again and continues where it stopped (for example after the account's usage limit). `tools/modality_corpus_run.sh` runs steps 4 to 9 for each method.

1. `candidates` (no model): the finding tags of the articles are grouped. A finding tag is a set of equivalent wordings of one finding that an earlier step extracted from an article and fact-checked against the literature (step T2 of [[radiology-analysis]]). Wordings that share a tag form a cluster. A cluster is kept when 2 articles state it for the method, or 3 when its tags name no method.
2. `inventory` (model): a model turns the clusters, 100 per call, into findings with a name, a body area, a group and a one-line definition, and a second call merges findings that are the same thing under two names. Each finding cites the literature link stored with its tags, or the tagged article when there is none. The definition is written by the model and marked as such. These lists have no descriptor schemas (the attributes of a finding, such as side or margin) yet.
3. `pmc` (no model): searches Europe PMC for English open-access case reports, reads each article file, keeps it only when the file itself states CC BY or CC0, and keeps only sentences of case or imaging sections and figure captions that mention the method and a finding word and carry no personal context (age, sex, admission). Articles of the internet reports kept for the final test are excluded.
4. `sample` (no model): picks the texts, 45 % Radiopaedia cases, 35 % PMC passages, 20 % book sentences, and guesses the body area of each text with the word-matching engine.
5. `annotate` (model): two annotators (the models Sonnet and Haiku) each read every text, ten texts per call, with only the finding lists of the text's body areas plus the general list. Each names the findings the text states and quotes the words. A quote that is not in the text is discarded.
6. A row exists only when both annotators state the same finding for the same text on the same list; its text is their quotes.
7. `rewrite` (model): each agreed quote is rewritten the way a hurried non-expert would type it, and a second model checks that the rewrite still shows the finding; failed ones are dropped.
8. `build`: writes the corpus and the manifest. It refuses rows that are not of the tuning half and articles of the held-out internet reports, and it drops whole texts of the largest source, in a fixed order, until that source holds at most 60 % of the rows (a corpus with a single source is refused).
9. `crosscheck` (no model) counts, for each finding, in how many independent source families its name or a synonym occurs: article tags, literature link, RadLex (the radiology vocabulary of the Radiological Society of North America), IDKD books, PMC reports. For ultrasound 707 of 750 findings occur in two or more, for CT 1,115 of 1,180, for MRI 1,039 of 1,107. `score` runs the cross-validation described above.

Haiku is the second annotator, not Codex (OpenAI's coding agent, used elsewhere in the project): a Codex call measured about 15,000 tokens before any text, a Haiku call about 3,000. The cost is that the two annotators are less independent than two models of different makers. Measured token use per method, from the manifests: ultrasound about 5.4 million, CT about 5.5 million, MRI about 6.9 million.

## Functions
- `modality_inventory.clusters(mod)`: clusters of equivalent wordings for a method from the finding tags.
- `modality_inventory.write_inventory(mod, entries, by_id)`: the area files `assistant/modules/<method>/<area>.json` and the synonym file `assistant/lexicon/<method>-synonyms-en.json`.
- `pmc_passage(xml, mod)`: the usable imaging sentences of one PMC article, or the reason it is refused.
- `held_out_pmcids()`: the PMC article numbers of the reports kept for the final test.
- `route(engine, text)`: the one or two body areas of a text.
- `agreed_pairs(mod, annotators)`: the (text, finding) pairs both annotators stated.
- `balance(rows)`: drops texts of the largest source until it holds at most 60 % of the rows.
- `load(mod)`: the corpus rows, after the checksum and tuning-half checks.

## Where it sits in the pipeline
After the article finding tags and beside the X-ray inventory ([[radiology-finding-inventory]]); before the engine work on these methods. In the project plan (`PLAN.md`) it is the "corpus" lane, milestone M1, closed on 2026-11-14.

## Who receives its output
The learned matcher of [[radiology-finding-engine]], which will train on these corpora, and Giovanni, who reads the manifests.
