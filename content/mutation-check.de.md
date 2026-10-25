---
id: mutation-check
lang: de
source_hash: cb8c15193642
title: Mutationsprüfung
---

## What it is
Mutationstest ([Mutation Testing](https://en.wikipedia.org/wiki/Mutation_testing)) fragt: „Wenn ich das Programm absichtlich kaputt mache, merkt ein Test es?“ `mutation_check.py` baut absichtlich Fehler ein und verlangt, dass für jeden ein Test fehlschlägt. Bleibt ein eingebauter Fehler („Mutant“) unbemerkt, schützen die Tests diese Regel nicht wirklich.

## What it does
Jeder Mutant ändert eine Konstante, einen Vergleich oder eine Bedingung im Scheduler, Bewerter, in der Lernpipeline, Sitzung, im Tagesziel, in der Update-Prüfung, in den Fortschritts- und Trainingsspeichern, im Lernsteuerwerk oder im Lader und Speicher des Fragenpools von [[quizapp]] ([[question-pack]]) oder im Web-Zwilling. Ein überlebender Mutant heißt, dass eine Anforderung nicht wirklich geschützt ist. Die Quelldateien werden danach immer wiederhergestellt.

## How it does it
Ein [Python](https://www.python.org/)-Skript, das für jeden Mutanten die passende Testsuite ausführt (`--web-only` und `--app-only` beschränken es auf eine Seite). Es ist langsam, daher läuft es bei `promote` und jeden Montag in der CI (Continuous Integration, automatische Prüfungen auf GitHub), nicht bei jedem Push.

## Where it sits in the pipeline
Im [[quizapp-quality-gate]], wenn mit `--mutation` aufgerufen, was [[publish-apk]] `promote` tut.

## Who receives its output
Das [[quizapp-quality-gate]].
