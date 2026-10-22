---
id: game-modes
lang: de
source_hash: 8b7c4446aa4e
title: Die fünf Spielmodi
aliases: [Modi]
---

## What it is
Die fünf Arten, auf die [[quizapp]] und [[quizweb]] B2-Deutsch abfragen, alle auf einem festen Bestand dessen, was jeder B2-Sprecher können sollte.

## What it does
Der · Die · Das (Artikel von 484 Nomen), Präpositionen (309 Sätze mit fehlender Präposition), Pluralformen (Plural derselben Nomen), Präteritum (er/sie/es-Form von 253 Verben), Fehler finden (den einen falschen Teil in 121 Forumsbeitrags- oder formellen E-Mail-Sätzen antippen, gebaut aus Fehlern, die Giovanni in korrigierten B2-Probeprüfungen gemacht hat).

## How it does it
Jeder Modus ist ein `GameMode`-Wert mit Speicher-ID; alle erzeugen über [[card-factory]] dieselbe `Card`-Form, ein neuer Modus ist also eine kleine Ergänzung. Nur Fehler finden wartet auf „Weiter“ (`autoAdvances = false`).

## Where it sits in the pipeline
Das Menü des Startbildschirms; sie bestimmen, welche Inhaltsdateien [[card-factory]] speisen.

## Who receives its output
[[card-factory]].
