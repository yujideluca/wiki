---
id: quizweb-service-worker
lang: de
source_hash: ba1e754f80af
title: QuizWeb Service Worker (Offline-Cache)
---

## What it is
`sw.js` ist der Offline-Cache von [[quizweb]]. Ein [Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) ist ein Skript, das der Browser für eine Webseite im Hintergrund ausführt; er kann Anfragen aus einer gespeicherten Kopie beantworten, und genau das lässt das Quiz nach der Installation ohne Verbindung funktionieren.

## What it does
Er speichert jede Datei der App zwischen. Er versucht zuerst das Netz und nutzt den Cache nur als Offline-Rückfall, sodass ein Deploy beim nächsten Öffnen sichtbar ist. Die Seite lädt einmal neu, wenn ein neuer Worker übernimmt.

## How it does it
Ändert sich eine zwischengespeicherte Datei, muss die Konstante `VERSION` in der Datei erhöht werden, damit installierte Kopien die Änderung bemerken und sich aktualisieren. (Sie ist nur ein Cache-Schlüssel; QuizWeb hat keine eigene Version.)

## Where it sits in the pipeline
Zwischen [[github-pages]] und dem Browser.

## Who receives its output
Der Browser von Giovannis iPhone.
