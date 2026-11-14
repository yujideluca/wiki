---
id: radiology-report-matcher
title: Radiology finding assistant (project)
aliases: [report matcher, radiology matcher, finding assistant]
kind: project
project: none
status: active
location: radiology-crawler:
fed_by: [radiology-r1-xray-review, radiology-finding-inventory, radiology-finding-engine]
feeds: []
sources: [radiology-crawler:PLAN.md, radiology-crawler:docs/plan.json, radiology-crawler:docs/SCOPE.md, radiology-crawler:CLAUDE.md, radiology-crawler:tools/plan.py, radiology-crawler:legacy/README.md, radiology-crawler:docs/results-registry.json, radiology-crawler:site_src/results.py, radiology-crawler:docs/r4-test-sets-design.md, radiology-crawler:docs/r3-handoff.md, radiology-crawler:legacy/docs/assistant-problem-statement.md, radiology-crawler:docs/adr/0007-finding-assistant-replaces-diagnosis-ranker.md, radiology-crawler:legacy/docs/finding-assistant-requirements-draft.md, radiology-crawler:legacy/docs/v3-design.md, radiology-crawler:legacy/docs/v3-report.md, radiology-crawler:legacy/docs/problem-formulation.md, radiology-crawler:legacy/docs/v3-research-codex-ir.md, radiology-crawler:legacy/docs/v3-research-codex-clinical.md, radiology-crawler:DESIGN.md, radiology-crawler:CLAUDE.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/adr/0002-technology-and-languages.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:tools/check_dependencies.py, radiology-crawler:requirements.txt, radiology-crawler:requirements-optional.txt, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:site_src/build.py, radiology-crawler:run_all.sh, radiology-crawler:legacy/docs/modelling-directives.md, radiology-crawler:docs/plan.json, radiology-crawler:AGENTS.md, radiology-crawler:analysis/__init__.py, radiology-crawler:legacy/docs/articles-only-report.md, radiology-crawler:docs/finding-tags-pilot.md, radiology-crawler:legacy/docs/s1c-briefs.md, radiology-crawler:analysis/jobs.py, radiology-crawler:progress.py, radiology-crawler:site_src/build.py, radiology-crawler:docs/finding-tags-audit.md, radiology-crawler:legacy/docs/s1c-v3t-design.md, radiology-crawler:docs/adr/0004-v2t-article-and-finding-retrieval.md, radiology-crawler:docs/adr/0005-v4t-wording-channels.md, radiology-crawler:docs/adr/0006-v3t-frozen-retrieval.md]
reviewed: 2026-11-14T13:39Z
---

## What it is
A project to build a finding assistant for radiologists. A "finding" is one named observation on an image, for example a pleural effusion. The user types a loose description of one structure seen on an imaging exam. The assistant proposes three exact findings in correct radiological terms and highlights the most likely one; it says whether the description is sufficient, insufficient or fits no known finding; and when it is insufficient it asks up to three questions, each with standard answers to choose from. It names findings. It does not diagnose and it stores nothing that was typed. The full definition is one page in the repository, `docs/SCOPE.md`.

The targets, set by Giovanni: the right finding is exactly one of the three in 97 % of proper (technical, complete) descriptions and in 90 % of hurried descriptions after a simulated user answered the questions. The work is in English first and covers four imaging methods: X-ray, ultrasound, CT (computed tomography) and MRI (magnetic resonance imaging). The deadline in the plan is 2027-02-10.

Until 2026-11-09 the project aimed at something else: ranking diagnoses from a typed report (model versions 1 to 4). That code is kept in the folder `legacy/` of the repository and is no longer run ([[radiology-v2]], [[radiology-v3]]).

