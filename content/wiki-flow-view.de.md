---
id: wiki-flow-view
lang: de
source_hash: 158fcc8ee8ad
title: Flussdiagramm-Ansicht
---

## What it is
Die Flussdiagramm-Ansicht macht aus dem Abschnitt `Flow` einer Seite ein Bild, das von oben nach unten gelesen wird. Ein Flussdiagramm ist ein Diagramm aus Kästen, die durch Pfeile verbunden sind und zeigt, in welcher Reihenfolge Dinge geschehen.

## What it does
Es zeigt, wie ein großes Konzept ausgelöst wird (oben), was es einbindet (die Kästen dazwischen, mit Rauten für Fragen, die die Kette verzweigen) und was es erzeugt (die Doppelkästen unten). Jeder Kasten ist nach der Art der ersten Seite gefärbt, auf die er verweist, und die Seitennamen in einem Kasten öffnen diese Seiten. Eine Legende unter dem Diagramm benennt die Formen. Das Diagramm ist so breit wie nötig; auf dem Handy scrollt es seitlich in seinem Kasten. Auf der Serverseite weist [[wiki-check]] einen Ablauf zurück, der sich nicht sinnvoll zeichnen lässt: kein Startkasten oder kein Endprodukt, ein Kasten, zu dem nichts führt, eine Frage ohne beschriftete Antworten, eine Schleife oder ein Link auf eine nicht vorhandene Seite. Derselbe Code zeichnet die beiden C4-Diagramme des Abschnitts `## Architecture` einer Projektseite (`Flow.parseLevels` und `FlowView.viewArchitecture`), mit Formen für Person, System, Container, Datenspeicher und fremdes System.

## How it does it
Der Text hat eine Zeile je Kasten (`trigger`, `step`, `decide` oder `product`, eine Kennung, eine Beschriftung und `| [[page]]`-Links) und eine Zeile je Pfeil (`a -> b`, oder `d -ja-> b` für eine Antwort). Er wird zweimal gelesen, von `Wiki.Content.Flow` für die Prüfungen und von `Flow.elm` fürs Zeichnen; beide werden am selben Beispiel getestet. `FlowLayout.layout` setzt jeden Kasten in eine Zeile unter den letzten Kasten, der zu ihm führt, fügt in jeder Zeile, die ein Pfeil überspringt, einen unsichtbaren Zwischenhalt ein, ordnet jede Zeile nach dem mittleren Platz ihrer Nachbarn (die Schwerpunktmethode) und legt dann die Spalten so fest, dass verbundene Kästen im Rahmen des Abstands untereinander stehen (eine Anpassung nach kleinsten Quadraten, isotone Regression genannt). `FlowView` zeichnet das Ergebnis als SVG (Scalable Vector Graphics, ein Bildformat aus Formen), die Pfeile mit `Shape.bumpYCurve` der Bibliothek elm-visualization. Absichtlich wird kein Layout-Paket benutzt: Diese Bibliothek hat kein geschichtetes Graph-Layout, und ein kleines fremdes Paket, das irgendwann nicht mehr funktioniert, galt als größeres Risiko als etwa 500 Zeilen eigener Code (ADR-0007; ein ADR ist ein „Architecture Decision Record“, eine kurze Notiz, die die Gründe einer Entscheidung festhält).

## Where it sits in the pipeline
Im [[wiki-frontend]], aufgerufen von [[wiki-article-view]] für den Abschnitt `flow`.

## Who receives its output
[[wiki-article-view]] und darüber der Leser.

## Functions
- `Flow.parse`: liest den Abschnittstext in Kästen und Pfeile.
- `FlowLayout.layout`: gibt jedem Kasten seinen Platz und jedem Pfeil seinen Weg.
- `FlowView.view`: zeichnet das Diagramm und seine Legende.
