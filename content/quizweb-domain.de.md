---
id: quizweb-domain
lang: de
source_hash: 0e14c608a0a7
title: QuizWeb domain.js
---

## What it is
Die reine Logik von [[quizweb]], aus dem Domain-Paket der Android-App portiert: Planer, Bewerter, Warteschlange, Sitzung, Tagesziel und Kalender.

## What it does
Verhält sich genau wie [[spaced-repetition-scheduler]], [[answer-grader]] und [[study-pipeline]]; `MODES` listet die fünf Modi.

## How it does it
Kein DOM, kein Speicher, kein Uhrzugriff; Gleichheit mit der App belegt durch die gemeinsamen Vektoren von [[quizweb-conformance]] und durch [[mutation-check]].

## Where it sits in the pipeline
Die innere Schicht des Web-Zwillings; nur [[quizweb-controller]] ruft sie auf.

## Who receives its output
[[quizweb-controller]].
