---
id: quizweb-controller
lang: de
source_hash: 1de898c1d8ca
title: QuizWeb controller.js
---

## What it is
Der Anwendungsdienst des Web-Zwillings: das Web-Gegenstück zu [[study-controller]].

## What it does
Verbindet Stapel, Speicher und Uhr mit den reinen Funktionen von [[quizweb-domain]]: Sitzungen, Antworten, Pausieren, Suche, Tagesfortschritt, Kalender.

## How it does it
Kein DOM; nimmt jeden Speicher mit der richtigen Form (`createMemoryStore` in Tests, [[quizweb-store]] im Browser).

## Where it sits in the pipeline
Zwischen [[quizweb-app]] (Oberfläche) und [[quizweb-domain]].

## Who receives its output
[[quizweb-app]].
