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
---

## What it is
An offline Android app for drilling B2 German with Anki-style spaced repetition. Repo `yujideluca/german-quiz`, folder `~/dev/QuizApp`, package `dev.yuji.quiz`. It is the reference project for how Giovanni's projects are built.

## What it does
Five study modes over a fixed B2 pool ([[game-modes]]): der/die/das, prepositions, plural forms, Präteritum and Fehler finden. Wrong or slow answers return soon; known cards move out to days, weeks and months ([[spaced-repetition-scheduler]]). Daily goal and streak calendar ([[daily-goal]], [[activity-calendar]]), backup ([[progress-backup]]) and in-app updates ([[update-client]]).

## How it does it
Kotlin + Jetpack Compose in two Gradle modules: [[quizapp-core]] (pure Kotlin: scheduler, grader, queue, session, content) and [[quizapp-app]] (Android UI, storage, updates). Content is built from TSV files by [[build-vocab]]. Every change goes requirement → test → code, through [[quizapp-quality-gate]], and reaches the phone via the beta channel first ([[release-channels]], [[quizapp-release]]). Design and decisions: [[quizapp-design-doc]] and [[quizapp-adrs]].

## Where it sits in the pipeline
Giovanni's main study tool; its web twin is [[quizweb]], which must behave the same ([[check-web-sync]]). Releases go out through [[release-feed]].

## Who receives its output
Giovanni on the [[phone]]; [[quizweb]] receives its rules, vectors and translations.
