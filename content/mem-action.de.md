---
id: mem-action
lang: de
source_hash: ab40ef21c256
title: mem GitHub Action (mem.yml)
---

## What it is
Der GitHub-Actions-Workflow, der das Gedächtnis stimmig hält, ohne dass ein Rechner von Giovanni eingeschaltet sein muss.

## What it does
Bei jedem Push auf Ereignisse oder Code und einmal täglich (Relevanz verfällt mit der Zeit): führt die Tests aus, stellt ungültige Ereignisse unter Quarantäne, befördert Gewohnheiten aus zwei Projekten, baut [[memory-views]] neu, committet. Erzwingt außerdem, dass Ereignisse nur angehängt werden.

## How it does it
Python 3.12; verschmilzt nie abgeleitete Dateien: Bei einem verlorenen Wettlauf setzt es auf das neueste `main` zurück und leitet neu ab (bis zu fünf Versuche).

## Where it sits in the pipeline
Auf GitHub, nachdem sich [[events-log]] geändert hat.

## Who receives its output
[[memory-views]] (zurück nach `main` committet).
