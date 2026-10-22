---
id: wiki-article-view
lang: de
source_hash: 14654ceacdd4
title: Artikelansicht
aliases: [Infobox, Pipeline-Leiste]
---

## What it is
Die vollständige Seite eines Begriffs im Stil von Wikipedia (Option A der Entwürfe).

## What it does
Titel und Art, der Einleitungsabsatz, eine Infobox (Art, Projekt, Status, Ort, seit/bis, Quellen, Gedächtniseinträge) mit der Pipeline-Leiste (was es speist → es → wer seine Ausgabe erhält) und einer kleinen Karte verbundener Seiten, dann die Abschnitte mit übersetzten Überschriften und der Verlauf der Seite aus git. Ablaufseiten bekommen ein Schritt-für-Schritt-Diagramm: nummerierte Punkte, der aktuelle Schritt leuchtet, sein Text und die beteiligten Seiten, mit Zurück/Weiter.

## How it does it
Markdown mit elm-markdown gerendert, nachdem `[[id]]`-Links in `/p/<id>` umgeschrieben wurden (MP-3). Zeigt einen Hinweis, wenn eine Seite noch keine Übersetzung hat oder veraltet sein kann.

## Where it sits in the pipeline
In [[wiki-frontend]], unter `/p/<id>`.

## Who receives its output
[[wiki-frontend]].
