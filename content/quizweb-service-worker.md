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
reviewed: 2026-10-22T16:33Z
---

## What it is
`sw.js` is the offline cache of [[quizweb]]. A [service worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) is a script that the browser runs in the background for a web page; it can answer requests from a saved copy, which is what lets the quiz work without a connection once it is installed.

## What it does
It caches every file of the app. It tries the network first and uses the cache only as the offline fallback, so a deploy shows up on the next open. The page reloads once when a new worker takes over.

## How it does it
When any cached file changes, the `VERSION` constant in the file must be raised, so installed copies notice the change and update. (It is only a cache key; QuizWeb has no version of its own.)

## Where it sits in the pipeline
Between [[github-pages]] and the browser.

## Who receives its output
The browser of Giovanni's iPhone.
