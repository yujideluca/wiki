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
The `DistractorFactory` makes the wrong answer options of each question. A "distractor" must be plausible enough to make the player think, but never accidentally correct.

## What it does
For prepositions, it draws from the common prepositions, excluding the right answer and anything else that would also fit. For plurals, it uses German plural patterns (-e, -en, -er, umlaut), with -n only after -e and -s only after vowels, so that fakes like "Tischn" never appear. For the Präteritum, it offers the regularised weak form, the past participle (Partizip II), the present tense (Präsens) and the infinitive.

## How it does it
The choice is "seeded" from the entry (a fixed starting number for the random choice), so a card always shows the same options. That makes tests and bug reports reproducible.

## Where it sits in the pipeline
Inside the content pipeline, called by the [[card-factory]].

## Who receives its output
The [[card-factory]].
