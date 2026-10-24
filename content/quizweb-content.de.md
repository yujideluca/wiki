---
id: quizweb-content
lang: de
source_hash: 76699f06c312
title: QuizWeb content.js und vocab/
---

## What it is
`content.js` und der Ordner `vocab/` von [[quizweb]]: der Code, der für den Web-Zwilling Vokabeln in Karten und falsche Optionen verwandelt, aus dem Inhaltspaket der App übertragen, plus die JSON-Dateien in `vocab/` (JSON, JavaScript Object Notation, ist ein Klartext-Datenformat). Es sind dieselben Dateien wie in der Android-App; `errors.json` wird aus `errors.tsv` gebaut.

## What it does
Er baut das Deck: eine Karte pro Wort und Modus, mit denselben deterministischen falschen Optionen wie die [[distractor-factory]].

## How it does it
Es ist ein schlichtes ES-Modul (das Standard-Dateiformat von JavaScript). [[check-web-sync]] stellt sicher, dass `vocab/` den [[vocab-assets]] der App gleicht.

## Where it sits in the pipeline
Zwischen der Ausgabe von [[build-vocab]] und [[quizweb-app]], die das Deck beim Start baut.

## Who receives its output
[[quizweb-app]] (und über sie der [[quizweb-controller]]).
