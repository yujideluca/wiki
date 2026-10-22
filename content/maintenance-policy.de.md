---
id: maintenance-policy
lang: de
source_hash: 5147c4e3a428
title: Wartungsrichtlinie (technische Schulden)
aliases: [Schuldenrichtlinie]
---

## What it is
Wie jedes Projekt bei Änderungen gesund bleibt: Wartungstypen nach ISO/IEC/IEEE 14764, Lehmans Gesetze, Fitnessfunktionen und DORA-Liefermetriken (`docs/MAINTENANCE.md`).

## What it does
Technische Schulden (alles, was heute funktioniert, aber die nächste Änderung langsamer oder riskanter macht) werden ein GitHub-Issue mit Label `debt` und Priorität P1–P3; neue Funktionen bekommen `idea`. Etwa jede fünfte Arbeitssitzung geht an Schulden oder Vorbeugung: Waren die letzten vier Sitzungen nur Funktionen, sagt Claude das und schlägt das wichtigste Schulden-Issue vor; Giovanni entscheidet.

## How it does it
Eine bei der Arbeit gefundene Einschränkung wird in derselben Sitzung ein Issue; die monatliche Überprüfung sieht die Liste durch.

## Where it sits in the pipeline
Teil der Vorlage, in jedes Projekt kopiert.

## Who receives its output
[[monthly-architecture-review]] und jede Claude-Sitzung (über die CLAUDE.md jedes Projekts).
