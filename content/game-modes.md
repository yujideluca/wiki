---
id: game-modes
title: The five game modes
aliases: [GameMode, modes, Fehler finden, der die das]
kind: decision
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/GameMode.kt
fed_by: []
feeds: [card-factory]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/GameMode.kt, QuizApp:DESIGN.md]
reviewed: 2026-10-25T08:22Z
---

## What it is
These are the five ways [[quizapp]] and [[quizweb]] quiz B2-level German. All of them draw on a curated pool of what every B2 speaker should know; the pool can grow without an app update ([[question-pack]]), and the numbers below are those of the pool built into the app (content version 4, the pool published on 25 October 2026). A "game mode" is one kind of question.

## What it does
- **Der · Die · Das**: choose the article (the German word for "the", which depends on the noun's gender) of 484 nouns.
- **Präpositionen** (prepositions): fill the missing preposition in 309 sentences.
- **Pluralformen** (plural forms): give the plural of the same nouns.
- **Präteritum** (simple past): give the er/sie/es ("he/she/it") form of 253 verbs.
- **Fehler finden** (find the error): tap the one wrong part of 144 sentences in the style of forum posts or formal e-mails, built from the errors Giovanni made in corrected B2 mock exams.

## How it does it
Each mode is a `GameMode` value with a storage id. All of them produce the same `Card` shape through the [[card-factory]], so adding a mode is a small change. Only Fehler finden waits for a tap on "Next" (`autoAdvances = false`); the others move on by themselves after feedback.

## Where it sits in the pipeline
The menu of the home screen. The mode chosen decides which content files feed the [[card-factory]].

## Who receives its output
The [[card-factory]].
