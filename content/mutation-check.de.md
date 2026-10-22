---
id: mutation-check
lang: de
source_hash: a0ef30ec4740
title: Mutationsprüfung
aliases: [Mutanten]
---

## What it is
Eine Prüfung, ob die Tests die Regeln wirklich schützen: Sie baut absichtlich Fehler ein und verlangt, dass für jeden ein Test fehlschlägt.

## What it does
Jeder Mutant ändert eine Konstante, einen Vergleich oder eine Bedingung in Planer, Bewerter, Warteschlange, Sitzung, Speicher oder Web-Zwilling; ein überlebender Mutant heißt, eine Anforderung ist nicht wirklich geschützt. Quelldateien werden immer wiederhergestellt.

## How it does it
Python; führt pro Mutant die passende Testsuite aus (`--web-only`, `--app-only`). Langsam, daher bei `promote` und jeden Montag in der CI, nicht bei jedem Push.

## Where it sits in the pipeline
In [[quizapp-quality-gate]] beim Aufruf mit `--mutation`, wie es `promote` von [[publish-apk]] tut.

## Who receives its output
[[quizapp-quality-gate]].
