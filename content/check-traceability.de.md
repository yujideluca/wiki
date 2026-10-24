---
id: check-traceability
lang: de
source_hash: 6c2600619e7c
title: pipeline-check --traceability
aliases: [Rückverfolgbarkeitstor, check_traceability.py]
---

## What it is
Die gemeinsame Rückverfolgbarkeitsprüfung aller Projekte: Jede Anforderung hat einen Test, und jede Test-Markierung nennt eine echte Anforderung.

## What it does
Liest die IDs aus `docs/REQUIREMENTS.md`, sammelt `REQ <ID>`-Markierungen aus den Testordnern, schlägt bei einer Anforderung ohne markierten Test oder einer unbekannten Markierung fehl und schreibt `docs/TRACEABILITY.md` (Anforderung → Testdateien).

## How it does it
Ein Unterbefehl des Programms [[pipeline-check]] (Rust, `--traceability`, seit v0.3.0), den jedes Projekt über sein festgelegtes `tools/pipeline-check.sh` ausführt; er ersetzt das `check_traceability.py`, das früher in jedes Repository kopiert wurde. Jedes Projekt nennt Testordner, Dateiendungen und eine optionale Bezeichnung in einem Abschnitt `[traceability]` der `pipeline-check.toml` (QuizApp: Kotlin und JS, die Tests des Web-Zwillings mit der Bezeichnung `web`; das Wiki: Elixir und Elm).

## Where it sits in the pipeline
Schritt 2 jedes Qualitätstors.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]], [[wiki-quality-gate]].
