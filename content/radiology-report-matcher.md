---
id: radiology-report-matcher
title: Radiology Report Matcher (planned website)
aliases: [report matcher, radiology matcher]
kind: project
project: none
status: active
location: radiology-crawler:
fed_by: []
feeds: []
sources: [radiology-crawler:DESIGN.md, radiology-crawler:CLAUDE.md, radiology-crawler:docs/REQUIREMENTS.md, radiology-crawler:docs/adr/0002-technology-and-languages.md, radiology-crawler:tools/quality_gate.sh, radiology-crawler:.github/workflows/quality-gate.yml, radiology-crawler:site_src/build.py, radiology-crawler:run_all.sh]
reviewed: 2026-10-27T20:13Z
---

## What it is
A project to build a website where a radiologist types the free-text report of an imaging exam, says which exam and technique it was, adds the patient's basic data and clinical history, and gets back: a ranked list of likely diagnoses with the report words that caused each one, links to articles that explain the case, and structured scores (a "structured score" is a fixed points system that turns described findings into a risk category; the first one planned is ACR TI-RADS, a score for thyroid nodules on ultrasound). The matching is plain counting and arithmetic on words, not an artificial-intelligence model. It should work for reports written in English, German and Brazilian Portuguese. Giovanni plans to run it on a desktop computer bought for the purpose, and it may become a commercial tool later.

As of 2026-10-27 only the data-collection part exists: a crawler ([[radiopaedia-crawler]]) and a translator ([[report-translator]]). The search, the score engine and the website are planned, not built. The plan, with diagrams and a development log, is an offline website in `~/Documents/Radiology Report Matcher/`; the script `site_src/build.py` rebuilds it with live numbers from the database.

## Flow
trigger t1: Giovanni asks for the project and its next step | [[claude-code]]
step s1: Download the pages of the reference site, slowly | [[radiopaedia-crawler]]
step s2: Translate each page into German and Portuguese with textbook wording | [[report-translator]], [[codex]]
step s3: Build term tables and a search index from the pages (planned)
step s4: Match a typed report to articles and diagnoses (planned)
decide d1: Does the report describe all features of a score?
step s5: Compute the score from a fixed points table (planned)
step s6: Say which feature is missing, never guess (planned)
product p1: Ranked suggestions, article links and score on a web page (planned)
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

### Decisions
Four architecture decision records (ADRs, short notes that keep the reasons for a decision) in `docs/adr/`: record decisions (0001), the stack and the rule for the math (0002), the maintenance program measures and the review skill judges (0003), plus the blank template (0000).

### Requirements
Eleven requirements in `docs/REQUIREMENTS.md`: five for the crawler (prefix CW), five for the translator (TL) and one for the plan site (WS). Each has a test tagged `REQ <ID>`; the traceability step fails when one has none.

### Quality gate
`tools/quality_gate.sh` has three steps: compile the code and run the 11 tests; requirement traceability; the fitness functions of `pipeline-check` (the maintenance program, see [[pipeline-check]]): architecture rule, shell-script lint, a limit of 800 lines per Python file, and gate time.

### Continuous integration
Continuous integration (CI) means automatic checks on every push. The workflow `quality-gate.yml` runs the gate on GitHub; a local pre-push check runs it before `main` is pushed. On 2026-10-27 the first run failed because a fresh copy of the repository has no `data/` folder and the crawler's log function assumed one; the fix passed.

### Maintenance
Technical debt is tracked as GitHub issues labelled `debt` with priorities P1 to P3 under the [[maintenance-policy]]; the labels exist. A monthly review is planned.

## What it does
Today it collects and prepares text. The planned website will turn a typed report into observations (a finding, where it is, its size, and whether it is present, absent, uncertain or old), compare them with the collected articles using BM25 (a standard formula that ranks a text by how many rare, informative words it shares with the query), and show the evidence. Decisions already taken: the first version covers one narrow area (thyroid ultrasound with TI-RADS); no patient data is stored; the computer has no graphics card and must serve several people at once; Claude and Codex write the code and Giovanni reviews and tests it.

## How it does it
Source of the content: Radiopaedia, a free radiology reference site. Its pages are in English only; the sitemap lists no German or Portuguese versions. Its `robots.txt` file (the file where a site tells automated visitors what they may do) allows article and case pages with a delay of 10 seconds between requests, and states a reservation against use for training AI models. The pages are licensed CC BY-NC-SA (Creative Commons, non-commercial, share-alike). Giovanni decided to proceed: the product will not display Radiopaedia text, it builds a statistical mapping and not an AI model, other sources will be added, and Giovanni will talk with Radiopaedia if they object. Whether this is enough for commercial use is a legal question that has not been answered.

The method was chosen from a research report written by [[codex]] on 2026-10-27: BM25 plus a term lexicon, negation rules and a fixed score table, with learned reranking and embeddings (numbers that represent the meaning of a text) only if a test shows they help. The report itself said that no published study proves any method meets this exact goal, so a test set of physician-written reports is required.

The code lives in the private repository `yujideluca/radiology-report-matcher` (folder `~/dev/radiology-crawler`, kept under that name because long jobs run from it). The plan site is also published openly, with no login, through Tailscale Funnel on port 8443 (the wiki keeps the main port behind its sign-in); a small static server, `radiology-plan-site.service`, serves the folder `~/Documents/Radiology Report Matcher/` from this laptop, so it is online while the laptop is on. Languages decided by Giovanni on 2026-10-27: Python tools, Elixir back end, Elm front end, and the matching math in high-speed numerical Python (Cython, NumPy, C libraries), never plain-Python loops.

## Where it sits in the pipeline
It starts the chain: [[radiopaedia-crawler]] → [[report-translator]] → (planned) index builder → (planned) website.

## Who receives its output
Giovanni, through the plan website now and through the planned website later.
