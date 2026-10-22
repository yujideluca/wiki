---
id: card-factory
lang: de
source_hash: badb4960a1a6
title: CardFactory
aliases: [Karten]
---

## What it is
Macht aus Vokabeleinträgen `Card`s, die Lerneinheit: `id`, `mode`, `prompt`, optional `context`, `choices`, `correctChoice`, `explanation`.

## What it does
Eine Funktion pro Modus ([[game-modes]]): Artikel, Präposition, Plural, Präteritum (`preteriteCard`) und Fehler finden (`errorCard`, dessen Auswahl die Satzteile sind). Alle Modi liefern dieselbe Form, deshalb bleibt die Engine modusunabhängig.

## How it does it
Liest geparste Einträge aus [[vocab-assets]] und holt die falschen Optionen bei [[distractor-factory]].

## Where it sits in the pipeline
Erster Schritt der Inhaltspipeline: Vokabeln → Karten → Warteschlange.

## Who receives its output
[[study-pipeline]] (über [[study-controller]]).
