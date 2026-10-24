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
`app.js` is the user-interface layer of [[quizweb]]: it draws the screens and connects taps to the controller. (Together with `index.html` and `style.css` it is what the browser actually shows.)

## What it does
It shows the home screen (calendar, daily goal, modes), the questions with feedback and a 0.5-second automatic advance, the settings, the backup, and the list of removed cards with a search box.

## How it does it
It works directly on the DOM (Document Object Model: the browser's live model of a web page, see [the documentation](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)), with no framework. Together with the [[quizweb-store]] it is the only code that touches the browser, and an architecture test enforces that. All the logic lives in [[quizweb-domain]].

## Where it sits in the pipeline
The top of the web twin, served by [[github-pages]].

## Who receives its output
Giovanni, in the browser.
