---
id: study-debug-log
lang: de
source_hash: 00a1619e3c3b
title: DebugFlags und StudyLog
aliases: [Debug-Overlay]
---

## What it is
Die Diagnose von QuizApp: ein Schalter (`DebugFlags`) und typisierte Log-Kanäle (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE, UI).

## What it does
Debug-Builds schalten alles ein, Release-Builds nichts. Ein Debug-Overlay unter jeder Frage zeigt Karten-ID, Note, Antwortzeit, Phasenwechsel, Leichtigkeit, Abstand, Fehler und Fälligkeit.

## How it does it
Log-Lambdas werden erst bei Bedarf ausgewertet, abgeschaltete Kanäle kosten also nichts; `AndroidStudyLog` schreibt nach logcat.

## Where it sits in the pipeline
Von allen Schichten von [[quizapp-core]] genutzt; beim Debug-Durchgang nach dem Programmieren gelesen.

## Who receives its output
logcat, gelesen mit [[skill-adb-android-control]].
