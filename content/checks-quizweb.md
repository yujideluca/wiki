---
id: checks-quizweb
title: QuizWeb: checkers and rules
aliases: [german-quiz-web checks, QuizWeb gate]
kind: decision
project: quizweb
status: active
fed_by: []
feeds: []
sources: [QuizWeb:tools/quality_gate.sh, QuizWeb:pipeline-check.toml, QuizWeb:.github/workflows/test.yml, QuizWeb:tests/architecture.test.js, QuizWeb:tests/fsp.test.js]
reviewed: 2026-11-06T23:20Z
---

## What it is
These are the checkers of [[quizweb]], the web twin of the quiz app: a web page installable as a PWA (progressive web app) that must behave like the Android app.

## What it does
The gate has two steps: `npm test` (the plain Node test runner, no dependencies) and `pipeline-check --measure-only`. The test files are domain, controller, daily-bar, content, i18n, conformance, bughunt, architecture and, since 2026-11-06, fsp (the simulated FSP exam cases, FSP being the Fachsprachprüfung, the German medical-language exam; [[quizweb-fsp]]); `npm test` ran 98 tests, all passing, on 2026-11-06. The architecture test is a fitness function written as a test: each source module has an entry in an allow-list of who may import whom, so a new file needs a conscious entry (`fsp.js` got one: it may import only `domain.js`); only `app.js` may touch the page and only `store.js` the browser storage. Limits: no JavaScript file over 600 lines in `src/`, the gate at most 300 seconds. The conformance vectors are shared with the app; the app's gate compares them byte for byte ([[quizweb-conformance]]).

## How it does it
The CI (continuous integration) workflow is called `test` (not `gate`), and the required check in `pipeline-check.toml` is `test` ([[quizweb-ci]]). The web project has no traceability section: its promises are tracked in QuizApp's list, whose traceability step reads the web test folder (label `web`, folder named by `QUIZWEB_TESTS`). A version bump of `sw.js` (the service worker, [[quizweb-service-worker]]) is part of every port.

## Where it sits in the pipeline
It is a layer-3 page of [[code-security-pipeline]]: the shared ideas are in [[quality-gate-explained]] and the whole list is in [[checker-catalog]].

## Who receives its output
Readers who need to know what protects this project, and the session that changes it.
