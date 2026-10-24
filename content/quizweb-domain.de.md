---
id: quizweb-domain
lang: de
source_hash: cb1f4a58db7e
title: QuizWeb domain.js
---

## What it is
`domain.js` ist die reine Logik von [[quizweb]], aus dem Domänenpaket der Android-App übertragen: Scheduler, Bewerter, Warteschlangen-Pipeline, Sitzungsmaschine, Tagesziel und Kalender. „Rein“ heißt: dieselbe Eingabe ergibt immer dieselbe Ausgabe, und nichts anderes wird berührt.

## What it does
Sie verhält sich genau wie der [[spaced-repetition-scheduler]], der [[answer-grader]] und die [[study-pipeline]] der App. `MODES` listet die fünf Modi.

## How it does it
Sie hat kein DOM (Document Object Model, das Modell des Browsers von einer Webseite), keinen Speicher und keinen Zugriff auf die Uhr. Dass sie der App gleicht, belegen die gemeinsamen Vektoren aus [[quizweb-conformance]] und der [[mutation-check]].

## Where it sits in the pipeline
Die innere Schicht des Web-Zwillings; nur der [[quizweb-controller]] ruft sie auf.

## Who receives its output
Der [[quizweb-controller]].
