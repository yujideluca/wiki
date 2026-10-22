---
id: check-traceability
lang: de
source_hash: 5e813c9bc841
title: check_traceability.py
aliases: [Rückverfolgbarkeitstor]
---

## What it is
Das gemeinsame Rückverfolgbarkeitstor aller Projekte: Jede Anforderung hat einen Test, und jede Test-Markierung nennt eine echte Anforderung.

## What it does
Liest die IDs aus `docs/REQUIREMENTS.md`, sammelt `REQ <ID>`-Markierungen aus den Testordnern, schlägt bei einer Anforderung ohne markierten Test oder einer unbekannten Markierung fehl und schreibt `docs/TRACEABILITY.md` (Anforderung → Testdateien).

## How it does it
Python-Standardbibliothek; jedes Projekt setzt eigene `TEST_DIRS` und Dateiendungen (QuizApp: Kotlin und JS; das Wiki: Elixir und Elm).

## Where it sits in the pipeline
Schritt 2 jedes Qualitätstors.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]], [[wiki-quality-gate]].
