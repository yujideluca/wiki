---
id: quizweb-store
lang: de
source_hash: 9ae898a9446e
title: QuizWeb store.js (localStorage)
---

## What it is
Der Browserspeicher von [[quizweb]]: Fortschritt, Antwortverlauf, Tagesziel, Design und Sprache in `localStorage`.

## What it does
Speichert und lädt alles; Einstellungen > Sicherung exportiert und importiert es, weil es nur im Browser dieses Geräts liegt.

## How it does it
Jeder Zugriff ist abgesichert: Der private Modus von Safari kann Fehler werfen, dann arbeitet die App für die Sitzung mit einer Kopie im Speicher weiter.

## Where it sits in the pipeline
Unter [[quizweb-controller]].

## Who receives its output
[[quizweb-controller]].
