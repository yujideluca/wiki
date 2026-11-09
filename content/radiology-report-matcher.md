---
id: radiology-report-matcher
title: Radiology Report Matcher (planned website)
aliases: [report matcher, radiology matcher]
kind: project
project: none
status: active
location: radiology-crawler:
fed_by: [radiology-r1-xray-review]
feeds: []
sources: [radiology-crawler:docs/assistant-problem-statement.md, radiology-crawler:docs/adr/0007-finding-assistant-replaces-diagnosis-ranker.md, radiology-crawler:docs/finding-assistant-requirements-draft.md, radiology-crawler:docs/v3-design.md, radiology-crawler:docs/v3-report.md, radiology-crawler:docs/problem-formulation.md, radiology-crawler:docs/v3-research-codex-ir.md, radiology-crawler:docs/v3-research-codex-clinical.md, radiology-crawler:DESIGN.md, radiology-crawler:CLAUDE.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/adr/0002-technology-and-languages.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:tools/check_dependencies.py, radiology-crawler:requirements.txt, radiology-crawler:requirements-optional.txt, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:site_src/build.py, radiology-crawler:run_all.sh, radiology-crawler:docs/modelling-directives.md, radiology-crawler:docs/analysis-status.json, radiology-crawler:AGENTS.md, radiology-crawler:analysis/__init__.py, radiology-crawler:docs/articles-only-report.md, radiology-crawler:docs/finding-tags-pilot.md, radiology-crawler:docs/s1c-briefs.md, radiology-crawler:analysis/jobs.py, radiology-crawler:progress.py, radiology-crawler:site_src/build.py, radiology-crawler:docs/finding-tags-audit.md, radiology-crawler:docs/s1c-v3t-design.md, radiology-crawler:docs/adr/0004-v2t-article-and-finding-retrieval.md, radiology-crawler:docs/adr/0005-v4t-wording-channels.md, radiology-crawler:docs/adr/0006-v3t-frozen-retrieval.md]
reviewed: 2026-11-09T19:26Z
---

## What it is
A project to build a website that helps a radiologist describe what they see. The radiologist types a loose, informal description of a structure on an imaging exam, says which exam and technique it was, and adds basic patient data. The website then (1) names the radiological findings the description could mean, in the correct technical terms (a "finding" is one named observation on an image, for example a ring-enhancing lesion or a ground-glass opacity); (2) says when the description is too poor to tell, instead of guessing; and (3) asks the questions that make the description precise, offering the standard values (for example margin: well-defined, lobulated or spiculated). Related diagnoses and links to articles that explain them come second. It is an assistant for describing findings, not a tool that gives the clinical diagnosis. Structured scores (a "structured score" is a fixed points system that turns described findings into a risk category; the first one planned is ACR TI-RADS, a score for thyroid nodules on ultrasound) follow the same descriptions. It should work in English, German and Brazilian Portuguese. Giovanni plans to run it on a desktop computer bought for the purpose, and it may become a commercial tool later.

Goal change on 2026-11-09 (ADR-0007, an architecture decision record, a short file that records one structural decision; `docs/assistant-problem-statement.md`): until then the work aimed at ranking diagnoses from a typed report; Giovanni clarified that the goal is the description assistant above, so the earlier ranking models (versions 1 to 4) are kept only as a baseline and are being redone. The findings, the attributes a proper description of each states, and their standard terms are built from the published literature (radiology lexicons and reporting systems such as RadLex, BI-RADS, LI-RADS and TI-RADS, textbooks and reviews); the downloaded Radiopaedia articles and cases judge the system and never define it. Two frozen tests decide success: proper technical descriptions must have the right finding among the first three suggestions close to 100 % of the time, and imprecise descriptions written the way a hurried user types must reach at least 90 % after a simulated user answers the system's questions. The system is built as modules, one per imaging method, in the order X-ray, ultrasound, CT and its variants, MRI, each finished before the next; no radiologist is available to judge it, so the final test is a set of real radiological reports from the internet that are fact-checked before they count, and the system proposes three strict findings and highlights the most likely, it counts as right only when one of the three is exactly the right finding (a more general, more specific or neighbouring finding is a miss), and the target for proper descriptions is 97 %. Steps R0 to R10 of the analysis status record this work; R1 (literature review of X-ray findings, see [[radiology-r1-xray-review]]) was written and verified on 2026-11-09, and its first findings on reuse are that the RadLex terminology licence allows commercial use if terms are only added and never changed, that the one public X-ray report collection checked (Indiana, about 3,955 English reports) is CC BY-NC-ND, and that open-access PubMed Central case reports are the only lawful source found so far for German and Portuguese test reports; R0 (problem statement, decision record and requirements draft) is done, the literature review is next.

