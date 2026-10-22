---
id: quizweb
title: QuizWeb (German Quiz, web)
aliases: [german-quiz-web, web twin]
kind: project
project: none
status: active
location: QuizWeb:
fed_by: [claude-code, quizapp]
feeds: [check-web-sync, github-pages]
sources: [QuizWeb:README.md, QuizWeb:src]
---

## What it is
The iPhone-friendly web version of the German quiz: a PWA (a web page that can be installed like an app) served by [[github-pages]]. Repo `yujideluca/german-quiz-web`, folder `~/dev/QuizWeb`.

## What it does
Same five modes, scheduler, daily goal and streak calendar as [[quizapp]], offline. Progress lives in the browser of that device and is separate from the Android app; Settings > Backup saves and restores it.

## How it does it
Plain ES modules, no build step and no dependencies: [[quizweb-domain]] (pure logic), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] and [[quizweb-app]] (the only modules that touch the browser), plus the offline cache [[quizweb-service-worker]]. `tests/architecture.test.js` holds who may import whom; [[quizweb-ci]] runs `npm test` on every push.

## Where it sits in the pipeline
The twin of [[quizapp]] (ADR-0006 there): it reads the same vocabulary files and the same conformance vectors, and [[check-web-sync]] in QuizApp compares them. A port of an app version still in beta waits on a branch `web-<version>` and is merged to `main` when the app is promoted.

## Who receives its output
Giovanni's iPhone or any browser, through [[github-pages]].
