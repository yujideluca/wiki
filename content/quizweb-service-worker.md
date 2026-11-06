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
reviewed: 2026-11-06T23:20Z
---

## What it is
`sw.js` is the offline cache of [[quizweb]]. A [service worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) is a script that the browser runs in the background for a web page; it can answer requests from a saved copy, which is what lets the quiz work without a connection once it is installed.

## What it does
It caches every file of the app. It tries the network first and uses the cache only as the offline fallback, so a deploy shows up on the next open; after 4 seconds without an answer it uses the saved copy, so the app still opens quickly on a bad connection. The page reloads once when a new worker takes over.

## How it does it
When any cached file changes, the `VERSION` constant in the file must be raised, so installed copies notice the change and update. (It is an offline cache key: `v13` since the maintenance commit of 2026-11-06 on GitHub's `main`, and `v14` in the FSP-Fälle port (FSP: Fachsprachprüfung, the German medical-language exam) of the same day, on the branch `web-2.8.0`, which also caches `src/fsp.js` and `vocab/fsp_cases.json`; [[quizweb-fsp]].)

## Where it sits in the pipeline
Between [[github-pages]] and the browser.

## Who receives its output
The browser of Giovanni's iPhone.
