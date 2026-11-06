---
id: quizweb-controller
title: QuizWeb controller.js
aliases: [web StudyController]
kind: module
project: quizweb
status: active
location: QuizWeb:src/controller.js
fed_by: [quizweb-domain, quizweb-fsp, quizweb-store]
feeds: [quizweb-app]
sources: [QuizWeb:src/controller.js]
reviewed: 2026-11-06T23:20Z
---

## What it is
`controller.js` is the application service of the web twin: the counterpart of the [[study-controller]] of the Android app. An application service is the layer that coordinates storage, logic and clock without drawing anything.

## What it does
It connects the deck, the storage and the clock to the pure functions of [[quizweb-domain]]: sessions, answers, suspending cards, search, daily progress and the calendar. For the FSP-Fälle mode (simulated cases of the FSP, Fachsprachprüfung, the German medical-language exam; [[quizweb-fsp]]) it holds the cases by id, given as a fourth constructor argument; `startCase` starts a run of the case behind the current card, seeded with the clock, and `finishCase` answers that card with `bestanden` or `nicht bestanden` and the grade from the score and the card's phase (`record` passes it to `answer` as a grade override).

## How it does it
It has no DOM (Document Object Model, the browser's model of a web page). It takes any store with the right shape: `createMemoryStore` in the tests and the [[quizweb-store]] in the browser. That is why it can be tested without a browser. The clock is a function passed in (`Date.now` by default), so tests can fix the time. `currentMonth` turns today's day number into a month with `DAY_MILLIS` from [[quizweb-domain]].

## Where it sits in the pipeline
Between [[quizweb-app]] (the screens) and [[quizweb-domain]].

## Who receives its output
[[quizweb-app]].

## Notes

`importData` refuses backups whose progress or history is null or an array, and refuses a numeric format version newer than 1. It keeps progress entries only when their card identifier matches the entry key, and history counts only when they are positive integers. Invalid individual entries are skipped; this is filtering rather than a complete validation of every progress field.
