---
id: mem-action
lang: de
source_hash: 20d2313cf60f
title: GitHub Action des Gedächtnisses (mem.yml)
---

## What it is
Das ist der GitHub-Actions-Workflow `.github/workflows/mem.yml` von [[workflow-memory]]. [GitHub Actions](https://docs.github.com/en/actions) ist GitHubs Dienst, der automatische Aufträge auf eigenen Rechnern ausführt, sodass keine Maschine von Giovanni eingeschaltet sein muss.

## What it does
Er läuft bei jedem Push auf die Ereignisse oder den Code und außerdem einmal täglich (weil die Relevanz alter Einträge mit der Zeit verblasst). Jeder Lauf: führt die Tests aus, verschiebt ungültige Ereignisse in die Quarantäne, befördert Gewohnheiten, die in zwei Projekten auftauchten, zu globalen Vorlieben, erzeugt [[memory-views]] neu und committet das Ergebnis. Außerdem setzt er durch, dass Ereignisse nur angehängt werden (bestehende Dateien werden nie bearbeitet).

## How it does it
Er nutzt Python 3.12. Erzeugte Dateien führt er nie zusammen: Trifft gleichzeitig ein anderer Push ein und wird sein eigener Upload abgelehnt, setzt er auf das neueste `main` zurück und erzeugt erneut (bis zu fünf Versuche).

## Where it sits in the pipeline
Auf GitHub, nachdem sich [[events-log]] geändert hat.

## Who receives its output
[[memory-views]] (zurück auf `main` committet).
