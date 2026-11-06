---
id: check-fsp-cases
title: check_fsp_cases.py
aliases: [FSP case validator, FSP template check]
kind: script
project: quizapp
status: active
location: QuizApp:tools/check_fsp_cases.py
fed_by: [vocab-tsv]
feeds: [build-vocab, fsp-case, quizapp-quality-gate]
sources: [QuizApp:tools/check_fsp_cases.py, QuizApp:tools/build_vocab.py, QuizApp:tools/quality_gate.sh, QuizApp:docs/adr/0014-fsp-case-simulations.md]
reviewed: 2026-11-06T23:20Z
---

## What it is
`check_fsp_cases.py` is the script that checks the simulated exam cases of the FSP-Fälle mode of [[quizapp]] before they can reach the app. FSP stands for Fachsprachprüfung, the German medical-language exam for foreign doctors; the cases and the mode are described in [[fsp-case]]. Every case must follow one fixed template of 34 steps (decision ADR-0014; an ADR is an architecture decision record, a short note that keeps the reasons for a decision), and this script is what enforces it (requirement FS-1).

## What it does
For each case file `tools/data/fsp/<id>.json` it checks:
- the case has exactly the fields `id, area, title, diagnosis, source, bwReports, patient, steps`, in this order; the `id` equals the file name and appears in the case list `tools/data/fsp_cases.tsv`, and `area`, `source` and `bwReports` agree with that list; `source` is `reported_BW` or `common_FSP`;
- the title does not give away the diagnosis: no word of six letters or more from the diagnosis may appear in the title, except "akute", "akuter", "akutes" and "chronische" (FS-5);
- exactly 34 steps, each with the expected part and section name in the template's order (part 1, the doctor–patient conversation: 16 sections from "Begrüßung" (greeting) to "Weiteres Vorgehen" (next steps); part 2, the doctor's letter: 7 sections from "Einleitung" (opening) to "Procedere" (plan); part 3, the handover to a senior doctor: 6 sections from "Übergabe beginnen" (start the handover) to "Rückfrage" (answering the senior doctor's question), then 5 times "Fachbegriffe" (technical terms to explain in everyday German));
- each step has the fields `part, section, situation, question, options, answer, feedback, reply` in this order, a non-empty question, 4 different non-empty answers of at most 420 characters, an `answer` from 0 to 3 and 4 explanations; only the explanation of the right answer starts with "Richtig";
- a Fachbegriffe question reads exactly `Was bedeutet „<term>“?`;
- the right answer is the longest of the four in at most 60 % of the 29 steps before the Fachbegriffe, so a player cannot pass by always tapping the longest answer.

Run without arguments it checks every case file and also reports cases in the list that have no file. It prints one line per problem and a summary, and exits with code 1 when there is any problem. On 2026-11-06 it printed `58 case file(s) checked, 0 problem(s)`.

## How it does it
A [Python](https://www.python.org/) script using only its standard library. `check_fsp_cases.py FILE...` checks only the named files, which helps a case author. [[build-vocab]], the script that turns the hand-edited source files into the app's data files, imports it: every case in the list must exist and pass, a case file missing from the list is an error too, and the cases are then written in list order into `assets/vocab/fsp_cases.json`. The [[quizapp-quality-gate]] (the one script that decides whether the project passes, run before every release and on every push) runs it again in its step 7 as `python3 -I tools/check_fsp_cases.py` (`-I` runs Python in isolated mode, which ignores the user's environment). It checks structure only, not whether the medicine or the German is right.

## Where it sits in the pipeline
Between the case files ([[vocab-tsv]]) and [[build-vocab]]; again in the [[quizapp-quality-gate]].

## Who receives its output
[[build-vocab]] (which refuses to build on a problem), the [[quizapp-quality-gate]], and the author of a case.
