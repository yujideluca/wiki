---
id: study-session
lang: de
source_hash: 99d86b9cf98f
title: StudyEngine / StudySession
---

## What it is
Die `StudySession` (die „Sitzungsmaschine“) ist eine laufende Lernsitzung in [[quizapp]]. Sie wird als unveränderlicher Zustand gehalten (ein Wert, der nie an Ort und Stelle geändert wird) mit reinen Übergängen (jedes Ereignis erzeugt einen neuen Wert, statt den alten zu verändern).

## What it does
Sie kennt die aktuelle Karte, das Feedback zur letzten Antwort und was als Nächstes kommt. Eine Lernkarte, die erneut gezeigt wird, zählt erneut für das [[daily-goal]].

## How it does it
Jedes Ereignis (eine Antwort, „weiter“, ein Pausieren) liefert einen neuen Sitzungswert. Die Reihenfolge der Antwortknöpfe wird bei jeder Wiederholung gemischt, ist aber eingefroren, solange das Feedback angezeigt wird, sodass sich ein Knopf nie unter dem Finger des Spielers bewegt.

## Where it sits in the pipeline
Zwischen der [[study-pipeline]] (die die Warteschlange liefert) und dem [[study-controller]] (der Bewertung und Speichern anwendet).

## Who receives its output
Der [[study-controller]] und über ihn das [[study-view-model]].
