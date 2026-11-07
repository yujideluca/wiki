---
id: quizapp-requirements
title: QuizApp requirements and traceability
aliases: [REQUIREMENTS.md, TESTING.md, REQ tags]
kind: data
project: quizapp
status: active
location: QuizApp:docs/REQUIREMENTS.md
fed_by: []
feeds: [check-traceability]
sources: [QuizApp:docs/REQUIREMENTS.md, QuizApp:docs/TESTING.md, QuizApp:core/src/test, QuizApp:app/src/test]
reviewed: 2026-11-07T18:40Z
---

## What it is
A requirement is a testable promise of the program, for example "a wrong answer on a new card comes back after 10 minutes". This catalogue lists every testable promise of [[quizapp]], each with an ID (SP-1 spacing, GR-1 grading, QU-1 queue, DG-* daily goal, QP-* question pool, FS-* the FSP (Fachsprachprüfung) cases, and so on; 38 rows on 2026-11-06), together with the test strategy in `docs/TESTING.md` (decision ADR-0008, "requirements-first quality assurance"; an ADR is an architecture decision record, a short note that keeps the reasons for a decision).

## What it does
It says what must hold and at which level each promise is tested: unit (one piece), integration (pieces together), property (many random inputs), cross-platform conformance (app and web agree), acceptance on a device, and mutation-checked. The generated file `docs/TRACEABILITY.md` maps each requirement to its tests.

FS-1 to FS-5 were added on 2026-11-06 for the FSP-Fälle mode, simulated cases of the German medical-language exam ([[fsp-case]]): FS-1 one 34-step template, 4 answers with one right and an explanation each, and a case that breaks it never reaches the app; FS-2 cases ordered by area of medicine; FS-3 a wrong answer explains itself and the player picks again, only first-try right steps count, shuffled answers, an end screen with the score per part and the diagnosis; FS-4 a whole case is one card, at least 80 % passes, time never changes the grade; FS-5 the title never names the diagnosis. FS-6 and FS-7 were added on 2026-11-07: FS-6 a case reads like the written script of the exam (no quiz question per step: the player's last line, then what the patient or senior doctor answers and does); FS-7 each solved step counts as one answered question for the daily goal and the streak, while the case stays one card. The web twin's tests carry these tags too ([[quizweb-fsp]]).

## How it does it
A behaviour Giovanni states becomes a row first; then a test tagged `REQ <ID>` is written; then the code. The [[check-traceability]] check fails when a requirement has no test.

## Where it sits in the pipeline
The first step of the [[quizapp-release]].

## Who receives its output
[[check-traceability]] and every test author.
