---
id: vocab-tsv
title: Vocabulary source tables
aliases: [nouns.tsv, prepositions.tsv, verbs.tsv, errors.tsv, fsp_cases.tsv, tools/data/fsp]
kind: data
project: quizapp
status: active
location: QuizApp:tools/data
fed_by: []
feeds: [build-vocab, check-fsp-cases]
sources: [QuizApp:tools/data]
reviewed: 2026-11-07T13:23Z
---

## What it is
These are the human-editable source files of all the quiz content, as plain-text tables. Despite their `.tsv` names, their columns are separated by a vertical bar (`|`). They are `nouns.tsv` (484 nouns), `prepositions.tsv` (309 items), `verbs.tsv` (253 verbs) and `errors.tsv` (177 sentences for the "find the error" mode; 22 were added on 2026-11-06 for content version 7). Since 2026-11-06 there are also the simulated exam cases of the FSP-Fälle mode (FSP: Fachsprachprüfung, the German medical-language exam; [[fsp-case]]): the case list `fsp_cases.tsv` (58 cases, one line each, same bar-separated format) and one JSON (JavaScript Object Notation, a plain-text data format) file per case in the folder `fsp/`.

## What it does
They hold every word, its gender, plural, preposition and hint, and every error sentence together with its correction, the rule behind it and the expression it practises. Everything the app asks comes from here.

## How it does it
The files are edited by hand (by Claude, from Giovanni's word lists and corrected exams). A row with several possible prepositions needs a hint column. An error sentence marks exactly one wrong chunk with `{{ }}`. A script, [[build-vocab]], checks all of this before the data can reach the app; the case files are checked by [[check-fsp-cases]], which build_vocab calls.

## Where it sits in the pipeline
The very start of the content pipeline: Source tables (cases through [[check-fsp-cases]]) → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
[[build-vocab]] and [[check-fsp-cases]].
