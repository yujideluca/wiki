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
---

## What it is
The five ways [[quizapp]] and [[quizweb]] quiz B2 German, all on a fixed pool of what every B2 speaker should know.

## What it does
Der · Die · Das (article of 484 nouns), Präpositionen (309 sentences with a missing preposition), Pluralformen (plural of the same nouns), Präteritum (er/sie/es form of 253 verbs), Fehler finden (tap the one wrong chunk of 121 forum-post or formal e-mail sentences, built from errors Giovanni made in corrected B2 mock exams).

## How it does it
Each mode is a `GameMode` value with a storage id; all produce the same `Card` shape through [[card-factory]], so a new mode is a small addition. Only Fehler finden waits for a Next tap (`autoAdvances = false`).

## Where it sits in the pipeline
The menu of the home screen; they decide which content files feed [[card-factory]].

## Who receives its output
[[card-factory]].
