---
id: study-controller
lang: de
source_hash: 2c9ac1cbce0b
title: StudyController
---

## What it is
Der `StudyController` ist der einzige Einstiegspunkt (eine „Fassade“: eine einfache Eingangstür vor vielen Teilen), mit dem die Bildschirme von [[quizapp]] sprechen. Er verbindet Speicher, Uhr, Kartenwarteschlange und Sitzungsmaschine.

## What it does
Er startet Lernsitzungen, hält jede Antwort fest (Note → Terminplan → Speichern), meldet die heutige Zahl für das [[daily-goal]] und kümmert sich um das Pausieren und Entfernen von Karten, das Zurücksetzen des Fortschritts sowie den Import und Export einer Sicherung.

## How it does it
Er ruft die [[card-factory]] für die Karten, die [[study-pipeline]] für die Warteschlange, die [[study-session]] für die laufende Sitzung, den [[answer-grader]] und den [[spaced-repetition-scheduler]] für jede Antwort auf und schreibt über den [[progress-store]] und den [[training-store]]. Er ist durchgehend getestet, auch dass der Fortschritt von einer Sitzung zur nächsten erhalten bleibt.

## Where it sits in the pipeline
Die Mitte der Schichten `ui → StudyController → domain/content/data`.

## Who receives its output
Das [[study-view-model]], das seine Ergebnisse in das verwandelt, was der Bildschirm zeigt.
