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
These are the human-editable source files of all the quiz content, in TSV format (tab-separated values: a plain text table where the columns are separated by a tab character, see [TSV](https://en.wikipedia.org/wiki/Tab-separated_values)). They are `nouns.tsv` (484 nouns), `prepositions.tsv` (309 items), `verbs.tsv` (253 verbs) and `errors.tsv` (121 sentences for the "find the error" mode).

## What it does
They hold every word, its gender, plural, preposition and hint, and every error sentence together with its correction, the rule behind it and the expression it practises. Everything the app asks comes from here.

## How it does it
The files are edited by hand (by Claude, from Giovanni's word lists and corrected exams). A row with several possible prepositions needs a hint column. An error sentence marks exactly one wrong chunk with `{{ }}`. A script, [[build-vocab]], checks all of this before the data can reach the app.

## Where it sits in the pipeline
The very start of the content pipeline: TSV → [[build-vocab]] → [[vocab-assets]] → [[card-factory]].

## Who receives its output
[[build-vocab]].
