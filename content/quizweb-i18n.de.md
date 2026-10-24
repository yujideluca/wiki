---
id: quizweb-i18n
lang: de
source_hash: b64379cea94a
title: QuizWeb i18n.js und strings.js
---

## What it is
i18n („Internationalisierung“: i, 18 Buchstaben, n) ist der Umgang mit mehreren Sprachen. `i18n.js` und `strings.js` geben [[quizweb]] seine Sprachbehandlung, aus der App übertragen: welche Sprache angezeigt wird, das Nachschlagen von Oberflächentexten, Kalendernamen und übersetzte Erklärtexte.

## What it does
Eine ausdrückliche Wahl des Nutzers gewinnt; sonst wird die erste Browsersprache genommen, die angeboten wird, sonst Englisch. Die Fragen und Antwortoptionen bleiben deutsch.

## How it does it
`strings.js` wird von [[gen-web-strings]] erzeugt; die Dateien `i18n/*.json` sind Kopien der Inhaltsübersetzungen der App, die [[check-web-sync]] vergleicht.

## Where it sits in the pipeline
Benutzt von [[quizweb-app]].

## Who receives its output
[[quizweb-app]].
