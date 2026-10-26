---
id: quizweb-controller
lang: de
source_hash: 66b186fb081d
title: QuizWeb controller.js
---

## What it is
`controller.js` ist der Anwendungsdienst des Web-Zwillings: das Gegenstück zum [[study-controller]] der Android-App. Ein Anwendungsdienst ist die Schicht, die Speicher, Logik und Uhr koordiniert, ohne etwas zu zeichnen.

## What it does
Er verbindet Deck, Speicher und Uhr mit den reinen Funktionen aus [[quizweb-domain]]: Sitzungen, Antworten, Pausieren von Karten, Suche, Tagesfortschritt und Kalender.

## How it does it
Er hat kein DOM (Document Object Model, das Modell des Browsers von einer Webseite). Er nimmt jeden Speicher mit der richtigen Form: `createMemoryStore` in den Tests und den [[quizweb-store]] im Browser. Deshalb lässt er sich ohne Browser testen.

## Where it sits in the pipeline
Zwischen [[quizweb-app]] (den Bildschirmen) und [[quizweb-domain]].

## Who receives its output
[[quizweb-app]].

## Notes

`importData` lehnt Sicherungen ab, deren Fortschritt oder Verlauf null oder ein Array ist, und lehnt eine numerische Formatversion größer als 1 ab. Fortschrittseinträge bleiben nur erhalten, wenn ihre Kartenkennung zum Eintragsschlüssel passt; Verlaufswerte nur als positive ganze Zahlen. Ungültige einzelne Einträge werden übersprungen; dies ist eine Filterung und keine vollständige Prüfung aller Fortschrittsfelder.
