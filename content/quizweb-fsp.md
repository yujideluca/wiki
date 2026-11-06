---
id: quizweb-fsp
title: QuizWeb fsp.js (FSP cases) and its tests
aliases: [web FSP cases, fsp.js, fsp.test.js]
kind: module
project: quizweb
status: active
location: QuizWeb:src/fsp.js
fed_by: [fsp-case]
feeds: [quizweb-app, quizweb-content, quizweb-controller]
sources: [QuizWeb:src/fsp.js, QuizWeb:tests/fsp.test.js, QuizWeb:tests/architecture.test.js, QuizWeb:src/app.js, QuizWeb:README.md]
reviewed: 2026-11-06T23:20Z
---

## What it is
`src/fsp.js` is part of [[quizweb]], the web twin (a browser version of the Android quiz app that must behave the same). It is that twin's copy of the rules for the FSP-Fälle mode: simulated cases of the FSP (Fachsprachprüfung, the German medical-language exam for foreign doctors). It is a port of `FspCase.kt` of the Android app, described in [[fsp-case]]. Like [[quizweb-domain]] it is pure: no page drawing (no DOM, Document Object Model, the browser's model of a page) and no clock. The file `tests/fsp.test.js` tests it.

## What it does
It grades a finished case from its score and never from time: at least 80 % of the steps right at the first pick passes (`GOOD`; on a card already in review at least 95 % is `EASY` and below 90 % `HARD`), below that is `AGAIN`. These are the four grades of the spaced-repetition scheduler, from worst to best AGAIN, HARD, GOOD, EASY: AGAIN brings the card back within minutes, the others push it further out. It also plays a case: a "run" is the state of one case being played, and every move returns a new run instead of changing the old one. A wrong pick is remembered, the player picks again, and only first-try right steps count. The order of the 4 answers of a step depends only on a seed, the case and the step, so it stays put while the player picks.

## How it does it
Its functions are listed below. Other modules use it as follows: [[quizweb-content]] makes one card per case (`fspCaseCard`, id `fsp:<id>`, choices `bestanden` and `nicht bestanden`), [[quizweb-controller]] starts and grades a case (`startCase`, `finishCase`), and [[quizweb-app]] draws the case player and the result card. The dependency rules of `tests/architecture.test.js` allow `fsp.js` to import only `domain.js`; `content.js`, `controller.js` and `app.js` may import it.

`tests/fsp.test.js` carries the requirement tags FS-1 to FS-5, SP-1, SP-2 and WB-1 of the app's list ([[quizapp-requirements]]; a requirement is a testable promise with an ID such as FS-4, and a tag `REQ <ID>` in a test file links the test to the promise it proves). It ports the app's `FspCaseTest` and `FspCaseControllerTest` in 16 tests: the mode is `fsp` and waits for a tap; one card per case in file order; areas never come back once left; every case in `vocab/fsp_cases.json` follows the template (16 + 7 + 11 steps, 5 of them Fachbegriffe, one right answer of 4); a step with the wrong shape is refused; the title never names the diagnosis; wrong picks and retries; a stable shuffled answer order; score and part scores; the grading boundaries (28 of 34 steps passes, 27 fails, because 80 % of 34 is 27.2); the grade override and its refusal of a grade that contradicts right or wrong; a passed case returns three days later however long it took; a failed one after ten minutes; a review case at 80 % is `HARD`; an unfinished or foreign case is ignored. A comment in the test says the app's test asserts that 27 of 34 passes; the app's `FspCaseTest` read on 2026-11-06 asserts the opposite (28 passes, 27 fails), so that comment is out of date. On 2026-11-06 `npm test` passed all 98 tests.

## Where it sits in the pipeline
Between the shared case file `vocab/fsp_cases.json` (a copy of the app's, compared by [[check-web-sync]]) and the content, controller and screen modules of [[quizweb]]. The port is commit `fa59829` and waits on the git branch `web-2.8.0` (a separate line of work) until the Android version 2.8.0 is promoted from the beta channel to the stable one that users get; on 2026-11-06 the web `main` on GitHub was still at `4189b7a`.

## Who receives its output
[[quizweb-content]], [[quizweb-controller]] and [[quizweb-app]].

## Functions
- `FSP_PASSED`, `FSP_FAILED`, `FSP_PASS_SCORE` (0.8): the two choices of a case card and the pass mark
- `checkFspCase`: throws when a step lacks 4 answers and 4 explanations or has an answer index out of range
- `fspPassed`, `fspGrade`: pass test and grade from score and card phase
- `startRun`, `isRunFinished`, `runStep`, `runOrder`: a new run, whether it is over, the current step, the shown answer order
- `pick`, `nextStep`: pick an answer (ignored after solving, for a repeated wrong pick or an invalid index); move on (only after solving)
- `runScore`, `partScores`: share of first-try right steps over all steps; right and total per exam part over the finished steps
