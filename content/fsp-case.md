---
id: fsp-case
title: FSP cases (FspCase, the FSP-Fälle mode)
aliases: [FSP-Fälle, FspCase, FspCaseRun, FspGrading, fsp_cases.json, FSP case template]
kind: module
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/content/FspCase.kt
fed_by: [check-fsp-cases]
feeds: [card-factory, quizweb-fsp, study-controller]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/FspCase.kt, QuizApp:docs/adr/0014-fsp-case-simulations.md, QuizApp:docs/REQUIREMENTS.md, QuizApp:tools/data/fsp_cases.tsv, QuizApp:tools/data/fsp, QuizApp:app/src/main/assets/vocab/fsp_cases.json, QuizApp:app/src/main/java/dev/yuji/quiz/ui/FspCaseScreen.kt, QuizApp:core/src/test/java/dev/yuji/quiz/content/FspCaseTest.kt, QuizApp:app/src/test/java/dev/yuji/quiz/FspCaseControllerTest.kt, QuizApp:DESIGN.md]
reviewed: 2026-11-08T00:15Z
---

## What it is
"FSP-Fälle" (cases of the FSP, Fachsprachprüfung, the German medical-language exam that foreign doctors take before they may work in Germany; see [[glossary]]) is the sixth study mode of [[quizapp]] (an Android app for drilling German; the other five drill B2-level vocabulary and grammar, [[game-modes]]), added in version 2.8.0 on 2026-11-06. The exam is held by each state's medical chamber. The mode simulates the Baden-Württemberg format. Each case is one imagined patient. The player goes through the whole exam step by step and, at every step, picks what a doctor should say to the patient, write in the doctor's letter or tell the senior doctor. The file `FspCase.kt` in [[quizapp-core]] holds the data shapes of a case and the rules for playing and grading it. The decision is ADR-0014 (an ADR is an architecture decision record, a short note that keeps the reasons for a decision; [[quizapp-adrs]]).

## What it does
The pool has 58 cases in 12 areas of medicine (Kardiologie, Pneumologie, Gastroenterologie, Allgemein- und Viszeralchirurgie, Neurologie, Infektiologie, Angiologie, Unfallchirurgie/Orthopädie, Endokrinologie, Hämatologie/Onkologie, Nephrologie/Urologie, Psychiatrie). New cases come in the order of the case list, so the areas come one after the other (requirement FS-2).