On 2026-11-14 the project was reorganised after a review found three causes of confusion: two thirds of the repository still belonged to the old ranker, closing one step meant updating about nine records, and several Claude sessions changed the same files. Since then there is one plan file, `PLAN.md`, written by `tools/plan.py` from `docs/plan.json`. It holds the goal, four lanes and nine milestones. A lane is an area of work that one session owns, with its own list of files: **corpus** (training data for each imaging method), **engine** (the assistant itself, measured only on the tuning half of the cases), **judge** (the held-out test half and real reports, each scored once) and **product** (the website and the plan site). A milestone has a name in plain words and one check that closes it. The tool refuses a milestone name above 70 characters and an exit check or note above 220, which keeps the plan to about one screen.

Built so far: the crawler ([[radiopaedia-crawler]]), the translator ([[report-translator]], paused), the X-ray finding list ([[radiology-finding-inventory]], from the literature review [[radiology-r1-xray-review]]), the engine with its sufficiency verdict and questions ([[radiology-finding-engine]]) and the data and scoring code ([[radiology-analysis]]). The website is planned. The plan is also shown on an offline website in `~/Documents/Radiology Report Matcher/`, rebuilt by `site_src/build.py`.

## Flow
trigger t1: Giovanni names a lane and a milestone to a session | [[claude-code]]
step s1: Read PLAN.md, docs/SCOPE.md and CLAUDE.md
step s2: Corpus lane builds the training data of an imaging method
step s3: Engine lane improves the assistant on the tuning half of the cases | [[radiology-finding-engine]]
decide d1: Does the tuning half reach the targets?
step s4: Judge lane scores the held-out test half once
step s5: Judge lane scores fresh real reports once
step s6: Keep improving on the tuning half; the targets are checked again in a later session
product p1: The assistant on a website: three findings, verdict, questions (planned)
product p2: PLAN.md and the offline plan website

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> d1
d1 -no-> s6
s6 -> p2
d1 -yes-> s4
s4 -> s5
s5 -> p1
t1 -> p2

## Architecture
### Context
person g: Giovanni — asks for each step and reads the plan | [[giovanni]]
system s: Radiology Report Matcher — collects, translates and (later) matches reports
external r: Radiopaedia — the free reference site the pages come from
external c: Codex — writes the German and Portuguese versions | [[codex]]
external b: Reference textbooks — German and Portuguese wording guides

g -asks for steps and reads the plan from-> s
s -downloads pages from-> r
s -asks for translations from-> c
s -takes wording from-> b

### Containers
person g: Giovanni | [[giovanni]]
container cr: Crawler — downloads and extracts pages | [[radiopaedia-crawler]]
container tr: Translator — German and Portuguese versions | [[report-translator]]
container ps: Plan site builder — rebuilds the offline plan website
store raw: Raw pages — compressed copies of every downloaded page
store db: SQLite database — urls, articles, cases, translations
store ix: Book passage index — textbook passages by 4-letter pieces
external r: Radiopaedia
external c: Codex | [[codex]]

g -starts-> cr
g -reads the plan from-> ps
cr -downloads from-> r
cr -keeps copies in-> raw
cr -writes rows to-> db
tr -reads articles and saves translations in-> db
tr -finds textbook passages in-> ix
tr -asks for translations from-> c
ps -reads live counts from-> db

## Engineering practices
How this project follows the golden path of [[project-template]].

### Principles
The rules for every session are the file `CLAUDE.md` of the repository (51 lines since 2026-11-14). In short:
1. **One lane per session**: a session changes only the files of its lane, stages files by path and commits as soon as its tests pass, because the gate tests every file in the folder, also another session's uncommitted one.
2. **One milestone at a time**, closed only by its check, then recorded with `python3 -I tools/plan.py set M3 done --note "..."`.
3. **Few records per change**: a one-line requirement row, a test tagged `REQ <ID>` (a comment that names the requirement the test checks), the code; a scored test adds one entry to `docs/results-registry.json`; a real decision adds one row to the decision log in `DESIGN.md`. This wiki is updated when a milestone closes.
4. **Data rules**: the tuning half of the cases trains and tunes; the test half and the real reports are scored once and nothing is tuned on them afterwards; training texts cross several public sources; case text and trained weights never enter git.
5. **Technical rules**: Python with NumPy for the matching math, Elixir and Elm for the planned website; every third-party package is declared in `requirements.txt`; long jobs show live progress on the plan site.

