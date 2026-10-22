---
id: distractor-factory
title: DistractorFactory
aliases: [distractors, wrong options]
kind: function
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/content/DistractorFactory.kt
fed_by: []
feeds: [card-factory]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/content/DistractorFactory.kt]
---

## What it is
Makes the wrong options of each question: plausible, but never accidentally correct.

## What it does
Prepositions: drawn from common prepositions, excluding the answer and anything also valid. Plurals: from German plural patterns (-e, -en, -er, umlaut), with -n only after -e and -s only after vowels so fakes like 'Tischn' never appear. Präteritum: the regularised weak form, Partizip II, Präsens and infinitive.

## How it does it
Seeded from the entry, so a card always shows the same options (reproducible tests and bug reports).

## Where it sits in the pipeline
Inside the content pipeline, called by [[card-factory]].

## Who receives its output
[[card-factory]].
