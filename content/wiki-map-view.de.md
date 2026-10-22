---
id: wiki-map-view
lang: de
source_hash: 939e487ec841
title: Kartenansicht und Infokästen
aliases: [Systemkarte]
---

## What it is
Die Karte des Startbildschirms: jede Seite als Punkt in der Farbe ihrer Art, Linien für speist (Pfeile) und erwähnt (gestrichelt), darunter die vier Kästen.

## What it does
Über einem Punkt leuchten er und seine Nachbarn golden, der Rest wird blass; die Kästen zeigen Was es ist, Was es tut, Gespeist von und Wer seine Ausgabe erhält (und behalten den letzten Punkt, wenn die Maus geht). Ein Klick öffnet den Artikel. Ziehen verschiebt, Mausrad oder Zwei-Finger-Geste zoomt; Projektfilter und Zeitleiste blenden aus, was nicht dazugehört.

## How it does it
Die Positionen werden einmal mit einer Kräftesimulation berechnet (elm-visualization): verbundene Seiten ziehen sich an, alle stoßen sich ab, Projekte starten als Gruppen. Filter sind reine Funktionen (`Filter.visible`). Zoom und Verschieben kommen aus `Zoom` von elm-visualization; das SVG gibt eine viewBox in seiner Größe an und beginnt oben links im Fenster (die Suchleiste schwebt darüber), sodass Mausrad, Ziehen und Zwei-Finger-Geste um den Zeiger herum zoomen.

## Where it sits in the pipeline
In [[wiki-frontend]], unter `/`.

## Who receives its output
[[wiki-frontend]] (und darüber Giovanni).
