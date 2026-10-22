---
id: quizweb-conformance
lang: de
source_hash: 32a77a64233c
title: Konformitätsvektoren (App = Web)
aliases: [gemeinsame Vektoren]
---

## What it is
Von Hand berechnete Testfälle (`scheduler.json`, `daily_bar.json`), die [[quizapp]] und [[quizweb]] beide bestehen müssen, damit die zwei Umsetzungen nicht auseinanderlaufen.

## What it does
Jeder Vektor ist ein Eingabeverlauf mit dem genau erwarteten Plan oder Fortschrittsbalken.

## How it does it
Dieselben Dateien liegen in beiden Repos; Schritt 4 von [[quizapp-quality-gate]] schlägt fehl, wenn sie nicht byte-gleich sind (`cmp`).

## Where it sits in the pipeline
Zwischen den beiden Domänenschichten: [[spaced-repetition-scheduler]] und [[quizweb-domain]].

## Who receives its output
Beide Testsuiten und [[quizapp-quality-gate]].