### Decisions
Nine architecture decision records (ADRs, short notes that keep the reasons for one structural decision) in `docs/adr/`, 0001 to 0009. The ones in force for the assistant: the stack (0002), the maintenance program (0003), the finding assistant replaces the diagnosis ranker (0007), the format of the finding list and the layout of one module per imaging method (0008), and the engine design (0009). Records 0004 to 0006 belong to the old ranker. The four decisions of the reorganisation of 2026-11-14 are rows in the decision log of `DESIGN.md`.

### Requirements
Fifty-eight requirements in `docs/REQUIREMENTS.md` (2026-11-14), each one line: 25 for analysis and data (prefix AN), 7 for the finding assistant (FA), 7 for the crawler (CW), 9 for the translator (TL), 4 for the translation check (TC), 5 for the plan site (WS) and 1 for dependencies (DP). The 44 rows of the old ranker are in `legacy/REQUIREMENTS.md` and are not checked.

### Quality gate
The gate is the one script that decides whether the code passes. `tools/quality_gate.sh` has four steps: (0) `tools/check_dependencies.py` fails when the code imports a third-party package that is not declared; (1) compile the code and run the tests in `tests/` (175 in the committed code on 2026-11-14; the tests in `legacy/tests/` are not run); (2) requirement traceability: every requirement has a test and every tag names a requirement; (3) the fitness functions of `pipeline-check` (limits such as the largest file), see [[checks-radiology-crawler]].

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub; a local pre-push check runs it before `main` is pushed. On 2026-10-27 the first run failed because a fresh copy of the repository has no `data/` folder and the crawler's log function assumed one; the fix passed. On 2026-11-01 run 41335076862 failed because the analysis code imported NumPy while `requirements.txt` did not list it: the laptop passed because the gate added its own library folder (`~/.local/share/claude-workflow/pylibs`) to the search path. The gate now adds that folder only when the `CI` variable is not `true`, and step 0 above prevents the gap. A run on a clean Python 3.12 environment with only `requirements.txt` installed passed.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` with priorities P1 to P3 under the [[maintenance-policy]]; the labels exist. A monthly review is planned.

## What it does
Today it collects text, builds training data and finding lists, and runs the engine on test sets. Results so far are on the tuning half only (X-ray, 2026-11-14): the right finding is among the three for 89.1 % of proper descriptions and for 90.1 % of hurried descriptions after the questions, with a simulated user. The held-out test half has not been scored. The planned website will let a radiologist use the assistant in a browser.

## How it does it
Source of the content: Radiopaedia, a free radiology reference site. Its pages are in English only; the sitemap lists no German or Portuguese versions. Its `robots.txt` file (the file where a site tells automated visitors what they may do) allows article and case pages with a delay of 10 seconds between requests, and states a reservation against use for training AI models. The pages are licensed CC BY-NC-SA (Creative Commons, non-commercial, share-alike). Giovanni decided to proceed: the product will not display Radiopaedia text, it builds a statistical mapping and not an AI model, other sources will be added, and Giovanni will talk with Radiopaedia if they object. Whether this is enough for commercial use is a legal question that has not been answered.

The method was chosen from a research report written by [[codex]] on 2026-10-27: BM25 plus a term lexicon, negation rules and a fixed score table, with learned reranking and embeddings (numbers that represent the meaning of a text) only if a test shows they help. The report itself said that no published study proves any method meets this exact goal, so a test set of physician-written reports is required.

