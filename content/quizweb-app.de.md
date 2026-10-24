---
id: quizweb-app
lang: de
source_hash: 8ddd998275e8
title: QuizWeb app.js (UI)
---

## What it is
`app.js` ist die Benutzeroberflächen-Schicht von [[quizweb]]: Sie zeichnet die Bildschirme und verbindet Tipps mit dem Controller. (Zusammen mit `index.html` und `style.css` ist es das, was der Browser tatsächlich zeigt.)

## What it does
Sie zeigt den Startbildschirm (Kalender, Tagesziel, Modi), die Fragen mit Feedback und automatischem Weiter nach 0,5 Sekunden, die Einstellungen, die Sicherung und die Liste der entfernten Karten mit Suchfeld.

## How it does it
Sie arbeitet direkt am DOM (Document Object Model: das lebendige Modell des Browsers von einer Webseite, siehe [die Dokumentation](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)), ohne Framework. Zusammen mit dem [[quizweb-store]] ist sie der einzige Code, der den Browser berührt, und ein Architekturtest erzwingt das. Die gesamte Logik liegt in [[quizweb-domain]].

## Where it sits in the pipeline
Die Spitze des Web-Zwillings, ausgeliefert von [[github-pages]].

## Who receives its output
Giovanni, im Browser.
