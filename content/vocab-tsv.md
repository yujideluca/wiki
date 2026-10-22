---
id: vocab-tsv
title: Vocabulary source files (TSV)
aliases: [nouns.tsv, prepositions.tsv, verbs.tsv, errors.tsv]
kind: data
project: quizapp
status: active
location: QuizApp:tools/data
fed_by: []
feeds: [build-vocab]
sources: [QuizApp:tools/data]
---

## What it is
The human-editable source of truth for the quiz content: `nouns.tsv` (484 nouns), `prepositions.tsv` (309 items), `verbs.tsv` (253 verbs) and `errors.tsv` (121 Fehler-finden sentences).

## What it does
Hold every word, its gender, plural, preposition and hint, and every error sentence with its fix, rule and the expression it practises.

## How it does it
Edited by hand (by Claude, from Giovanni's lists and corrected exams); a row with several prepositions needs a hint column; an error sentence marks exactly one wrong chunk with `{{ }}`.

## Where it sits in the pipeline
The very start of the content pipeline: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
[[build-vocab]].
