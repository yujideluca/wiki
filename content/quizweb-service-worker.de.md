---
id: quizweb-service-worker
lang: de
source_hash: d2d86f142552
title: QuizWeb Service Worker (Offline-Cache)
aliases: [offline]
---

## What it is
`sw.js`: der Offline-Cache, durch den das Webquiz nach der Installation ohne Verbindung funktioniert.

## What it does
Speichert jede Datei der App; zuerst Netz, Cache nur als Offline-Rückfall; die Seite lädt einmal neu, wenn ein neuer Worker übernimmt, sodass eine Veröffentlichung beim nächsten Öffnen sichtbar ist.

## How it does it
Ändert sich eine zwischengespeicherte Datei, muss `VERSION` erhöht werden, damit installierte Kopien aktualisieren.

## Where it sits in the pipeline
Zwischen [[github-pages]] und dem Browser.

## Who receives its output
Der Browser auf Giovannis iPhone.
