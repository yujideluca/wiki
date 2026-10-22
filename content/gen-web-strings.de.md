---
id: gen-web-strings
lang: de
source_hash: 9a7056c33b09
title: gen_web_strings.py
aliases: [Web-Texte-Generator]
---

## What it is
Erzeugt die Oberflächentexte des Web-Zwillings aus den String-Ressourcen der Android-App.

## What it does
Liest `res/values*/strings.xml` (Englisch, Deutsch, Portugiesisch, Spanisch) plus einige reine Web-Texte und schreibt `src/strings.js` von [[quizweb]], damit beide Apps in jeder Sprache dasselbe sagen.

## How it does it
Python; Platzhalter `{0}`, `{1}`…; Englisch ist der Rückfall für alles Fehlende.

## Where it sits in the pipeline
Von den Ressourcen von [[quizapp-app]] zu [[quizweb-i18n]].

## Who receives its output
[[quizweb-i18n]].
