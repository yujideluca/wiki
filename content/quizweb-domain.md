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
---

## What it is
`domain.js` is the pure logic of [[quizweb]], ported from the domain package of the Android app: the scheduler, grader, queue pipeline, session engine, daily goal and calendar. "Pure" means the same input always gives the same output and nothing else is touched.

## What it does
It behaves exactly like the [[spaced-repetition-scheduler]], the [[answer-grader]] and the [[study-pipeline]] of the app. `MODES` lists the five modes.

## How it does it
It has no DOM (Document Object Model, the browser's model of a web page), no storage and no access to the clock. It is proven equal to the app by the shared vectors of [[quizweb-conformance]] and by the [[mutation-check]].

## Where it sits in the pipeline
The inner layer of the web twin; only the [[quizweb-controller]] calls it.

## Who receives its output
The [[quizweb-controller]].
