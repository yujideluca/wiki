---
id: quizweb-app
title: QuizWeb app.js (UI)
aliases: [web UI]
kind: module
project: quizweb
status: active
location: QuizWeb:src/app.js
fed_by: [quizweb-content, quizweb-controller, quizweb-i18n]
feeds: [github-pages]
sources: [QuizWeb:src/app.js, QuizWeb:index.html, QuizWeb:style.css]
---

## What it is
The UI layer of [[quizweb]]: renders the screens and wires taps to the controller.

## What it does
Home (calendar, daily goal, modes), questions with feedback and 0.5 s auto-advance, settings, backup, removed-cards list with search.

## How it does it
Plain DOM; with [[quizweb-store]] it is the only code that touches the browser (an architecture test enforces it). All logic lives in [[quizweb-domain]].

## Where it sits in the pipeline
The top of the web twin, served by [[github-pages]].

## Who receives its output
Giovanni, in the browser.
