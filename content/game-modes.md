---
id: game-modes
title: The six game modes
aliases: [GameMode, modes, Fehler finden, der die das, FSP-Fälle]
kind: decision
project: quizapp
status: active
location: QuizApp:core/src/main/java/dev/yuji/quiz/domain/GameMode.kt
fed_by: []
feeds: [card-factory]
sources: [QuizApp:core/src/main/java/dev/yuji/quiz/domain/GameMode.kt, QuizApp:DESIGN.md, QuizApp:app/src/main/assets/content.json, QuizApp:docs/adr/0014-fsp-case-simulations.md]
reviewed: 2026-11-07T00:37Z
---

## What it is
These are the six ways [[quizapp]] and [[quizweb]] quiz German. Five drill B2-level German from a curated pool of what every B2 speaker should know; the sixth, FSP-Fälle (FSP: Fachsprachprüfung, the German medical-language exam), added in app version 2.8.0 on 2026-11-06, prepares the medical German exam that follows B2. The pool can grow without an app update ([[question-pack]]); the numbers below are those of the pool built into version 2.8.0 (content version 8). A "game mode" is one kind of question.

## What it does
- **Der · Die · Das**: choose the article (the German word for "the", which depends on the noun's gender) of 484 nouns.
- **Präpositionen** (prepositions): fill the missing preposition in 309 sentences.
- **Pluralformen** (plural forms): give the plural of the same nouns.
- **Präteritum** (simple past): give the er/sie/es ("he/she/it") form of 253 verbs.
- **Fehler finden** (find the error): tap the one wrong part of 177 sentences in the style of forum posts or formal e-mails, built from the errors Giovanni made in corrected B2 mock exams (22 of them added on 2026-11-06 for content version 7).
- **FSP-Fälle** (FSP cases): play 58 simulated cases of the FSP exam (taken by foreign doctors), Baden-Württemberg format, in 12 areas of medicine. In each of 34 steps the player picks what to say to the patient, write in the doctor's letter or tell the senior doctor; a wrong pick explains why and the player picks again. A whole case is one card, passed with at least 80 % right at the first try ([[fsp-case]]).

## How it does it
Each mode is a `GameMode` value with a storage id. All of them produce the same `Card` shape through the [[card-factory]], so adding a mode is a small change. Fehler finden and FSP-Fälle (storage id `fsp`, value `FSP_CASE`) wait for a tap on "Next" (`autoAdvances = false`); the others move on by themselves after feedback. FSP-Fälle is the one mode whose card is not a single question: the card stands for a whole case, which is played step by step ([[fsp-case]]).

## Where it sits in the pipeline
The menu of the home screen. The mode chosen decides which content files feed the [[card-factory]].

## Who receives its output
The [[card-factory]].
