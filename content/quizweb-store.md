---
id: quizweb-store
title: QuizWeb store.js (localStorage)
aliases: [web storage]
kind: module
project: quizweb
status: active
location: QuizWeb:src/store.js
fed_by: []
feeds: [quizweb-controller]
sources: [QuizWeb:src/store.js]
---

## What it is
The browser storage of [[quizweb]]: progress, answer history, daily goal, theme and language in `localStorage`.

## What it does
Saves and loads everything; Settings > Backup exports and imports it, because it lives only in that device's browser.

## How it does it
Every access is guarded: Safari private mode can throw, and then the app keeps working from a memory copy for the session.

## Where it sits in the pipeline
Under [[quizweb-controller]].

## Who receives its output
[[quizweb-controller]].
