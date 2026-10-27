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
sources: [QuizWeb:README.md, QuizWeb:src, QuizWeb:sw.js, QuizWeb:tests/bughunt.test.js, QuizWeb:pipeline-check.toml, QuizWeb:.github/workflows/test.yml]
reviewed: 2026-10-26T12:10Z
---

## What it is
QuizWeb is the web version of the German quiz, made so that it works on an iPhone. It is a PWA (progressive web app: a web page that can be installed on a phone like an app and keeps working offline, see [PWA](https://en.wikipedia.org/wiki/Progressive_web_app)), served by [[github-pages]]. The repository is `yujideluca/german-quiz-web` and the folder is `~/dev/QuizWeb`. It is the "web twin" of [[quizapp]].

## Flow
trigger t1: Giovanni opens QuizWeb in a browser, for example on an iPhone | [[github-pages]]
step s1: The service worker caches the app so it works offline | [[quizweb-service-worker]]
step s2: The controller runs a study session with the pure logic | [[quizweb-controller]], [[quizweb-domain]]
step s3: Questions and translations are loaded | [[quizweb-content]]
step s4: Progress is saved in the browser of that device | [[quizweb-store]]
product p1: Study sessions that work offline; Settings > Backup saves progress
trigger t2: The stable Android app changes its questions, translations or modes | [[quizapp]]
step s5: check-web-sync compares the files, the modes and the web clone's pushed state | [[check-web-sync]]
decide d1: Does the web twin match?
step s6: Ports the change, bumps the cache version, runs the tests, pushes
trigger t3: A push to the repository | [[quizweb-ci]]
step s7: Tests run, including who may import whom, plus the pipeline-check limits | [[pipeline-check]]
decide d2: Did everything pass?
step s8: GitHub Pages publishes the push within about a minute | [[github-pages]]
product p2: The twins are in step
product p3: A new version for every browser
product p4: Nothing is published

t1 -> s1
s1 -> s2
s2 -> s3
s3 -> s4
s4 -> p1
t2 -> s5
s5 -> d1
d1 -yes-> p2
d1 -no-> s6
s6 -> s7
t3 -> s7
s7 -> d2
d2 -yes-> s8
d2 -no-> p4
s8 -> p3

## What it does
It has the same five modes, scheduler, daily goal and streak calendar as [[quizapp]], and works offline. The progress lives in the browser of that device and is separate from the Android app; Settings > Backup saves and restores it.

## How it does it
It is plain JavaScript in ES modules (the standard way to split JavaScript into files), with no build step and no dependencies. The parts are: [[quizweb-domain]] (pure logic), [[quizweb-content]], [[quizweb-controller]], [[quizweb-store]] and [[quizweb-app]] (the last two are the only modules that touch the browser), plus the offline cache [[quizweb-service-worker]]. The test `tests/architecture.test.js` holds who may import whom, and [[quizweb-ci]] runs `npm test` and the limits of [[pipeline-check]] on every push.

## Where it sits in the pipeline
It is the twin of [[quizapp]] (decision ADR-0006 there; an ADR is an architecture decision record, a short note that keeps the reasons for a decision): it reads the same vocabulary files and the same conformance vectors, and [[check-web-sync]] in QuizApp compares them. A port of Android features that are still in beta waits on a branch `web-<version>` and is merged to `main` when the app is promoted.

## Who receives its output
Giovanni's iPhone, or any browser, through [[github-pages]].

## Notes

The standalone maintenance deployment of 2026-10-26 includes sharp-s search, the zero-goal progress calculation and backup-import checks. Its offline cache key is `v12`. Maintenance fixes can ship independently of another Android release; ports of unreleased Android features still wait on their app release. GitHub protects `main` by requiring the `test` check, including for administrators, and forbids force pushes and branch deletion. The maintenance commit passed all 81 tests and the GitHub Pages deployment.
