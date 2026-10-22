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
The pure logic of [[quizweb]], ported from the Android app's domain package: scheduler, grader, queue pipeline, session engine, daily goal and calendar.

## What it does
Behaves exactly like [[spaced-repetition-scheduler]], [[answer-grader]] and [[study-pipeline]]; `MODES` lists the five modes.

## How it does it
No DOM, no storage, no clock access; proven equal to the app by the shared vectors of [[quizweb-conformance]] and by [[mutation-check]].

## Where it sits in the pipeline
The inner layer of the web twin; only [[quizweb-controller]] calls it.

## Who receives its output
[[quizweb-controller]].
