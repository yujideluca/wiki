---
id: quizweb-service-worker
title: QuizWeb service worker (offline cache)
aliases: [sw.js, offline]
kind: module
project: quizweb
status: active
location: QuizWeb:sw.js
fed_by: []
feeds: []
sources: [QuizWeb:sw.js]
---

## What it is
`sw.js`: the offline cache that lets the web quiz work without a connection once installed.

## What it does
Caches every file of the app; network first, cache only as the offline fallback; the page reloads once when a new worker takes over, so a deploy shows on the next open.

## How it does it
When any cached file changes, `VERSION` must be bumped so installed copies update.

## Where it sits in the pipeline
Between [[github-pages]] and the browser.

## Who receives its output
The browser of Giovanni's iPhone.
