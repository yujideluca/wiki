---
id: adr-explained
lang: de
source_hash: cdde1de2d096
title: ADRs und das Entscheidungslog erklärt
---

## What it is
Ein ADR (Architecture Decision Record) ist eine kurze Notiz zu einer wichtigen Entscheidung: Kontext, Entscheidung, erwogene Alternativen und Folgen ([adr.github.io](https://adr.github.io/)). Er beantwortet die Frage, die ein späterer Leser immer hat: „Warum ist es so gebaut?“. Eine Entscheidung, die die Struktur eines Projekts berührt, bekommt einen ADR; eine kleinere bekommt eine Zeile im Entscheidungslog, einer Tabelle in `DESIGN.md`.

## What it does
Jeder ADR ist eine nummerierte Markdown-Datei in `docs/adr/` mit Status, Datum, dem Wartungstyp des Standards ISO/IEC/IEEE 14764 (initial, korrektiv, adaptiv, perfektiv oder präventiv; siehe [[maintenance-policy]]) und dem Entscheider. ADR-0001 ist in jedem Projekt „Entscheidungen als ADRs festhalten“; `0000-template.md` ist das leere Formular. Dieselbe gemeinsame Entscheidung steht in jedem Repository unter eigener Nummer: „Das Programm misst, ein Skill urteilt“ ist 0013 in [[quizapp-adrs]], 0005 im Wiki, 0004 in workflow-memory, 0002 in pipeline-check und 0003 in den übrigen Projekten. Anzahl der ADRs pro Projekt: QuizApp 13, Wiki 10, workflow-memory 7, codex-pbar 5, machine-bootstrap 5, pipeline-check 3, codex-skills 3, radiology-crawler 3, und je 2 in [[project-template]] und status-quo (0001 und 0003).

## How it does it
Nichts prüft den ADR-Text selbst. Die Regel „Entscheidungen stehen dort, wo der Code ist“ ist ein Prinzip in der `CLAUDE.md` jedes Projekts; die monatliche Überprüfung ([[monthly-architecture-review]]) sucht nach Entscheidungen ohne Eintrag. Eine nur im Chat genannte Entscheidung gilt nicht als festgehalten.

## Where it sits in the pipeline
Es ist der letzte Schritt von [[code-security-pipeline]]: Nachdem eine strukturelle Änderung angenommen ist, wird ihr Grund aufgeschrieben. Die Listen pro Projekt stehen auf den `checks-`-Seiten, und die gemeinsame Entscheidung ist in [[maintenance-pipeline]] beschrieben.

## Who receives its output
Spätere Leser: [[giovanni]], Claude-Sitzungen und die [[monthly-architecture-review]].
