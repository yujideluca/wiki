---
id: quizweb-i18n
lang: de
source_hash: 62f87536c25f
title: QuizWeb i18n.js und strings.js
aliases: [Web-Sprachen]
---

## What it is
Die Sprachbehandlung des Web-Zwillings, aus der App portiert: welche Sprache gezeigt wird, Textsuche der Oberfläche, Kalendernamen und übersetzte Erklärungstexte.

## What it does
Eine ausdrückliche Wahl gewinnt; sonst die erste angebotene Browsersprache, sonst Englisch. Fragen und Antwortoptionen bleiben deutsch.

## How it does it
`strings.js` wird von [[gen-web-strings]] erzeugt; `i18n/*.json` sind Kopien der Inhaltsübersetzungen der App, verglichen von [[check-web-sync]].

## Where it sits in the pipeline
Benutzt von [[quizweb-app]].

## Who receives its output
[[quizweb-app]].
