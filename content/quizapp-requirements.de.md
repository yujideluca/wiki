---
id: quizapp-requirements
lang: de
source_hash: 1502c78509ba
title: QuizApp-Anforderungen und Rückverfolgbarkeit
aliases: [REQ-Markierungen]
---

## What it is
Der Katalog aller prüfbaren Versprechen von [[quizapp]], jedes mit einer ID (SP-1 Abstände, GR-1 Bewertung, QU-1 Warteschlange, DG-* Tagesziel, QP-* Fragenbestand…), dazu die Teststrategie in `docs/TESTING.md` (ADR-0008, QS mit Anforderungen zuerst).

## What it does
Sagt, was gelten muss und auf welcher Ebene es getestet wird: Unit, Integration, Eigenschaft, plattformübergreifende Konformität, Abnahme auf einem Gerät, mutationsgeprüft. `docs/TRACEABILITY.md` (erzeugt) ordnet jeder Anforderung ihre Tests zu.

## How it does it
Ein Verhalten, das Giovanni nennt, wird zuerst eine Zeile; dann ein mit `REQ <ID>` markierter Test; dann Code. [[check-traceability]] schlägt fehl, wenn eine Anforderung keinen Test hat.

## Where it sits in the pipeline
Der erste Schritt von [[quizapp-release]].

## Who receives its output
[[check-traceability]] und alle, die Tests schreiben.
