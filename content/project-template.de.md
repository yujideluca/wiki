---
id: project-template
lang: de
source_hash: 67177b954ef2
title: project-template (goldener Pfad)
aliases: [Vorlage]
---

## What it is
Der Ausgangspunkt jedes neuen Softwareprojekts von Giovanni (`~/dev/project-template`, Repo `yujideluca/project-template`), damit der richtige Weg auch der schnellste ist. Gewählt in der Wartungs- und Evolutionsüberprüfung vom 22.10.2026.

## What it does
Gibt einem neuen Projekt ab dem ersten Tag: Prinzipien mit je einer Prüfung, eine Entwurfsdatei mit C4-Diagrammen und Entscheidungslog, ADRs, eine Anforderungsliste mit markierten Tests ([[check-traceability]]), ein Qualitätstor ([[template-quality-gate]]), CI sowie die Richtlinie für technische Schulden und Überprüfungen ([[maintenance-policy]]).

## How it does it
Mit `cp -r` in einen neuen Ordner kopiert; die erste Sitzung füllt CLAUDE.md, DESIGN.md Abschnitt 1, die ersten Anforderungen, die Schritte des Tors und ADR-0002 zum Technologie-Stack, dann wird das private GitHub-Repo mit seinen Labels angelegt ([[new-project]]). Vorher wählt Giovanni die Programmiersprache ([[work-ask-language]]).

## Where it sits in the pipeline
Vor jedem neuen Projekt; QuizApp war die Vorlage, aus der es gewonnen wurde. Dieses [[wiki]] war das erste daraus gestartete Projekt.

## Who receives its output
Neue Projekte wie [[wiki]]; bessere Lösungen aus den Projekten fließen in der [[monthly-architecture-review]] zurück.
