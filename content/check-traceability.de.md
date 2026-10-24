---
id: check-traceability
lang: de
source_hash: 7feb1ba28744
title: pipeline-check --traceability
---

## What it is
Anforderungsrückverfolgung heißt, jedes Versprechen eines Programms bis zu dem Test verfolgen zu können, der es prüft. Diese Prüfung gilt für alle Projekte: Jede Anforderung hat einen Test, und jedes Test-Tag nennt eine echte Anforderung.

## What it does
Sie liest die Anforderungs-IDs aus `docs/REQUIREMENTS.md`, sammelt die `REQ <ID>`-Tags (Kommentare wie `REQ GR-1`) aus den Testordnern und schlägt fehl, wenn eine Anforderung keinen getaggten Test hat oder ein Tag eine nicht existierende Anforderung nennt. Sie schreibt `docs/TRACEABILITY.md`, eine Tabelle, die jede Anforderung ihren Testdateien zuordnet.

## How it does it
Sie ist ein Unterbefehl des Programms [[pipeline-check]] (in Rust geschrieben, Option `--traceability`, seit Version v0.3.0). Jedes Projekt führt sie über sein eigenes festgelegtes Runner-Skript `tools/pipeline-check.sh` aus; sie ersetzte `check_traceability.py`, das früher in jedes Repository kopiert wurde. Jedes Projekt nennt seine Testordner, Dateiendungen und ein optionales Label in einem Abschnitt `[traceability]` von `pipeline-check.toml` (QuizApp: Kotlin und JavaScript, mit den Tests des Web-Zwillings unter dem Label `web`; das Wiki: Elixir und Elm).

## Where it sits in the pipeline
Schritt 2 jedes Quality Gates.

## Who receives its output
[[template-quality-gate]], [[quizapp-quality-gate]] und [[wiki-quality-gate]].
