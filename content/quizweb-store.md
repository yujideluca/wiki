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
reviewed: 2026-10-22T16:33Z
---

## What it is
`store.js` is the browser storage of [[quizweb]]. It keeps progress, answer history, daily goal, theme and language in `localStorage` ([localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) is a small key-value storage that every browser offers to a web page).

## What it does
It saves and loads everything. Because the data lives only in that device's browser, Settings > Backup exports and imports it.

## How it does it
Every access is guarded: Safari's private mode can throw an error on storage, and then the app keeps working from a copy in memory for that session instead of crashing.

## Where it sits in the pipeline
Under the [[quizweb-controller]].

## Who receives its output
The [[quizweb-controller]].
