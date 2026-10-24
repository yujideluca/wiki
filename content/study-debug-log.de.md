---
id: study-debug-log
lang: de
source_hash: 1d7eb4fd1b00
title: DebugFlags und StudyLog
---

## What it is
Das ist die eingebaute Diagnose von QuizApp: ein Hauptschalter (`DebugFlags`) und typisierte Log-Kanäle (`StudyLog`: CONTENT, PIPELINE, SCHEDULER, SESSION, STORAGE und UI für die Benutzeroberfläche). Ein Log ist ein laufendes Protokoll dessen, was das Programm getan hat, geschrieben, damit ein Entwickler herausfinden kann, was schiefging.

## What it does
Debug-Builds schalten alles ein, Release-Builds alles aus. In Debug-Builds zeigt ein Overlay unter jeder Frage Karten-ID, Note, Antwortzeit, Phasenwechsel, Ease, Intervall, Lapses und Fälligkeitszeit.

## How it does it
Die Logging-Aufrufe sind „faul“: Der Text wird nur gebaut, wenn sein Kanal an ist, sodass abgeschaltete Kanäle nichts kosten. `AndroidStudyLog` schreibt die Meldungen in logcat, das Systemlog von Android, das sich vom Laptop aus mit adb (Android Debug Bridge) lesen lässt.

## Where it sits in the pipeline
Von jeder Schicht von [[quizapp-core]] benutzt; gelesen beim Debug-Durchgang nach dem Programmieren.

## Who receives its output
logcat, gelesen mit [[skill-adb-android-control]].
