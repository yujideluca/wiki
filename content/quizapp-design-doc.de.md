---
id: quizapp-design-doc
lang: de
source_hash: 3bffac5180ec
title: QuizApp DESIGN.md
aliases: [Entwurfsdokument, Entscheidungslog]
---

## What it is
Das lebende Entwurfsdokument von [[quizapp]]: was die App ist, ihre Architektur (C4-Diagramme in Mermaid), verteilte Wiederholung, Inhalte, Speicherung, Oberfläche, Sprachen, Debugbarkeit, Tests und das Entscheidungslog.

## What it does
Erklärt, wie die App gebaut ist und warum. Jede Zeile im Entscheidungslog hat einen Typ nach ISO/IEC/IEEE 14764 (korrektiv, adaptiv, perfektiv, präventiv, initial).

## How it does it
Im selben Commit aktualisiert wie jede Änderung an Architektur, Modi, Planer/Bewerter, Speicherung oder Bedienablauf; strukturelle Entscheidungen bekommen zusätzlich ein ADR ([[quizapp-adrs]]). Monatlich überprüft ([[monthly-architecture-review]]).

## Where it sits in the pipeline
Neben dem Code, den es beschreibt; die QuizApp-Seiten dieses Wikis stammen großenteils daraus.

## Who receives its output
Claude (bevor es die App ändert) und Giovanni.
