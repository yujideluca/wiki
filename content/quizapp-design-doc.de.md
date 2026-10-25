---
id: quizapp-design-doc
lang: de
source_hash: 02fbcae7ef90
title: QuizApp DESIGN.md
---

## What it is
`DESIGN.md` ist das lebende Entwurfsdokument von [[quizapp]]: was die App ist, ihre Entwurfsziele, ihre Architektur (C4-Diagramme, eine Art, Software auf mehreren Zoomstufen zu zeichnen, geschrieben in Mermaid), Spaced Repetition, Inhalt, Persistenz, Kartenverwaltung (Karten zurückstellen und entfernen), die Benutzeroberfläche (UI), Sprachen, Debugbarkeit, Tests, das Entscheidungsprotokoll und die bekannten Einschränkungen. „Lebend“ heißt, es wird mit dem Code aktuell gehalten.

## What it does
Es erklärt, wie die App gebaut ist und warum. Jede Zeile des Entscheidungsprotokolls hat einen Typ aus den Wartungskategorien der Norm ISO/IEC/IEEE 14764: korrektiv (einen Fehler beheben), adaptiv (an eine veränderte Umgebung anpassen), perfektiv (verbessern), präventiv (gegen künftige Probleme vorsorgen) oder initial.

## How it does it
Es wird im selben Commit aktualisiert wie jede Änderung an Architektur, Modi, Scheduler oder Bewerter, Persistenz oder UI-Ablauf; strukturelle Entscheidungen bekommen außerdem ein ADR (Architecture Decision Record, [[quizapp-adrs]]). Es wird jeden Monat geprüft ([[monthly-architecture-review]]).

## Where it sits in the pipeline
Neben dem Code, den es beschreibt. Die QuizApp-Seiten dieses Wikis sind großenteils daraus gezogen.

## Who receives its output
Claude (vor Änderungen an der App) und Giovanni.