As of 2026-11-01 the data-collection part exists, a crawler ([[radiopaedia-crawler]]) and a translator ([[report-translator]]), and the statistical analysis is under way ([[radiology-analysis]]). The search, the score engine and the website are planned, not built. The plan, with diagrams and a development log, is an offline website in `~/Documents/Radiology Report Matcher/`; the script `site_src/build.py` rebuilds it with live numbers from the database. `python3 -I site_src/build.py watch` rewrites a small data file (`progress-data.js`) every 5 seconds, and every open page reloads it and moves its progress bars and the counters in its summary boxes: articles and cases downloaded, articles extracted, articles translated to German and Portuguese, cases translated to German and Portuguese, average translation time. If the updater is not running, the page says its numbers are old.

## Flow
trigger t1: Giovanni asks for the project and its next step | [[claude-code]]
step s1: Download the pages of the reference site, slowly | [[radiopaedia-crawler]]
step s2: Translate each page into German and Portuguese with textbook wording | [[report-translator]], [[codex]]
step s3: Build term tables and a search index from the pages (planned)
step s4: Name the findings a loose description could mean, check it is sufficient, ask the missing questions (planned)
decide d1: Does the description state all features of a score?
step s5: Compute the score from a fixed points table (planned)
step s6: Say which feature is missing, never guess (planned)
product p1: Suggested findings in correct terms, questions, related diagnoses, article links and score on a web page (planned)
product p2: The offline plan website with the development log

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> d1
d1 -yes-> s5
d1 -no-> s6
s5 -> p1
s6 -> p1
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
1. **Requirement, then test, then code**: a promise becomes a row in `docs/REQUIREMENTS.md`, then a test tagged `REQ <ID>`, then code.
2. **Languages decided by Giovanni (2026-10-27)**: small tools in Python; web back end in Elixir; front end in Elm; the statistical math and the matching of a report against the pages in high-speed numerical Python (Cython, NumPy, C libraries), never plain-Python loops, which are too slow. The engine's first commit adds a speed-budget requirement so a test enforces it.
3. **The gate decides**: `tools/quality_gate.sh` is the one definition of passing.
4. **Polite and lawful collection**: the crawler obeys `robots.txt`; downloaded pages, databases and textbooks never enter git.
5. **Codex use is bounded**: fresh sessions under 250,000 tokens, the cheaper model for translations.
6. **Decisions are written where the code is**: a decision log in `DESIGN.md` and an architecture decision record (ADR) for structural ones.
7. **Declare every dependency (2026-11-01)**: a third-party package the code imports (a package that does not ship with Python, such as NumPy) must be listed in `requirements.txt` in the same commit. CI (continuous integration, automatic checks on every push) installs packages only from that file. A package used only behind a fallback, such as CuPy (the GPU library), is listed in `requirements-optional.txt` instead.
8. **One model set per language (2026-11-01)**: every identification model (the word-list tagger, the filters, the wording layer and model versions 1 to 4) is built, tuned and scored separately for English, German and Brazilian Portuguese, on that language's own pages and cases (German and Portuguese are the translations). When a user types a report, a fast language check comes first and sends it to that language's models. The routing pipeline is designed only after all the per-language models are tested.

### Decisions
Six architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: record decisions (0001), the stack and the rule for the math (0002), the maintenance program measures and the review skill judges (0003), version 2 with finding tags keeps the article score and adds the tags as a separate channel (0004, step S1c), version 4 with finding tags keeps article and finding wordings in separate channels (0005), version 3 with finding tags is frozen with a one-use audit record (0006), plus the blank template (0000).