Every case has the same 34 steps in the same order (FS-1), split like the real exam:
- **Part 1, Arzt-Patienten-Gespräch** (doctor–patient conversation, the history taking), 16 steps: from the greeting through the history (complaint, course, other symptoms, past illnesses, medicines, allergies, family and social history) to explaining the suspected diagnosis and the next steps.
- **Part 2, Dokumentation** (writing the Arztbrief, the doctor's letter), 7 steps.
- **Part 3, Arzt-Arzt-Gespräch** (handing the patient over to a senior doctor), 6 steps, followed by 5 "Fachbegriffe" (technical terms) steps: a medical term to explain in everyday German, asked as `Was bedeutet „<term>“?`.

Each step offers 4 answers, exactly one right, and a German explanation for each answer. A wrong pick turns red and shows its explanation; the player picks again until the right answer (FS-3). **Since 2026-11-07 (version 2.9.0) a case reads like the written script of the exam** (FS-6): a step never asks a quiz question such as "Wie fragen Sie nach …?". It shows the line the player chose last ("Sie: „…“"), then what the patient or the senior doctor answers and does, or in part 2 what the player is now writing, and the player picks what to say or write next. Without a question each step still has one clearly right answer: the scene gives cues (a gesture, a nurse calling from the door, an empty field on the admission form) and the wrong answers are wrong in themselves (jargon to a patient, suggestive, rude, medically wrong). Only a step that was right at the first pick counts. At the end a result screen shows the share right at the first try, the score per part and the diagnosis. The case title shown before and during the case names the complaint, never the diagnosis (FS-5); for example the case "akute-cholezystitis" is titled "Schmerzen im rechten Oberbauch" (pain in the upper right abdomen).

## How it does it
**A whole case is one card** for the spaced-repetition scheduler (the part that decides when a question comes back, [[spaced-repetition-scheduler]]): card id `fsp:<case id>`, with the two "choices" `bestanden` (passed) and `nicht bestanden` (not passed), made by `CardFactory.fspCaseCard` ([[card-factory]]). So the usual spacing rules apply to whole cases: in the tests a passed new case returns three days later and a failed one after ten minutes. **Each solved step counts for the day** (FS-7): the daily goal and the streak calendar count every step the player solves as one answered question (`StudyController.pickInCase`), and the graded case adds none of its own, so a whole case adds 34. **The grade comes from the score, never from the time** (FS-4): score = steps right at the first pick ÷ all 34 steps. At least 80 % is a pass. The scheduler knows four grades, from worst to best: AGAIN (wrong, the card comes back within minutes), HARD, GOOD and EASY (each pushes the next showing further out). Because 80 % of 34 is 27.2, 28 steps right is the least that passes. A pass is graded GOOD; on a card already in review (one that has been learned and is shown again after days or weeks), at least 95 % is EASY and below 90 % is HARD. Below 80 % is AGAIN. For other modes the grade comes from whether the answer was right and how fast it came ([[answer-grader]]); here the [[study-controller]] hands the score-based grade to the [[study-session]] engine as a `gradeOverride` (a grade that replaces the time-based one).

**The data.** The list of cases is `tools/data/fsp_cases.tsv`, one line per case: `id|area|diagnosis|leitsymptom|source|bwReports` (the leading symptom; the source is `reported_BW` or `common_FSP`; `bwReports` counts exam reports from Baden-Württemberg). A web search on 2026-11-06 found no public Baden-Württemberg exam report that names a case, so all 58 cases are classic FSP cases tagged `common_FSP` with `bwReports` 0. Each case is one [JSON](https://en.wikipedia.org/wiki/JSON) file (JavaScript Object Notation, a plain-text data format) in `tools/data/fsp/<id>.json` with the fields `id, area, title, diagnosis, source, bwReports, patient, steps`; each step has `part, section, situation, options, answer, feedback, reply` (`answer` is the index of the right option, from 0 to 3; `reply` is set only on the last step of a part). [[check-fsp-cases]] checks every file against the template, and [[build-vocab]] writes all cases, in list order, into `assets/vocab/fsp_cases.json` ([[vocab-assets]]). That file is part of the question pack, the set of question files the app can also download without an app update; the pack's format number (its "schema") was raised from 1 to 2 for it and to 3 for the script format of 2026-11-07, so older apps ignore the new pack ([[question-pack]]). The case texts are German only, the exam language; only the screen labels are translated.

**Authoring.** One reference case (`akute-cholezystitis.json`) was written by hand; the other 57 were written by one Sonnet agent each (a Claude model run as a helper) against the reference and the checker ([[check-fsp-cases]]), then reviewed by a second Sonnet agent acting as a strict German physician and language examiner. The check catches structure, not meaning: medical or language errors in the texts remain possible and are fixed in the case file and shipped as a pool update.

**The screen.** The case screen of [[quizapp-app]] (`FspCaseBody` and its result card) draws the step (part and section, a progress bar, "Step n of 34", the player's last line within the same conversation, the situation, the 4 answers in a shuffled order that stays fixed within the step) and the result card. The answers are rounded rectangles rather than pills, because answers of several lines were clipped by the pill shape.

## Where it sits in the pipeline
Case files ([[vocab-tsv]]) → [[check-fsp-cases]] → [[build-vocab]] → `fsp_cases.json` in the pack → this module and the [[card-factory]] → [[study-controller]] and [[study-view-model]] → the screen. The web twin (QuizWeb, a browser version of the app that must behave the same, [[quizweb]]) has a port of this file, [[quizweb-fsp]].

## Who receives its output
The [[card-factory]] (one card per case), the [[study-controller]] (playing and grading a case) and the web port [[quizweb-fsp]].

## Functions
- `FspCase`, `FspStep`: the shape of a case and of one step; a step without 4 options and 4 explanations, or with an answer index out of range, is refused when the file is read
- `parseFspCases`: JSON text to a list of cases (unknown fields are ignored)
- `FSP_PASSED`, `FSP_FAILED`: the two choices of a case card, `bestanden` and `nicht bestanden`
- `FSP_PASS_SCORE` (0.8) and `FspGrading.passed` / `FspGrading.grade`: pass at 80 %; grade from the score and the card's phase (EASY from 95 % and HARD below 90 %, both only on a review card)
- `FspCaseRun`: a case being played, as an unchangeable value (every move returns a new one): `pick` (ignored after the step is solved and for a repeated wrong pick), `next` (only after solving), `order` (the shown order of the answers, seeded per case and step), `score` and `partScores`
- Tests: `FspCaseTest` (template, order, run, score, grading) and `FspCaseControllerTest` (order of new cases, three days after a pass, ten minutes after a fail, no effect of time, review grading); 6 of the planted faults of the [[mutation-check]] (deliberate small breaks of the code that a test must notice) are in this file
