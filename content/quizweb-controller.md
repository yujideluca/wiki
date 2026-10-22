---
id: quizweb-controller
title: QuizWeb controller.js
aliases: [web StudyController]
kind: module
project: quizweb
status: active
location: QuizWeb:src/controller.js
fed_by: [quizweb-domain, quizweb-store]
feeds: [quizweb-app]
sources: [QuizWeb:src/controller.js]
---

## What it is
The application service of the web twin: the web counterpart of [[study-controller]].

## What it does
Wires deck, storage and clock to the pure functions of [[quizweb-domain]]: sessions, answers, suspension, search, daily progress, calendar.

## How it does it
No DOM; takes any store with the right shape (`createMemoryStore` in tests, [[quizweb-store]] in the browser).

## Where it sits in the pipeline
Between [[quizweb-app]] (UI) and [[quizweb-domain]].

## Who receives its output
[[quizweb-app]].
