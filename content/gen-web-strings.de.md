---
id: gen-web-strings
lang: de
source_hash: ef08b395f9e5
title: gen_web_strings.py
---

## What it is
`gen_web_strings.py` erzeugt den Oberflächentext des Web-Zwillings aus den String-Ressourcen der Android-App. Eine String-Ressource ist eine Datei, in der eine Android-App ihren gesamten Bildschirmtext ablegt, eine Datei pro Sprache.

## What it does
Es liest `res/values*/strings.xml` (Englisch, Deutsch, Portugiesisch, Spanisch) plus einige reine Web-Texte und schreibt `src/strings.js` von [[quizweb]], sodass beide Apps in jeder Sprache dasselbe sagen.

## How it does it
Ein [Python](https://www.python.org/)-Skript. Platzhalter wie `{0}` und `{1}` markieren, wo ein Wert in einen Satz eingesetzt wird; Englisch ist der Rückgriff für alles Fehlende.

## Where it sits in the pipeline
Von den Ressourcen von [[quizapp-app]] zu [[quizweb-i18n]].

## Who receives its output
[[quizweb-i18n]].
