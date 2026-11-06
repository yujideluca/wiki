---
id: quizweb-domain
title: QuizWeb domain.js
aliases: [web domain]
kind: module
project: quizweb
status: active
location: QuizWeb:src/domain.js
fed_by: []
feeds: [quizweb-controller]
sources: [QuizWeb:src/domain.js]
reviewed: 2026-11-06T23:20Z
---

## What it is
`domain.js` is the pure logic of [[quizweb]], ported from the domain package of the Android app: the scheduler, grader, queue pipeline, session engine, daily goal and calendar. "Pure" means the same input always gives the same output and nothing else is touched.

## What it does
It behaves exactly like the [[spaced-repetition-scheduler]], the [[answer-grader]] and the [[study-pipeline]] of the app. `MODES` lists the modes: six since 2026-11-06 (on the branch `web-2.8.0`), the sixth being `fsp`, the simulated exam cases of [[quizweb-fsp]], which waits for a tap like `errors` (`autoAdvances: false`). `answer` takes an optional grade override for that mode and throws an error when the grade contradicts right or wrong (`AGAIN` exactly when wrong).

## How it does it
It has no DOM (Document Object Model, the browser's model of a web page), no storage and no access to the clock. Time constants sit at the top of the file (`MINUTE_MILLIS`, `DAY_MILLIS` = 86,400,000 milliseconds in a day), next to one shared `clamp` helper (it keeps a number between a lower and an upper limit) used by the screen-scale calculation, the scheduler, daily progress and the calendar's heat colour. It is proven equal to the app by the shared vectors of [[quizweb-conformance]] and by the [[mutation-check]].

## Where it sits in the pipeline
The inner layer of the web twin; only the [[quizweb-controller]] calls it.

## Who receives its output
The [[quizweb-controller]].

## Notes

`foldForSearch` converts `ß` to `ss`, so `strasse` can match `Straße`. For a zero daily goal, `dailyProgress` returns fraction 0 without answers and 1 after any answer, avoiding division by zero. The release regression tests cover both cases.
