---
id: quizweb-conformance
lang: de
source_hash: d5986c028e3f
title: Konformitätsvektoren (App = Web)
---

## What it is
„Konformitätsvektoren“ sind von Hand berechnete Testfälle, die [[quizapp]] und [[quizweb]] beide bestehen müssen (`scheduler.json`, `daily_bar.json`). Da die beiden Apps in verschiedenen Sprachen geschrieben sind, sorgen die gemeinsamen Fälle dafür, dass die beiden Implementierungen nicht auseinanderdriften können.

## What it does
Jeder Vektor ist ein Eingabeverlauf mit dem genau erwarteten Zeitplan oder Fortschrittsbalken, von Hand ausgerechnet und nicht vom getesteten Code.

## How it does it
Dieselben Dateien liegen in beiden Repositories. Schritt 4 des [[quizapp-quality-gate]] schlägt fehl, wenn sie nicht Byte für Byte identisch sind (geprüft mit `cmp`, einem Befehl, der zwei Dateien vergleicht).

## Where it sits in the pipeline
Zwischen den beiden Domänenschichten: dem [[spaced-repetition-scheduler]] und [[quizweb-domain]].

## Who receives its output
Beide Testsuiten und das [[quizapp-quality-gate]].
