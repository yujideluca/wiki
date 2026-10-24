---
id: quizweb-store
lang: de
source_hash: f58cb4471767
title: QuizWeb store.js (localStorage)
---

## What it is
`store.js` ist der Browserspeicher von [[quizweb]]. Er hält Fortschritt, Antwortverlauf, Tagesziel, Thema und Sprache in `localStorage` ([localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) ist ein kleiner Schlüssel-Wert-Speicher, den jeder Browser einer Webseite anbietet).

## What it does
Er speichert und lädt alles. Da die Daten nur im Browser dieses Geräts liegen, exportiert und importiert Einstellungen > Sicherung sie.

## How it does it
Jeder Zugriff ist abgesichert: Der private Modus von Safari kann beim Speichern einen Fehler auslösen, und dann läuft die App für diese Sitzung mit einer Kopie im Arbeitsspeicher weiter, statt abzustürzen.

## Where it sits in the pipeline
Unter dem [[quizweb-controller]].

## Who receives its output
Der [[quizweb-controller]].
