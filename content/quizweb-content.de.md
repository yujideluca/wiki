---
id: quizweb-content
lang: de
source_hash: ddd020679780
title: QuizWeb content.js und vocab/
---

## What it is
Vokabeln → Karten und Ablenker für den Web-Zwilling, aus dem Content-Paket der App portiert, dazu die JSON-Dateien in `vocab/` (dieselben wie in der Android-App; `errors.json` entsteht aus ihrer `errors.tsv`).

## What it does
Baut den Stapel: eine Karte pro Wort und Modus, mit denselben deterministischen Ablenkern wie [[distractor-factory]].

## How it does it
Reines ES-Modul; [[check-web-sync]] stellt sicher, dass `vocab/` den [[vocab-assets]] der App gleicht.

## Where it sits in the pipeline
Zwischen der Ausgabe von [[build-vocab]] und [[quizweb-app]], das beim Start den Stapel baut.

## Who receives its output
[[quizweb-app]] (und darüber [[quizweb-controller]]).