### Requirements
Eighty-five requirements in `docs/REQUIREMENTS.md` (committed, 2026-11-08): seven for the crawler (prefix CW), nine for the translator (TL), four for the plan site (WS), fifty-six for the statistical analysis (AN, including AN-32 to AN-35 for the C5 literature pilot, AN-36 for the outer scoring of version 2, AN-43 and AN-44 for the finding tags and AN-45 for live job progress, AN-46 and AN-47 for the second-engine tag check, AN-48 to AN-50 for version 2 with finding tags, AN-51 to AN-53 for version 4 with finding tags, AN-54 to AN-56 for version 3 with finding tags), one for dependencies (DP), four for per-language models (LG), and four for the translation check (TC), which measures how often the German and Portuguese translations are wrong ([[radiology-analysis]]). An ID is exactly two capital letters, a dash and a number; since pipeline-check v0.7.0 (now pinned at v0.8.0) any other shape (such as `AN-V2-1`) fails the traceability step instead of being skipped. Each has a test tagged `REQ <ID>`; the traceability step fails when one has none.

### Quality gate
`tools/quality_gate.sh` has four steps: (0) `tools/check_dependencies.py` fails when the code imports a third-party package that is in neither `requirements.txt` nor `requirements-optional.txt`, or when a workflow installs packages from anywhere else; (1) compile the code and run the tests (145 in the committed code on 2026-11-06, among them a check that every script's `--help` does no work, see [[radiology-analysis]]); (2) requirement traceability; (3) the fitness functions of `pipeline-check` (the maintenance program, see [[pipeline-check]]): architecture rule, shell-script lint, a limit of 800 lines per Python file, and gate time.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub; a local pre-push check runs it before `main` is pushed. On 2026-10-27 the first run failed because a fresh copy of the repository has no `data/` folder and the crawler's log function assumed one; the fix passed. On 2026-11-01 run 41335076862 failed because the analysis code imported NumPy while `requirements.txt` did not list it: the laptop passed because the gate added its own library folder (`~/.local/share/claude-workflow/pylibs`) to the search path. The gate now adds that folder only when the `CI` variable is not `true`, and step 0 above prevents the gap. A run on a clean Python 3.12 environment with only `requirements.txt` installed passed.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` with priorities P1 to P3 under the [[maintenance-policy]]; the labels exist. A monthly review is planned.

## What it does
Today it collects and prepares text. The planned website will turn a typed report into observations (a finding, where it is, its size, and whether it is present, absent, uncertain or old), compare them with the collected articles using BM25 (a standard formula that ranks a text by how many rare, informative words it shares with the query), and show the evidence. Decisions already taken: the first version covers one narrow area (thyroid ultrasound with TI-RADS); no patient data is stored; the computer has no graphics card and must serve several people at once; Claude and Codex write the code and Giovanni reviews and tests it.

## How it does it
Source of the content: Radiopaedia, a free radiology reference site. Its pages are in English only; the sitemap lists no German or Portuguese versions. Its `robots.txt` file (the file where a site tells automated visitors what they may do) allows article and case pages with a delay of 10 seconds between requests, and states a reservation against use for training AI models. The pages are licensed CC BY-NC-SA (Creative Commons, non-commercial, share-alike). Giovanni decided to proceed: the product will not display Radiopaedia text, it builds a statistical mapping and not an AI model, other sources will be added, and Giovanni will talk with Radiopaedia if they object. Whether this is enough for commercial use is a legal question that has not been answered.

The method was chosen from a research report written by [[codex]] on 2026-10-27: BM25 plus a term lexicon, negation rules and a fixed score table, with learned reranking and embeddings (numbers that represent the meaning of a text) only if a test shows they help. The report itself said that no published study proves any method meets this exact goal, so a test set of physician-written reports is required.

The code lives in the private repository `yujideluca/radiology-report-matcher` (folder `~/dev/radiology-crawler`, kept under that name because long jobs run from it). The plan site is also published openly, with no login, through Tailscale Funnel on port 8443 (the wiki keeps the main port behind its sign-in); a small static server, `radiology-plan-site.service`, serves the folder `~/Documents/Radiology Report Matcher/` from this laptop, so it is online while the laptop is on. Its home page shows live bars: downloads and translations (from the crawler database), and, under "Analysis jobs running now", one bar per long analysis job with items done, rate per hour, time left and state (running, paused for example by a usage limit, done, failed, or not updating after 10 minutes). Each job writes its counts through `analysis/jobs.py` (see [[radiology-analysis]]); the user service `radiology-plan-updater.service` rewrites the page's data file every 5 seconds. Languages decided by Giovanni on 2026-10-27: Python tools, Elixir back end, Elm front end, and the matching math in high-speed numerical Python (Cython, NumPy, C libraries), never plain-Python loops.

The code of the analysis is described on [[radiology-analysis]]. Modelling plan, decided by Giovanni on 2026-10-30 (full text in `docs/modelling-directives.md` of the repository): once the article download is finished, four competing mathematical models are built and scored the same way, in the style of the skill [[skill-skill-forge]] (several versions compared by tests). Version 1 is Claude's own analysis of all articles without prior bias; version 2 is the same by Codex; version 3 is a fully academic approach after thorough research, with Claude and Codex debating; version 4 is Giovanni's own idea. His idea works in layers: first hard filters that remove diagnoses which cannot fit (patient group such as child or adult and sex, imaging method, location in the body), then softer filters that only lower a diagnosis (texture, brightness or density of the finding, side, size and margins, contrast uptake and blood flow, clinical history), and last a purely statistical step on the subjective wording of the report, which gives little weight to filler words used when the radiologist is unsure. Missing information never removes a diagnosis; instead an "akinator-style" routine (like the guessing game, it asks the question that removes the most candidates) asks the user, who can always skip it or type text instead. The page starts with a choice between a guided search and an open text box. Every article is tagged by Codex and by word lists, and the two are compared. For each diagnosis, half of its real cases tune the model and half test it; diagnoses with too few cases get cases from published literature. The heavy calculation (the analysis now, the matching engine later) must use several processor threads and the graphics card (GPU) when the machine has one, and fall back to the processor alone, with the same results, when it has not (Giovanni, 2026-10-29). Status of the analysis (2026-10-30): the foundation and every part that needs no Codex are built and tested: a frozen copy of the 17,361 articles, a hardware layer (all processor threads, GPU when present), the scoring harness (half of each diagnosis tunes, half tests), the word-list tagger, the filter layers with the question chooser, the wording layer with negation, hedging and filler, and version 1. Still waiting: the cases (they download in random order, about 9 days in total), and Giovanni's approval of a Codex budget for the Codex tagging and versions 2 and 3. The live step-by-step list is the home page of the plan site and the file `docs/analysis-status.json` of the repository; every person or program continuing the work reads it first and updates it after each step with `tools/analysis_status.py`. Update 2026-10-30: Giovanni approved a Codex pilot and asked for the filler-word list (vague words that carry no information) to be tested with a scientific method instead of a manual review. In the pilot Codex tagged 300 articles (about 7,700 tokens and 1.4 seconds of wall time each with four workers); it agrees with the word lists on article type in 75 % of cases and differs most on age and sex, where it finds a statement much more often. The filler test has a written protocol with controls: random words must not be called filler and invented filler words must be found. Its first two designs failed those controls and were amended openly; the third passed. So far only one of 30 testable starting words ("may") is confirmed as filler; the final list waits for the real cases. Tagging update 2026-10-30: three Haiku instances tagged the same 300 pilot articles as Codex. Codex and Haiku agree with each other much more (article type 89 %, imaging method 0.87, region 0.81) than either agrees with the word lists (type 75 to 77 %), so the word lists are the outlier. Following Giovanni's rule (if they do not disagree consistently, let each work alone), the full tagging now runs without comparison: Codex works from the front of the queue and Haiku instances from the back, in waves of six batches of 100 articles, each skipping what the other has finished. Update 2026-11-05 (Giovanni's decisions, `docs/modelling-directives.md`): version 4 has no hard filters before the ranking; imaging method and region no longer remove anything, and age and sex are applied after the word ranking as removal filters, only for what the user stated or answered. An age removes a diagnosis only when its article says the disease occurs only in that age group. After this fix the corrected version 4 is close to version 1 on cases neither was tuned on (top-10: English .629 against .640, German .503 against .502, Portuguese .589 against .608). Update 2026-11-08: version 3 (step C4) has a written starting point, `docs/problem-formulation.md`, which states the task as mathematics (rank about 7,200 diagnoses so the right one is in the first k suggestions as often as possible) and lists what the model must handle; it is the brief for the Claude and Codex debate, not a fifth version, Giovanni approved version 3 the same day; it is built ([[radiology-v3]]): a word model per diagnosis that starts from the article and is taken over by its teaching cases, designed by a Claude proposal and a Codex critique. Scored on 2026-11-08 it does not beat version 2 (test-half top-10 79.3 %, 74.6 %, 78.2 % against 80.2 %, 75.0 %, 79.1 %) but finds diagnoses with no teaching case about twice as often; step S1 (all four versions scored) is done, and S2 (compare and combine) is next.

## Where it sits in the pipeline
It starts the chain: [[radiopaedia-crawler]] → [[report-translator]] → (planned) index builder → (planned) website.

## Who receives its output
Giovanni, through the plan website now and through the planned website later.

## Notes
On 2026-11-02 the case translation pipeline was repaired: old progress writers omitted case counters, and interactive Codex documentation hooks replaced translation output with workflow messages. Calls now ignore interactive configuration (requirement TL-8); four workers keep translating downloaded cases into German and Portuguese. Saved translations were preserved and 93 pending missing-title failures were requeued with their prior counters saved locally. In a 274-second observation, 25 cases downloaded while 60 German and 62 Portuguese translations completed. This is a short observation, not a guarantee of future throughput. Analysis step L1d remains in progress: translated case sets, labels, split and per-language scores are still outstanding. See [[report-translator]] for the recovery details. On 2026-11-04 about 1,150 cases per language that had been set aside after three failed translations were requeued for another try by the Haiku workers; see [[report-translator]]. Since the same day the four translator services run on Claude Haiku instead of Codex.

Research for version 3 (step C4, 2026-11-06, by Codex) is in two notes, `docs/v3-research-codex-ir.md` (information retrieval and text statistics; it proposes starting with a smoothed query-likelihood model) and `docs/v3-research-codex-clinical.md` (clinical decision support and choosing the next question). They are proposals for debate, with no code and no requirement rows, because a research report makes no software promise.

Update 2026-11-07: Codex finished version 2 (step C3): a word-matching model per language that also compares a report with the training cases of each diagnosis. On cases held back inside the tuning half its top-10 rate is 81 % (English), 75 % (German) and 79 % (Portuguese); these cases differ from those used for versions 1 and 4, so the versions are not yet comparable. On 2026-11-07 version 2 was scored once on the same held-back cases as versions 1 and 4 (step S1, requirement AN-36). Top-10 on the test half: English 80.2 %, German 75.0 %, Portuguese 79.1 %, against 64.7 %, 52.8 % and 62.3 % for version 1; on the newer cases 76.5 %, 69.7 % and 75.3 %. Its lead comes from learning from earlier teaching cases of each diagnosis, which versions 1 and 4 do not do. Version 2 has its own module reference: [[radiology-v2]].

Update 2026-11-08: On 2026-11-08 Giovanni ruled that the models are built from the articles only: a case never enters a model, and the labelled cases of the tuning half (cases kept for choosing settings) only choose a few free numbers, while the test cases only score (`docs/modelling-directives.md`, principle 13 in the repository's CLAUDE.md). Versions 1, 2 and 3 had broken it (versions 2 and 3 most: their scores of about 80 % came mainly from learning on the tuning cases), so they were rebuilt from the articles only (step S1b). Under that rule, among versions 1 to 3 rebuilt from articles only, the order on the test half is V1a, then V3a, then V2a in every language (top-10, the share of cases whose true diagnosis is among the ten best: English 61.7 %, 56.0 %, 53.3 %; German 49.0 %, 44.2 %, 39.6 %; Portuguese 58.6 %, 53.0 %, 50.3 %), with version 4 at 56.6 %, 46.0 % and 54.3 %, unpaired (`docs/articles-only-report.md`). The next step, S2, merges only parts that follow the rule, starting from V1a.

Update 2026-11-08 (finding tags): before the merge step S2, each diagnosis article gets imaging-finding tags with up to five equivalent wordings, fact-checked against the article and the literature (step T2, `analysis/morph_tags.py`, see [[radiology-analysis]]). Then all four versions are redone by fresh sessions with the tags, and each also without them (step S1c). After the pilots, Giovanni chose Sonnet for the full tagging run, which started on 2026-11-08. Since 2026-11-08 a Codex re-check of 50 tagged articles measures how stable the tags are (89 % agreement), and Giovanni chose to start step S1c before the tag run ends: the designs of all four versions are written, and Codex builds versions 2, 3 and 4.
