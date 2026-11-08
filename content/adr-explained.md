---
id: adr-explained
title: ADRs and the decision log explained
aliases: [architecture decision record, decision log, ADR explained]
kind: decision
project: none
status: active
location: project-template:docs/adr
fed_by: []
feeds: []
sources: [project-template:docs/adr, project-template:DESIGN.md, QuizApp:docs/adr, wiki:docs/adr, workflow-memory:docs/adr, machine-bootstrap:docs/adr, status-quo:docs/adr, codex-pbar:docs/adr, codex-skills:docs/adr, radiology-crawler:docs/adr, pipeline-check:docs/adr]
reviewed: 2026-11-08T20:04Z
---

## What it is
An ADR (architecture decision record) is a short note that records one important decision: the context, the decision, the alternatives that were considered and the consequences ([adr.github.io](https://adr.github.io/)). It answers the question a future reader always has: "why is it built this way?". A decision that touches the structure of a project gets an ADR; a smaller one gets a row in the decision log, a table in `DESIGN.md`.

## What it does
Each ADR is a numbered Markdown file in `docs/adr/` with a status, a date, the maintenance type of the standard ISO/IEC/IEEE 14764 (initial, corrective, adaptive, perfective or preventive; see [[maintenance-policy]]) and who decided. ADR-0001 in every project is "record decisions as ADRs"; `0000-template.md` is the blank form. The same shared decision appears in each repository under its own number: "the program measures, a skill judges" is 0013 in [[quizapp-adrs]], 0005 in the wiki, 0004 in workflow-memory, 0002 in pipeline-check and 0003 in the other projects. The number of ADRs per project: QuizApp 14 (0014, of 2026-11-06, is the simulated FSP exam cases mode, FSP being the Fachsprachprüfung, the German medical-language exam), wiki 11 (0011 is "the wiki is English only"), workflow-memory 7, codex-pbar 5, machine-bootstrap 5, pipeline-check 3, codex-skills 3, radiology-crawler 4, status-quo 5 (0001 to 0005, among them 0002 portable Rust widgets, 0004 a host compatibility layer and 0005 the free-canvas layout of its tray), and 2 in [[project-template]] (0001 and 0003).

## How it does it
Nothing checks the ADR text itself. The rule "decisions are written where the code is" is a principle in each project's `CLAUDE.md`; the monthly review ([[monthly-architecture-review]]) looks for decisions that were made without a record. A decision stated only in chat is not considered recorded.

## Where it sits in the pipeline
It is the last step of [[code-security-pipeline]]: after a structural change is accepted, its reason is written down. The per-project lists are in the `checks-` pages, and the shared decision is described in [[maintenance-pipeline]].

## Who receives its output
Future readers: [[giovanni]], Claude sessions and the [[monthly-architecture-review]].
