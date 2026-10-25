---
id: quizapp
title: QuizApp (German Quiz, Android)
aliases: [German Quiz, Deutsch B2, german-quiz]
kind: project
project: none
status: active
location: QuizApp:
fed_by: [claude-code, project-template]
feeds: [quizweb]
sources: [QuizApp:DESIGN.md, QuizApp:CLAUDE.md]
reviewed: 2026-10-25T07:34Z
---

## What it is
QuizApp ("German Quiz") is an Android app that Giovanni uses to drill German for the B2 level of the Goethe exam. It works offline and uses spaced repetition in the style of [Anki](https://apps.ankiweb.net/): a method in which questions you answer well come back after longer and longer gaps, and questions you get wrong come back soon ([spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition)). The repository is `yujideluca/german-quiz`, the folder is `~/dev/QuizApp`, and the app's package name is `dev.yuji.quiz`. It is also the reference project for how Giovanni's projects are built.

## What it does
It offers five study modes over a curated pool of B2 content ([[game-modes]]): der/die/das, prepositions, plural forms, Präteritum (the German simple past) and "Fehler finden" (find the error). Wrong or slow answers return soon; known cards move out to days, weeks and months ([[spaced-repetition-scheduler]]). It has a daily goal and a streak calendar ([[daily-goal]], [[activity-calendar]]), a backup of progress ([[progress-backup]]) and updates from inside the app ([[update-client]]). Since 2026-10-22 the question pool can grow without a new app release: new [[question-pack]]s arrive from the update feed ([[question-pool-updater]], [[publish-content]]).

## How it does it
It is written in [Kotlin](https://kotlinlang.org/) with [Jetpack Compose](https://developer.android.com/compose) (Android's modern way of drawing screens), split into two Gradle modules (parts built separately): [[quizapp-core]] (pure Kotlin logic: scheduler, grader, queue, session, content) and [[quizapp-app]] (Android screens, storage, updates). The content is built from tab-separated text files by [[build-vocab]]. Every change goes requirement → test → code, passes the [[quizapp-quality-gate]], and reaches the phone through the beta channel first ([[release-channels]], [[quizapp-release]]). The design and its decisions are in [[quizapp-design-doc]] and [[quizapp-adrs]].

## Where it sits in the pipeline
It is Giovanni's main study tool. Its web twin is [[quizweb]], which must behave the same way ([[check-web-sync]]). Releases go out through the [[release-feed]].

## Who receives its output
Giovanni, on the [[phone]]; [[quizweb]] receives its rules, test vectors and translations.
