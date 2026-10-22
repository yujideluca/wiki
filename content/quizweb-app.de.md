---
id: quizweb-app
lang: de
source_hash: 44a76e50bfb6
title: QuizWeb app.js (Oberfläche)
---

## What it is
Die Oberflächenschicht von [[quizweb]]: zeichnet die Bildschirme und verbindet Tipps mit dem Controller.

## What it does
Start (Kalender, Tagesziel, Modi), Fragen mit Rückmeldung und automatischem Weiter nach 0,5 s, Einstellungen, Sicherung, Liste entfernter Karten mit Suche.

## How it does it
Reines DOM; zusammen mit [[quizweb-store]] der einzige Code, der den Browser berührt (ein Architekturtest erzwingt das). Alle Logik liegt in [[quizweb-domain]].

## Where it sits in the pipeline
Die Spitze des Web-Zwillings, ausgeliefert von [[github-pages]].

## Who receives its output
Giovanni, im Browser.