The code lives in the private repository `yujideluca/radiology-report-matcher` (folder `~/dev/radiology-crawler`, kept under that name because long jobs run from it). The plan site is also published openly, with no login, through Tailscale Funnel on port 8443 (the wiki keeps the main port behind its sign-in); a small static server, `radiology-plan-site.service`, serves the folder `~/Documents/Radiology Report Matcher/` from this laptop, so it is online while the laptop is on. Its home page shows live bars: downloads and translations (from the crawler database), and, under "Analysis jobs running now", one bar per long analysis job with items done, rate per hour, time left and state (running, paused for example by a usage limit, done, failed, or not updating after 10 minutes). Each job writes its counts through `analysis/jobs.py` (see [[radiology-analysis]]); the user service `radiology-plan-updater.service` rewrites the page's data file every 5 seconds. Languages decided by Giovanni on 2026-10-27: Python tools, Elixir back end, Elm front end, and the matching math in high-speed numerical Python (Cython, NumPy, C libraries), never plain-Python loops.

The code of the analysis is described on [[radiology-analysis]]. Modelling plan, decided by Giovanni on 2026-10-30 (full text in `legacy/docs/modelling-directives.md` of the repository): once the article download is finished, four competing mathematical models are built and scored the same way, in the style of the skill [[skill-skill-forge]] (several versions compared by tests). Version 1 is Claude's own analysis of all articles without prior bias; version 2 is the same by Codex; version 3 is a fully academic approach after thorough research, with Claude and Codex debating; version 4 is Giovanni's own idea. His idea works in layers: first hard filters that remove diagnoses which cannot fit (patient group such as child or adult and sex, imaging method, location in the body), then softer filters that only lower a diagnosis (texture, brightness or density of the finding, side, size and margins, contrast uptake and blood flow, clinical history), and last a purely statistical step on the subjective wording of the report, which gives little weight to filler words used when the radiologist is unsure. Missing information never removes a diagnosis; instead an "akinator-style" routine (like the guessing game, it asks the question that removes the most candidates) asks the user, who can always skip it or type text instead. The page starts with a choice between a guided search and an open text box. Every article is tagged by Codex and by word lists, and the two are compared. For each diagnosis, half of its real cases tune the model and half test it; diagnoses with too few cases get cases from published literature. The heavy calculation (the analysis now, the matching engine later) must use several processor threads and the graphics card (GPU) when the machine has one, and fall back to the processor alone, with the same results, when it has not (Giovanni, 2026-10-29). Status of the analysis (2026-10-30): the foundation and every part that needs no Codex are built and tested: a frozen copy of the 17,361 articles, a hardware layer (all processor threads, GPU when present), the scoring harness (half of each diagnosis tunes, half tests), the word-list tagger, the filter layers with the question chooser, the wording layer with negation, hedging and filler, and version 1. Still waiting: the cases (they download in random order, about 9 days in total), and Giovanni's approval of a Codex budget for the Codex tagging and versions 2 and 3. The live step-by-step list is the home page of the plan site and the file `docs/plan.json` of the repository; every person or program continuing the work reads it first and updates it after each step with `tools/plan.py`. Update 2026-10-30: Giovanni approved a Codex pilot and asked for the filler-word list (vague words that carry no information) to be tested with a scientific method instead of a manual review. In the pilot Codex tagged 300 articles (about 7,700 tokens and 1.4 seconds of wall time each with four workers); it agrees with the word lists on article type in 75 % of cases and differs most on age and sex, where it finds a statement much more often. The filler test has a written protocol with controls: random words must not be called filler and invented filler words must be found. Its first two designs failed those controls and were amended openly; the third passed. So far only one of 30 testable starting words ("may") is confirmed as filler; the final list waits for the real cases. Tagging update 2026-10-30: three Haiku instances tagged the same 300 pilot articles as Codex. Codex and Haiku agree with each other much more (article type 89 %, imaging method 0.87, region 0.81) than either agrees with the word lists (type 75 to 77 %), so the word lists are the outlier. Following Giovanni's rule (if they do not disagree consistently, let each work alone), the full tagging now runs without comparison: Codex works from the front of the queue and Haiku instances from the back, in waves of six batches of 100 articles, each skipping what the other has finished. Update 2026-11-05 (Giovanni's decisions, `legacy/docs/modelling-directives.md`): version 4 has no hard filters before the ranking; imaging method and region no longer remove anything, and age and sex are applied after the word ranking as removal filters, only for what the user stated or answered. An age removes a diagnosis only when its article says the disease occurs only in that age group. After this fix the corrected version 4 is close to version 1 on cases neither was tuned on (top-10: English .629 against .640, German .503 against .502, Portuguese .589 against .608). Update 2026-11-08: version 3 (step C4) has a written starting point, `legacy/docs/problem-formulation.md`, which states the task as mathematics (rank about 7,200 diagnoses so the right one is in the first k suggestions as often as possible) and lists what the model must handle; it is the brief for the Claude and Codex debate, not a fifth version, Giovanni approved version 3 the same day; it is built ([[radiology-v3]]): a word model per diagnosis that starts from the article and is taken over by its teaching cases, designed by a Claude proposal and a Codex critique. Scored on 2026-11-08 it does not beat version 2 (test-half top-10 79.3 %, 74.6 %, 78.2 % against 80.2 %, 75.0 %, 79.1 %) but finds diagnoses with no teaching case about twice as often; step S1 (all four versions scored) is done, and S2 (compare and combine) is next.

## Where it sits in the pipeline
It starts the chain: [[radiopaedia-crawler]] → [[report-translator]] → (planned) index builder → (planned) website.

## Who receives its output
Giovanni, through the plan website now and through the planned website later.

## Notes
On 2026-11-02 the case translation pipeline was repaired: old progress writers omitted case counters, and interactive Codex documentation hooks replaced translation output with workflow messages. Calls now ignore interactive configuration (requirement TL-8); four workers keep translating downloaded cases into German and Portuguese. Saved translations were preserved and 93 pending missing-title failures were requeued with their prior counters saved locally. In a 274-second observation, 25 cases downloaded while 60 German and 62 Portuguese translations completed. This is a short observation, not a guarantee of future throughput. Analysis step L1d remains in progress: translated case sets, labels, split and per-language scores are still outstanding. See [[report-translator]] for the recovery details. On 2026-11-04 about 1,150 cases per language that had been set aside after three failed translations were requeued for another try by the Haiku workers; see [[report-translator]]. Since the same day the four translator services run on Claude Haiku instead of Codex.

Research for version 3 (step C4, 2026-11-06, by Codex) is in two notes, `legacy/docs/v3-research-codex-ir.md` (information retrieval and text statistics; it proposes starting with a smoothed query-likelihood model) and `legacy/docs/v3-research-codex-clinical.md` (clinical decision support and choosing the next question). They are proposals for debate, with no code and no requirement rows, because a research report makes no software promise.

Update 2026-11-07: Codex finished version 2 (step C3): a word-matching model per language that also compares a report with the training cases of each diagnosis. On cases held back inside the tuning half its top-10 rate is 81 % (English), 75 % (German) and 79 % (Portuguese); these cases differ from those used for versions 1 and 4, so the versions are not yet comparable. On 2026-11-07 version 2 was scored once on the same held-back cases as versions 1 and 4 (step S1, requirement AN-36). Top-10 on the test half: English 80.2 %, German 75.0 %, Portuguese 79.1 %, against 64.7 %, 52.8 % and 62.3 % for version 1; on the newer cases 76.5 %, 69.7 % and 75.3 %. Its lead comes from learning from earlier teaching cases of each diagnosis, which versions 1 and 4 do not do. Version 2 has its own module reference: [[radiology-v2]].

Update 2026-11-08: On 2026-11-08 Giovanni ruled that the models are built from the articles only: a case never enters a model, and the labelled cases of the tuning half (cases kept for choosing settings) only choose a few free numbers, while the test cases only score (`legacy/docs/modelling-directives.md`, principle 13 in the repository's CLAUDE.md). Versions 1, 2 and 3 had broken it (versions 2 and 3 most: their scores of about 80 % came mainly from learning on the tuning cases), so they were rebuilt from the articles only (step S1b). Under that rule, among versions 1 to 3 rebuilt from articles only, the order on the test half is V1a, then V3a, then V2a in every language (top-10, the share of cases whose true diagnosis is among the ten best: English 61.7 %, 56.0 %, 53.3 %; German 49.0 %, 44.2 %, 39.6 %; Portuguese 58.6 %, 53.0 %, 50.3 %), with version 4 at 56.6 %, 46.0 % and 54.3 %, unpaired (`legacy/docs/articles-only-report.md`). The next step, S2, merges only parts that follow the rule, starting from V1a.

Update 2026-11-08 (finding tags): before the merge step S2, each diagnosis article gets imaging-finding tags with up to five equivalent wordings, fact-checked against the article and the literature (step T2, `analysis/morph_tags.py`, see [[radiology-analysis]]). Then all four versions are redone by fresh sessions with the tags, and each also without them (step S1c). After the pilots, Giovanni chose Sonnet for the full tagging run, which started on 2026-11-08. Since 2026-11-08 a Codex re-check of 50 tagged articles measures how stable the tags are (89 % agreement), and Giovanni chose to start step S1c before the tag run ends: the designs of all four versions are written, and Codex builds versions 2, 3 and 4.

Update 2026-11-10 (Results page): the plan site has a ninth content page, Results (`results.html`, requirement WS-5), built by `site_src/results.py` from `docs/results-registry.json`. It lists 33 scored tests in eight stages (baseline rankers, independent versions 2 and 3, the articles-only rule, tagging checks, filler words and dangerous misses, finding tags and tagged rankers, data quality, the finding assistant). Each test shows its stage and project steps, question, method, data and split, measure, results table, a status (final, provisional, superseded, running, planned), a reading, a caveat and its source file; a comparison table puts every diagnosis ranker side by side on the test and new halves. The build refuses a test with a missing field, an unknown stage or a ragged table. Whoever finishes a test adds its entry to the registry file and rebuilds the site with `python3 -I site_src/build.py`.

Update 2026-11-14: the finding engine has a first slice, English only ([[radiology-finding-engine]]); the German and Portuguese translators are paused ([[report-translator]]).

Update 2026-11-14 (later): the assistant analyses one structure at a time; a text with several structures gets three suggestions per structure ([[radiology-finding-engine]]).

Update 2026-11-14 (data policy): Giovanni allowed the tuning half of the cases and the articles to train the finding assistant's learned matcher; the test half and the final real reports never train it ([[radiology-finding-engine]]).

Update 2026-11-14 (R6, R7): the finding assistant now says whether a description is sufficient and asks the question with the largest expected gain (`assistant/dialog.py`); results in [[radiology-finding-engine]].

Update 2026-11-14 (terms check): the live Radiopaedia terms page could not be read from here (HTTP 402); a 2022 copy says its data is not meant to be mass-downloaded for machine learning, so before anything trained on its text is shipped Giovanni reads the live terms or asks for written permission (recorded in docs/r1/r1-xray-lexicons-and-test-sources.md).

Update 2026-11-14 (training corpus): the finding assistant's matcher is calibrated on a formal cross-checked corpus (literature inventory, quotes agreed by two annotators, checked rewrites, synonym lists), not on Radiopaedia as such; rows are tuning half only and keep their origin. Details in [[radiology-finding-engine]].

Update 2026-11-14 (reorganisation): one plan file with lanes and milestones replaced the step list (`docs/analysis-status.json`, now `legacy/docs/analysis-status-20261114.json`); `docs/SCOPE.md` replaced the problem statement; the old diagnosis ranker moved to `legacy/` and the git tag `ranker-final` marks the last commit where it ran in place. The notes above this one describe the earlier state and use the step names of that time.
